--!nonstrict
-- Keep the native glide state, animation and collision solver. Change its motion
-- before collision resolution; never teleport the hero or write his state number.
local M = {}
local layout = require("layout")
local CROSS, DESCEND = 0x40, 0x4 -- mapped Jump / L1
local TRIGGER = 0x8 -- R1; consume only during Thruster-Pack glide

function M.setup()
    local tps = omni.ticks_per_second() or 50
    local window = math.floor(tps * 0.38 + 0.5)
    local ticks, previous, last_press, grace, taps = 0, false, nil, nil, 0
    local active = false
    local jump, descend, magnitude = false, false, 0
    local warned = false

    local function reset()
        active, last_press, grace, taps = false, nil, nil, 0
        previous = false
        jump, descend, magnitude = false, false, 0
    end

    local function gliding()
        if omni.mode() ~= "gameplay" or omni.fields.hero.state ~= 8 then return nil end
        local base = layout.hero()
        if not base or omni.read("u8", base + 0x20a4) ~= 0
            or omni.read("u8", base + 0x20b3) ~= 0 then return nil end
        -- Equipment slot 3 is the actual worn pack, not merely an owned gadget.
        local pack = bit32.band(omni.read("u32", base + 0x1180), 0x01ffffff)
        if pack < 0x100000 or pack >= 0x2000000 or omni.read("u16", pack + 0xa6) ~= 608 then return nil end
        return base
    end

    local function set_cross(report, down, on)
        down = on and bit32.bor(down, CROSS) or bit32.band(down, bit32.bnot(CROSS))
        local released = bit32.band(bit32.bnot(down), 0xffff)
        buffer.writeu8(report, 0, bit32.rshift(released, 8))
        buffer.writeu8(report, 1, bit32.band(released, 255))
        buffer.writeu8(report, 12, on and 255 or 0)
    end

    omni.on_pad(function(port, report)
        if port ~= 0 then return end
        if omni.mode() == "pause" then return end
        ticks += 1
        local down = bit32.band(bit32.bnot(bit32.bor(bit32.lshift(buffer.readu8(report, 0), 8), buffer.readu8(report, 1))), 0xffff)
        jump = bit32.band(down, CROSS) ~= 0
        descend = bit32.band(down, DESCEND) ~= 0
        local x, y = (buffer.readu8(report, 4) - 128) / 127, (buffer.readu8(report, 5) - 128) / 127
        magnitude = math.min(1, math.sqrt(x*x + y*y))
        if magnitude < 0.18 then magnitude = 0 end
        if not gliding() or omni.setting("free_flight") == false then
            reset()
            return
        end
        local trigger = bit32.band(down, TRIGGER) ~= 0
        if trigger and not previous then
            taps = last_press and ticks - last_press <= window and taps + 1 or 1
            last_press, grace = ticks, ticks + window
            if taps == 3 then
                if omni.has("rac1.player.apply_vertical_motion") then
                    active = not active
                    omni.log("free flight " .. (active and "on" or "off"))
                elseif not warned then
                    warned = true
                    omni.warn("free flight needs the companion flight-support binding next to the player")
                end
                last_press, grace, taps = nil, nil, 0
            end
        end
        previous = trigger
        if trigger then
            -- Native R1 crouches/cancels glide. Swallow it here so the first two
            -- presses cannot interrupt the gesture; outside glide it is untouched.
            down = bit32.band(down, bit32.bnot(TRIGGER))
            set_cross(report, down, jump)
            buffer.writeu8(report, 15, 0)
        end
        if active or (grace and ticks <= grace) then
            -- Keep the native glide alive between taps and while flying hands-off.
            set_cross(report, down, true)
            if active and descend then
                local released = bit32.band(bit32.bnot(bit32.band(bit32.bor(down, CROSS), bit32.bnot(DESCEND))), 0xffff)
                buffer.writeu8(report, 0, bit32.rshift(released, 8))
                buffer.writeu8(report, 1, bit32.band(released, 255))
                buffer.writeu8(report, 14, 0)
            end
        end
    end)

    if omni.has("rac1.player.set_planar_velocity") then
        omni.hook("rac1.player.set_planar_velocity", function(original, angle)
            local base = gliding()
            if not base then return original(angle) end
            local speed_at = base + 0x194
            local old = omni.read("f32", speed_at)
            local factor = math.clamp(omni.setting("hover_speed") or 10, 1, 10)
            local speed = old * factor
            if active then
                speed = 5 * factor * magnitude / tps
                angle = omni.fields.hero.move_yaw
            end
            omni.write("f32", speed_at, speed)
            local ok, result = pcall(original, angle)
            if omni.read("f32", speed_at) == speed then omni.write("f32", speed_at, old) end
            if not ok then error(result, 0) end
            return result
        end)
    end

    if omni.has("rac1.player.apply_vertical_motion") then
        omni.hook("rac1.player.apply_vertical_motion", function(original, destination, source, drop)
            local base = active and gliding() or nil
            if not base or destination ~= base + 0xe0 or source ~= destination then
                return original(destination, source, drop)
            end
            local vertical = (jump and 1 or 0) - (descend and 1 or 0)
            omni.write("f32", source + 8, vertical * 12 / tps)
            -- Retail applies this vector through its normal collision solver later.
            return original(destination, source, 0)
        end)
    end

    omni.on("level_unloading", reset)
    omni.on("save_loaded", reset)
    omni.on("new_game", reset)
    omni.on_frame(function()
        if omni.mode() == "pause" then return end
        if not gliding() then reset() end
    end)
end

return M

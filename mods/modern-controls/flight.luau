--!nonstrict
-- Keep the native glide state, animation and collision solver. Change its motion
-- before collision resolution; never teleport the hero or write his state number.
local M = {}
local layout = require("layout")
local CROSS, DESCEND = 0x40, 0x4 -- mapped Jump / L1
local TRIGGER = 0x8 -- remapped R1 / keyboard Crouch (default: left Ctrl)

function M.setup()
    local tps = omni.ticks_per_second() or 50
    local previous = false
    local active = false
    local jump, descend, magnitude = false, false, 0
    local warned = false

    local function reset()
        active = false
        previous = false
        jump, descend, magnitude = false, false, 0
    end

    local function gliding()
        local state = omni.fields.hero.state
        -- State 8 is airborne gliding; 0x81 is the actual Thruster-Pack hover
        -- observed in this installation. They use different movement routines.
        if omni.mode() ~= "gameplay" or (state ~= 8 and state ~= 0x81) then return nil end
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
            local supported = omni.has("rac1.player.apply_vertical_motion")
            if omni.fields.hero.state == 0x81 then
                supported = supported and (omni.has("rac1.player.hover_planar_motion") or omni.has("rac1.player.hover_planar_motion_alt"))
                    and omni.has("rac1.player.hover_height_spring")
            end
            if supported then
                active = not active
                omni.log("free flight " .. (active and "on" or "off") .. "; state=" .. tostring(omni.fields.hero.state))
            elseif not warned then
                warned = true
                omni.warn("free flight needs the companion flight-support binding next to the player")
            end
        end
        previous = trigger
        if trigger then
            -- R1 toggles flight here instead of the native crouch/cancel action.
            down = bit32.band(down, bit32.bnot(TRIGGER))
            set_cross(report, down, jump)
            buffer.writeu8(report, 15, 0)
        end
        if active then
            down = bit32.band(down, bit32.bnot(DESCEND))
            -- Glide needs held Jump; native hover exits on a fresh Jump, so
            -- consume it there and use the physical input only for ascent.
            set_cross(report, down, omni.fields.hero.state == 8)
            buffer.writeu8(report, 14, 0)
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

    for _, id in ipairs({"rac1.player.hover_planar_motion", "rac1.player.hover_planar_motion_alt"}) do
        if omni.has(id) then omni.hook(id, function(original, acceleration)
            local base = omni.fields.hero.state == 0x81 and gliding() or nil
            if not base then return original(acceleration) end
            local factor = math.clamp(omni.setting("hover_speed") or 10, 1, 10)
            local at = base + 0x190
            local before = omni.read("f32", at)
            local target = before * factor
            omni.write("f32", at, target)
            local ok, result = pcall(original, acceleration * factor)
            if omni.read("f32", at) == target then omni.write("f32", at, before) end
            if not ok then error(result, 0) end
            if active then
                local speed = 5.75 * factor * magnitude / tps
                local yaw = omni.fields.hero.move_yaw
                omni.write("f32", base + 0xe0, math.cos(yaw) * speed)
                omni.write("f32", base + 0xe4, math.sin(yaw) * speed)
            end
            return result
        end) end
    end

    if omni.has("rac1.player.hover_height_spring") then
        omni.hook("rac1.player.hover_height_spring", function(original, position, velocity, target, acceleration, limit, threshold)
            local base = active and omni.fields.hero.state == 0x81 and gliding() or nil
            if not base or position ~= base + 0x88 or velocity ~= base + 0x304 then
                return original(position, velocity, target, acceleration, limit, threshold)
            end
            -- Close to the floor, native hover otherwise locks the hero to its
            -- hover height. Replace only that spring with a collision-tested
            -- velocity; position itself is still advanced by the native solver.
            local vertical = (jump and 1 or 0) - (descend and 1 or 0)
            omni.write("f32", velocity, 0)
            omni.write("f32", base + 0xe8, vertical * 12 / tps)
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

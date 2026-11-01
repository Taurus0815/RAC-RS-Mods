--!nonstrict
local M = {}
local health = require("health_style")
-- Field names and icon names are separate (decoy is decoy_glove in the icon table).
local items = {
    [8] = { "omniwrench", "OMNIWRENCH", "gadget.omniwrench" },
    [9] = { "suck_cannon", "SUCK CANNON", "weapon.suck_cannon" },
    [10] = { "bomb_glove", "BOMB GLOVE", "weapon.bomb_glove" },
    [11] = { "devastator", "DEVASTATOR", "weapon.devastator" },
    [13] = { "visibomb", "VISIBOMB", "weapon.visibomb" },
    [14] = { "taunter", "TAUNTER", "weapon.taunter" },
    [15] = { "blaster", "BLASTER", "weapon.blaster" },
    [16] = { "pyrocitor", "PYROCITOR", "weapon.pyrocitor" },
    [17] = { "mine_glove", "MINE GLOVE", "weapon.mine_glove" },
    [18] = { "walloper", "WALLOPER", "weapon.walloper" },
    [19] = { "tesla_claw", "TESLA CLAW", "weapon.tesla_claw" },
    [20] = { "glove_of_doom", "GLOVE OF DOOM", "weapon.glove_of_doom" },
    [21] = { "morph_o_ray", "MORPH-O-RAY", "weapon.morph_o_ray" },
    [23] = { "ryno", "R.Y.N.O.", "weapon.ryno" },
    [24] = { "drone_device", "DRONE DEVICE", "gadget.drone_device" },
    [25] = { "decoy", "DECOY GLOVE", "weapon.decoy_glove" },
}
local ammo_items = { [9]=true, [10]=true, [11]=true, [13]=true, [15]=true, [16]=true, [17]=true, [19]=true, [20]=true, [23]=true, [24]=true, [25]=true }

function M.setup(state)
    local d, f = omni.draw, omni.fields
    local hud_ok, failures, reported = false, 0, false
    local function own_health()
        return omni.setting("health_source") == "game"
    end
    if omni.has("rac1.omni.hud.health_draw") then
        omni.hook("rac1.omni.hud.health_draw", function(original, elem)
            if not (hud_ok and own_health() and state.hud and omni.setting("modern_hud")) then return original(elem) end
            local e = omni.struct("hud_health", elem)
            if e then return e.result end
            return original(elem)
        end)
    end

    local function draw()
        local s = math.clamp(omni.setting("hud_scale") or 1, 0.8, 1.15)
        if own_health() then health.draw(f.omni.hero.health, f.omni.hero.max_health, nil, s) end
        if omni.setting("show_bolts") then
            -- Covers the stock counter in its original upper-right area.
            local w = 136 * s
            local x = 502 - w
            d.rect(x, 10, w, 44 * s, 0x0A1422FF)
            d.rect(500, 10, 2, 44 * s, 0xBC8CFFFF)
            d.icon(x + 10 * s, 19, 22 * s, 22 * s, "bolt", { tint = 0xE2C5FFFF })
            d.text(490, 14, "BOLTS", { size = 0.4 * s, align = "right", color = 0x90B6CEFF })
            d.text(490, 28, tostring(f.bolts), { size = 0.85 * s, align = "right", color = 0xF0FBFFFF })
        end
        if omni.setting("show_weapon") then
            local id = f.omni.weapon.equipped
            local item = items[id]
            if item then
                -- Preserve the stock XP bar immediately below the ammo box.
                d.rect(10, 8, 150, 34, 0x0A1422FF)
                d.rect(10, 8, 2, 34, 0x4CE7FFFF)
                d.icon(17, 12, 26, 26, item[3], { tint = 0xFFFFFFFF })
                d.text(48, 11, item[2], { size = 0.43, color = 0x90B6CEFF })
                local count = "READY"
                if ammo_items[id] then
                    local weapon = f.omni.weapon[item[1]]
                    count = tostring(weapon.ammo)
                    if id ~= 9 then count ..= " / " .. tostring(weapon.max_ammo) end
                end
                d.text(48, 23, count, { size = 0.8, color = 0xF0FBFFFF })
            end
        end
    end

    omni.on_frame(function()
        hud_ok = false
        if not state.hud or not omni.setting("modern_hud") or omni.mode() ~= "gameplay" then return end
        local ok, err = pcall(draw)
        if ok then
            hud_ok, failures = true, 0
            if not reported then
                reported = true
                omni.log("HUD verified in gameplay; health source=" .. tostring(omni.setting("health_source")))
            end
        else
            failures += 1
            if failures == 1 or failures == 8 then omni.warn("HUD draw failed: " .. tostring(err)) end
        end
    end)
end
return M

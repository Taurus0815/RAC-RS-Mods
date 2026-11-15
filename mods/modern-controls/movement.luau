--!nonstrict
local M = {}
local grounded = { [0] = true, [2] = true }

local function multiplier(key, fallback, upper)
    local v = omni.setting(key)
    return type(v) == "number" and math.clamp(v, 1, upper) or fallback
end

function M.setup(state)
    local accelerated, reported, response = 0, false, 1
    -- Do not hook turning: RAC-RS treats it as replacing the launcher's camera/strafe aim.
    local function enabled()
        return state.movement and omni.setting("modern_movement") ~= false
            and omni.mode() == "gameplay" and grounded[omni.fields.hero.state] == true
    end
    omni.hook("rac1.player.approach_speed", function(original, up, down)
        if enabled() then
            local scale = multiplier("movement_response", 1.6, 8.8)
            response = scale
            up, down = up * scale, down * scale
            accelerated += 1
        end
        return original(up, down)
    end)
    -- One diagnostic after actual use; no file logging inside a movement hook.
    omni.on_frame(function()
        if not reported and accelerated >= 25 then
            reported = true
            omni.log(string.format("movement verified: response=x%.2f; acceleration/braking=%d; launcher camera/strafe aim retained", response, accelerated))
        end
    end)
end
return M

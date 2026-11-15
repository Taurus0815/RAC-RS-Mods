--!nonstrict
-- Modern Controls: gameplay and input changes, with original HUD and menus.
assert(omni.has and omni.has("omni.events"), "RAC-RS events required")

local state = { movement = true }
require("movement").setup(state)
require("controller").setup(state)
require("melee").setup()
require("magnet").setup()
require("slam").setup()
require("survival").setup()
-- Quick Select pause is handled by RAC-RS itself (`qspause=on`), so the native camera
-- can leave persistent Aim while the wheel is open.

local function pressed(binding)
    if type(binding) ~= "string" then return false end
    for key in string.gmatch(binding, "[^,]+") do
        if omni.pressed(string.match(key, "^%s*(.-)%s*$")) then return true end
    end
    return false
end

omni.on_frame(function()
    if omni.mode() ~= "gameplay" then return end
    if pressed(omni.setting("movement_key")) then
        state.movement = not state.movement
        omni.log("modern movement toggle: " .. tostring(state.movement))
    end
end)

omni.log("Modern Controls ready; original HUD and menus retained")

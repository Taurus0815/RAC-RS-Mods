--!nonstrict
-- Rift Modern 0.12.0, matched to RAC-RS 0.4.2/0.4.3 / OmniLoader ABI 1.6.
assert(omni.has and omni.has("omni.events") and omni.has("omni.draw"), "RAC-RS drawing/events required")

local state = { movement = true, hud = true }
local movement = require("movement")
local hud = require("hud")
movement.setup(state)
hud.setup(state)
require("controller").setup(state)
require("menu").setup(state)
require("melee").setup()
require("magnet").setup()
require("slam").setup()
require("wheel").setup(state)
require("camera").setup()

local function pressed(binding)
    if type(binding) ~= "string" then return false end
    for key in string.gmatch(binding, "[^,]+") do
        if omni.pressed(string.match(key, "^%s*(.-)%s*$")) then return true end
    end
    return false
end

-- Keys use the documented USB/W3C names, never Windows virtual-key numbers.
-- A choice of "none" leaves the action to the Mods settings menu.
omni.on_frame(function()
    if omni.mode() ~= "gameplay" then return end
    local mk, hk = omni.setting("movement_key"), omni.setting("hud_key")
    if pressed(mk) then
        state.movement = not state.movement
        omni.log("movement toggle: " .. tostring(state.movement))
    end
    if pressed(hk) then
        state.hud = not state.hud
        omni.log("HUD toggle: " .. tostring(state.hud))
    end
end)
omni.log("Rift Modern 0.12.0 ready; native collision, jump and launcher camera settings retained")

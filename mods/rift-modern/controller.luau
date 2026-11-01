--!nonstrict
-- The native bindings do LT -> aim and RT -> Circle/use weapon BEFORE camera routing.
-- In menus the spare Circle/B is bound to legacy L2. Convert only that bit to Back.
-- Keyboard menu keys never emit L2, so their navigation is left alone.
local M = {}
local layout = require("layout")
local pressure = { 0x2000, 0x8000, 0x1000, 0x4000, 0x10, 0x20, 0x40, 0x80, 4, 8, 1, 2 }
function M.setup(state)
    local reported, throw_reported = false, false
    omni.on_pad(function(port, report)
        if port ~= 0 or state.wheel then return end
        local mode = omni.mode()
        local down = bit32.band(bit32.bnot(bit32.bor(bit32.lshift(buffer.readu8(report, 0), 8), buffer.readu8(report, 1))), 0xFFFF)
        if mode == "gameplay" then
            if omni.setting("aim_wrench_throw") == false or bit32.band(down, 0x80) == 0 then return end
            local base = layout.hero()
            -- The native camera has consumed the physical aim button before on_pad.
            -- This is the real weapon-aim flag, never the double-tap walking latch.
            if not base or omni.read("u8", base + 0x20a4) ~= 0 or omni.read("u32", base + 0x12b0) ~= 1 then return end
            -- Let the original game perform Comet Strike (R1 + Square), including
            -- its wind-up, release, hit checks and return. Preserve other pressures.
            down = bit32.bor(down, 8)
            local released = bit32.band(bit32.bnot(down), 0xFFFF)
            buffer.writeu8(report, 0, bit32.rshift(released, 8))
            buffer.writeu8(report, 1, bit32.band(released, 0xFF))
            buffer.writeu8(report, 15, 255)
            if not throw_reported then
                throw_reported = true
                omni.log("aim + melee routed to native wrench throw")
            end
            return
        end
        if not omni.setting("controller_menu_back") or (mode ~= "pause" and mode ~= "title" and mode ~= "vendor") then return end
        if bit32.band(down, 1) == 0 then return end
        local back = (mode == "pause" and omni.pause_page() == "root") and 0x800 or 0x10
        down = bit32.bor(bit32.band(down, 0xFFFE), back)
        local released = bit32.band(bit32.bnot(down), 0xFFFF)
        buffer.writeu8(report, 0, bit32.rshift(released, 8))
        buffer.writeu8(report, 1, bit32.band(released, 0xFF))
        for k, mask in ipairs(pressure) do
            buffer.writeu8(report, 5 + k, bit32.band(down, mask) ~= 0 and 255 or 0)
        end
        if not reported then
            reported = true
            omni.log("controller menu Back verified")
        end
    end)
end
return M

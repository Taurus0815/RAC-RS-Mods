--!nonstrict
-- Health renderer shared by native-health and optional external-HUD integrations.
local M = {}
function M.draw(hp, maximum, progress, scale)
    local d = omni.draw
    local s = math.clamp(tonumber(scale) or 1, 0.8, 1.15)
    local w, h = 176 * s, 43 * s
    local x, y = 256 - w / 2, 10
    local low = hp <= maximum * 0.25
    local accent = low and 0xFF697EFF or 0x4CE7FFFF
    d.rect(x, y, w, h, 0x0A1422ED)
    d.rect(x, y, 2 * s, h, accent)
    d.icon(x + 9 * s, y + 10 * s, 20 * s, 20 * s, "nanotech", { tint = accent })
    d.text(x + 35 * s, y + 5 * s, "NANOTECH", { size = 0.45 * s, color = 0x90B6CEFF })
    d.text(x + w - 9 * s, y + 4 * s, tostring(math.ceil(hp)) .. " / " .. tostring(math.floor(maximum + 0.5)), { size = 0.72 * s, align = "right", color = 0xF0FBFFFF })
    d.bar(x + 35 * s, y + 21 * s, 130 * s, 7 * s, math.clamp(hp / math.max(1, maximum), 0, 1), accent, 0x263B4DFF)
    if progress ~= nil then
        d.bar(x + 35 * s, y + 34 * s, 109 * s, 2 * s, progress, 0xBC8CFFFF, 0x263B4DFF)
        d.text(x + 148 * s, y + 31 * s, "XP", { size = 0.35 * s, color = 0xB79DE8FF })
    end
end
return M

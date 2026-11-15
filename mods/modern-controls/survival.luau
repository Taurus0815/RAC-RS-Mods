--!nonstrict
-- Standalone gameplay extras for Modern Controls: extra durability, expanded ammo,
-- discounted vendor ammo, multiplied bolt gains and more ammo from crates.
local M = {}

local AMMO = {
    { name = "suck_cannon", id = 9 }, { name = "bomb_glove", id = 10 },
    { name = "devastator", id = 11 }, { name = "visibomb", id = 13 },
    { name = "blaster", id = 15 }, { name = "pyrocitor", id = 16 },
    { name = "mine_glove", id = 17 }, { name = "tesla_claw", id = 19 },
    { name = "glove_of_doom", id = 20 }, { name = "ryno", id = 23 },
    { name = "drone_device", id = 24 }, { name = "decoy", id = 25 },
}

-- Original capacities from RAC-RS's weapon bindings. Never use a previously
-- modified capacity as a new baseline: reloads and other mods must not compound it.
local ORIGINAL_CAPS = {
    bomb_glove = 40, devastator = 20, visibomb = 20, blaster = 200,
    pyrocitor = 240, mine_glove = 50, tesla_claw = 240, glove_of_doom = 10,
    ryno = 50, drone_device = 10, decoy = 20,
}

-- Gadgetron ammo tables from RAC-RS retail/vendor.rs, level order 0..18.
local PRICE_PAL = { 0x1c4030,0x1c4430,0x1c45b0,0x1c40b0,0x1c4130,0x1c44b0,0x1c4730,0x1c4030,0x1c47b0,0x1c4130,0x1c4430,0x1c49b0,0x1c4430,0x1c42b0,0x1c4730,0x1c45b0,0x1c4430,0x1c48b0,0x1c49b0 }
local PRICE_NTSC = { 0x1c40b0,0x1c4530,0x1c46b0,0x1c41b0,0x1c4230,0x1c4530,0x1c4830,0x1c4130,0x1c48b0,0x1c4230,0x1c4530,0x1c4ab0,0x1c4530,0x1c43b0,0x1c47b0,0x1c46b0,0x1c4530,0x1c49b0,0x1c4ab0 }
local BOLT_CAP = 9999999

local retail_prices, written_prices = {}, {}
local last_bolts = nil
local damage_hits = 0
local in_ammo_pickup = false
local dirty = true
local tick = 0

local function clamp_setting(name, default, lo, hi)
    local v = omni.setting(name)
    if type(v) ~= "number" then v = default end
    return math.clamp(v, lo, hi)
end

local function readable_mode()
    local mode = omni.mode()
    return mode == "gameplay" or mode == "pause" or mode == "vendor" or mode == "dialog" or mode == "cutscene" or mode == "ship"
end

local function reset_level()
    retail_prices, written_prices = {}, {}
    dirty = true
end

local function sync_ammo_caps()
    if not readable_mode() then return end
    local mult = clamp_setting("ammo_capacity", 3, 1, 4)
    for _, item in ipairs(AMMO) do
        local ok, current = pcall(function() return omni.fields.omni.weapon[item.name].max_ammo end)
        if ok and type(current) == "number" and current > 0 and ORIGINAL_CAPS[item.name] then
            local base = ORIGINAL_CAPS[item.name]
            local desired = math.min(65535, math.floor(base * mult + 0.5))
            if desired ~= current then
                pcall(function() omni.fields.omni.weapon[item.name].max_ammo = desired end)
            end
            pcall(function()
                local box = omni.fields.omni.hud.ammo_box
                if box.id == 60000 + item.id then
                    box.max = desired
                    box.def_max = desired
                end
            end)
        end
    end
end

local function sync_prices()
    if not readable_mode() then return end
    local bases = (string.lower(tostring(omni.version)) == "ntsc") and PRICE_NTSC or PRICE_PAL
    local base = bases[(omni.level() or -1) + 1]
    if not base then return end
    local mult = clamp_setting("ammo_price_multiplier", 0.5, 0.25, 1)
    for _, item in ipairs(AMMO) do
        local key = item.name
        retail_prices[key] = retail_prices[key] or {}
        written_prices[key] = written_prices[key] or {}
        for _, offset in ipairs({ 8, 10 }) do
            local at = base + item.id * 0x18 + offset
            local ok, current = pcall(function() return omni.read("u16", at) end)
            if ok and type(current) == "number" then
                if written_prices[key][offset] == nil or current ~= written_prices[key][offset] then
                    retail_prices[key][offset] = current
                    written_prices[key][offset] = nil
                end
                local original = retail_prices[key][offset] or current
                local desired = original > 0 and math.max(1, math.floor(original * mult + 0.5)) or 0
                if desired ~= current then
                    pcall(function() omni.write("u16", at, desired) end)
                    written_prices[key][offset] = desired
                end
            end
        end
    end
end

local function multiply_bolts()
    if omni.mode() ~= "gameplay" then return end
    local ok, current = pcall(function() return omni.fields.bolts end)
    if not ok or type(current) ~= "number" then return end
    if last_bolts == nil or current < last_bolts then
        last_bolts = current
        return
    end
    local gained = current - last_bolts
    if gained > 0 then
        local mult = clamp_setting("bolt_pickup_multiplier", 10, 1, 10)
        local desired = math.min(BOLT_CAP, current + math.floor(gained * (mult - 1) + 0.5))
        if desired ~= current then pcall(function() omni.fields.bolts = desired end) end
        last_bolts = desired
    else
        last_bolts = current
    end
end

function M.setup()
    if omni.has("rac1.player.take_damage") then
        omni.hook("rac1.player.take_damage", function(original, amount)
            if amount <= 0 or omni.setting("extra_health") == false then
                damage_hits = 0
                return original(amount)
            end
            damage_hits += 1
            local hits_per_orb = 2
            if damage_hits < hits_per_orb then
                return original(0)
            end
            damage_hits = 0
            return original(amount)
        end)
    end

    if omni.has("rac1.omni.ammo.pickup") and omni.has("rac1.omni.ammo.add") then
        local function inside_pickup(original, ...)
            local was = in_ammo_pickup
            in_ammo_pickup = true
            local ok, result = pcall(original, ...)
            in_ammo_pickup = was
            if not ok then error(result, 0) end
            return result
        end
        omni.hook("rac1.omni.ammo.pickup", function(original, moby) return inside_pickup(original, moby) end)
        if omni.has("rac1.omni.ammo.collect") then
            omni.hook("rac1.omni.ammo.collect", function(original, moby) return inside_pickup(original, moby) end)
        end
        omni.hook("rac1.omni.ammo.add", function(original, item, amount)
            sync_ammo_caps()
            if in_ammo_pickup and type(amount) == "number" and amount > 0 then
                amount = math.min(65535, math.floor(amount * clamp_setting("ammo_pickup_multiplier", 2, 1, 4) + 0.5))
            end
            return original(item, amount)
        end)
    end

    omni.on("level_loaded", reset_level)
    omni.on("new_game", reset_level)
    omni.on("save_loaded", reset_level)
    omni.on("setting", function() dirty = true end)
    omni.on("mode", function() last_bolts = nil end)
    omni.on_frame(function()
        tick += 1
        sync_ammo_caps()
        if dirty or tick % 30 == 0 then
            dirty = false
            sync_prices()
        end
        multiply_bolts()
    end)
    omni.log("Modern Controls: extra health, 3x original ammo capacity, cheaper ammo and 10x bolt gains ready")
end

return M

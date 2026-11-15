--!nonstrict
-- Verify the retail hero layout against named API fields before using private offsets.
-- RAC-RS 0.4.2 normalises this PAL release to the NTSC data layout.
local M = {}
function M.hero()
    local f=omni.fields
    local moby=f.omni.hero.moby
    if type(moby)~="number" or moby<0x100000 or moby>=0x2000000 then return nil end
    local state=f.hero.state
    for _,base in ipairs({0x13f350,0x13f450}) do
        if omni.read("u32",base+0x2080)==moby and omni.read("i32",base+0x2084)==state
            and math.abs(omni.read("f32",base+0x80)-f.hero.position.x)<0.001 then
            return base
        end
    end
    return nil
end
-- New native builds publish the physical aim separately from the manual weapon
-- aim flag, which also follows the camera during latched shoulder walking.
function M.aim_held(base)
    local ok,revision,held=pcall(function()
        return omni.fields.omni.rift.camera_revision,omni.fields.omni.rift.aim_held
    end)
    if ok and type(revision)=="number" and revision>=1 and type(held)=="number" then
        return held==1
    end
    return base~=nil and omni.read("u32",base+0x12b0)==1
end
return M

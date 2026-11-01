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
return M

--!nonstrict
-- Native Bolt_Update compares distance with hero+0x2288 and vertical separation
-- with +0x228c. Apply after the hero's held-item update each tick.
-- Change that tick's reach; native attraction, sound and currency credit remain.
local M={}
local layout=require("layout")
function M.setup()
    if not omni.has("rac1.omni.hero.items_attach") then return end
    local reported=false
    local last={}
    omni.after("rac1.omni.hero.items_attach",function()
        if omni.mode()~="gameplay" then return end
        local b=layout.hero()
        if not b then return end
        local scale=math.clamp(omni.setting("bolt_radius") or 2,1,3)
        for _,offset in ipairs({0x2288,0x228c}) do
            local address=b+offset
            local value=omni.read("f32",address)
            if value>0 and value<40 then
                local old=last[address]
                -- Also tolerate an animation callback called twice in one tick.
                local native=(old and value==old.applied) and old.native or value
                omni.write("f32",address,native*scale)
                last[address]={native=native,applied=omni.read("f32",address)}
            end
        end
        if not reported and scale>1 and omni.read("u8",b+0x20a4)==0 then
            reported=true
            omni.log(string.format("bolt attraction verified: %.2f x, radius %.2f, height %.2f",scale,omni.read("f32",b+0x2288),omni.read("f32",b+0x228c)))
        end
    end)
end
return M

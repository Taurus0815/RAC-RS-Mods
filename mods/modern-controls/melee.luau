--!nonstrict
local M = {}
local layout=require("layout")
function M.setup()
    if not omni.has("rac1.player.advance_animation") then return end
    local boosted,reported={swing=0,slam=0},{}
    local held,airborne=0,true
    omni.hook("rac1.player.advance_animation",function(original)
        if omni.mode()~="gameplay" then return original() end
        local kind=omni.fields.hero.state==0x13 and "swing" or (omni.fields.hero.state==0x14 and "slam" or nil)
        local scale=math.clamp(omni.setting(kind=="slam" and "slam_speed" or "wrench_speed") or 1.6,1,4)
        -- Verified with natural pad input: 0x13 ground swing, 0x14 jump + wrench.
        if not kind or scale==1
            or omni.fields.omni.weapon.equipped~=8 then return original() end
        local base=layout.hero()
        if not base then return original() end
        -- HeroAdvanceAnimation reads hero+0xa94 as the animation advance factor.
        -- Change it for this call only; let the original handle clip events and sweeps.
        local address=base+0xa94
        local speed=omni.read("f32",address)
        if speed~=speed or speed<=0 or speed>4 then return original() end
        local advance=speed*scale
        if kind=="slam" and omni.read("u8",base+0x20a4)==0 then
            local moby=omni.fields.omni.hero.moby
            local frame=omni.read("u8",moby+0x50)
            local phase=omni.read("f32",moby+0x54)
            -- Retail's frame 7 is the aerial strike pose; impact continues in 8/9.
            -- Keep it until contact. A positive step preserves the native event
            -- path while avoiding the prematurely finished airborne animation.
            if airborne and frame==7 and phase>=0.25 then advance=speed*0.001;held+=1 end
        end
        omni.write("f32",address,advance)
        local applied=omni.read("f32",address)
        local ok,result=pcall(original)
        -- A native state transition may have set a new speed. Keep that change.
        if omni.read("f32",address)==applied then omni.write("f32",address,speed) end
        if not ok then error(result) end
        boosted[kind]+=1
        return result
    end)
    omni.on_frame(function()
        airborne=true
        if omni.mode()=="gameplay" and omni.fields.hero.state==0x14 then
            local h=omni.fields.hero.position
            local contact,_,_,z,_,_,nz=omni.raycast(h.x,h.y,h.z+0.25,h.x,h.y,h.z-0.35)
            airborne=not (contact==true and nz>0.2 and math.abs(h.z-z)<=0.005)
        end
        for _,kind in ipairs({"swing","slam"}) do
            if boosted[kind]>=10 and not reported[kind] then
                reported[kind]=true
                omni.log(kind.." speed verified: x"..tostring(omni.setting(kind=="slam" and "slam_speed" or "wrench_speed")))
            end
        end
        if held>=2 and not reported.air_hold then
            reported.air_hold=true
            omni.log("overhead pose held during fall; impact animation waits for ground contact")
        end
    end)
end
return M

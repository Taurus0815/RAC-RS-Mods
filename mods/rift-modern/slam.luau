--!nonstrict
-- One wave on the native overhead landing, using the real wrench hit descriptor.
-- Building a descriptor happens during the airborne wind-up, before impact.
local M={}
function M.setup()
    if not omni.has("rac1.omni.damage.build_hit") then return end
    local post=omni.fn("hit_ring_write")
    local done,pending,last_z,age=false,nil,nil,0
    omni.after("rac1.omni.damage.build_hit",function(damage,attack,attacker,mask,direction)
        local radius=math.clamp(omni.setting("slam_crate_radius") or 6,0,10)
        local enemy_radius=math.clamp(omni.setting("slam_enemy_radius") or 2.5,0,5)
        if done or (radius<=0 and enemy_radius<=0) or omni.mode()~="gameplay" or omni.fields.hero.state~=0x14
            or attacker<0x100000 or attacker>=0x2000000 or attack==0 then return end
        local weapon=omni.struct("moby",attacker)
        if weapon and weapon.class==71 then
            local words={}
            for offset=0,0x20,4 do words[offset/4+1]=omni.read("u32",attack+offset) end
            pending={words=words,radius=radius,enemy_radius=enemy_radius,attacker=attacker}
            age=0
        end
    end)
    omni.on_frame(function()
        local mode=omni.mode()
        if mode~="gameplay" then
            if mode~="pause" then pending=nil;done=false;last_z=nil;age=0 end
            return
        end
        local state=omni.fields.hero.state
        if not pending then
            if state~=0x14 then done=false end
            last_z=nil
            return
        end
        -- At high animation rates state 0x14 can finish in the air, followed by
        -- state 6 (falling). Keep the hit until physical contact, not clip end.
        age+=1
        if (state~=0x14 and state~=0 and state~=2 and state~=6) or age>600 then
            pending=nil;done=false;last_z=nil;return
        end
        local h=omni.fields.hero.position
        local contact,_,_,floor_z,_,_,normal_z=omni.raycast(h.x,h.y,h.z+0.25,h.x,h.y,h.z-0.35)
        local landing=state==0 or state==2 or (state==0x14 and last_z and last_z>=h.z-0.001)
        local grounded=contact==true and normal_z>0.2 and math.abs(h.z-floor_z)<=0.005
        last_z=h.z
        if not grounded or not landing then return end
        -- Melee keeps the aerial pose in frame 7. The visible downstroke follows
        -- in 8/9 after contact; synchronize the extra hit with that impact.
        if state==0x14 and omni.read("u8",omni.fields.omni.hero.moby+0x50)<8 then return end
        local wave=pending;pending=nil;done=true;last_z=nil
        local weapon=omni.struct("moby",wave.attacker)
        if not weapon or weapon.class~=71 then return end
        local crates,enemies=0,0
        local function apply(address)
            omni.with_stack(64,function(desc)
                for i,word in ipairs(wave.words) do omni.write("u32",desc+(i-1)*4,word) end
                post(address,desc)
            end)
        end
        if wave.radius>0 then for _,address in ipairs(omni.mobys{near={h.x,h.y,h.z},radius=wave.radius,max=64}) do
            local m=omni.struct("moby",address)
            -- Type 9 is the native crate class family (SDK moby.class_ptr).
            if m and m.class_ptr>=0x100000 and m.class_ptr<0x2000000
                and omni.read("i16",m.class_ptr+0x46)==9 and m.hit_slot==255
                and math.abs(m.z-h.z)<=2.5 then
                apply(address)
                crates+=1
            end
        end end
        if wave.enemy_radius>0 then for _,address in ipairs(omni.mobys{enemy=true,near={h.x,h.y,h.z},radius=wave.enemy_radius,max=32}) do
            local m=omni.struct("moby",address)
            if m and m.hit_slot==255 and math.abs(m.z-h.z)<=1.5 then
                apply(address)
                enemies+=1
            end
        end end
        if crates+enemies>0 then
            omni.log(string.format("overhead ground impact at z=%.3f: %d crates (%.1f m), %d enemies (%.1f m)",h.z,crates,wave.radius,enemies,wave.enemy_radius))
        end
    end)
end
return M

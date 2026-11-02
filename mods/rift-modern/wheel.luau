--!nonstrict
-- A real native Pause, with an independent radial selector above the pause page.
-- Native game logic, enemies and projectiles stop; only the menu/input continues.
local M={}
local layout=require("layout")
local pause_view=require("pause_view")
local art={}
for _,name in ipairs(omni.draw.icons()) do art[name]=true end
-- Retail wheel footprint: left of Ratchet, centre (128,208) in 512x448 HUD space.
local cx,cy=128,208
local pressure={0x2000,0x8000,0x1000,0x4000,0x10,0x20,0x40,0x80,4,8,1,2}
local items={
 [8]={"OMNIWRENCH","gadget.omniwrench"},[9]={"SUCK CANNON","weapon.suck_cannon"},
 [10]={"BOMB GLOVE","weapon.bomb_glove"},[11]={"DEVASTATOR","weapon.devastator"},
 [12]={"SWINGSHOT","gadget.swingshot"},[13]={"VISIBOMB","weapon.visibomb"},
 [14]={"TAUNTER","weapon.taunter"},[15]={"BLASTER","weapon.blaster"},
 [16]={"PYROCITOR","weapon.pyrocitor"},[17]={"MINE GLOVE","weapon.mine_glove"},
 [18]={"WALLOPER","weapon.walloper"},[19]={"TESLA CLAW","weapon.tesla_claw"},
 [20]={"GLOVE OF DOOM","weapon.glove_of_doom"},[21]={"MORPH-O-RAY","weapon.morph_o_ray"},
 [22]={"HYDRODISPLACER","gadget.hydrodisplacer"},[23]={"R.Y.N.O.","weapon.ryno"},
 [24]={"DRONE DEVICE","gadget.drone_device"},[25]={"DECOY GLOVE","weapon.decoy_glove"},
 [26]={"TRESPASSER","gadget.trespasser"},
}
local function buttons(r)
    return bit32.band(bit32.bnot(bit32.bor(bit32.lshift(buffer.readu8(r,0),8),buffer.readu8(r,1))),0xffff)
end
local function set(r,down)
    local released=bit32.band(bit32.bnot(down),0xffff)
    buffer.writeu8(r,0,bit32.rshift(released,8));buffer.writeu8(r,1,bit32.band(released,255))
    for i=2,5 do buffer.writeu8(r,i,128) end
    for i,mask in ipairs(pressure) do buffer.writeu8(r,5+i,bit32.band(down,mask)~=0 and 255 or 0) end
end
local function entries(base)
    local slots={}
    local count=0
    for i=0,7 do
        -- The SDK exposes dotted numeric names inconsistently as table paths.
        -- This array offset is the binding's 0x141ea0, relative to the verified hero base.
        local id=omni.read("i32",base+0x2b50+i*4)
        if type(id)~="number" or id<0 or id>36 then return nil end
        slots[i+1]=id
        if id>1 then count+=1 end
    end
    return count>0 and slots or nil
end
local function choose(w,x,y)
    if x*x+y*y<1600 then return end
    local sector=(math.floor(math.atan2(x,-y)/(math.pi/4)+0.5)%8)+1
    if w.slots[sector]>1 then w.selected=sector end
end

-- Cache horizontal ring spans. A true eight-sector ring without a solid panel;
-- drawing uses only the loader's supported rectangles and native item icons.
local bands={}
local tan=math.tan(math.pi/8)
if not art["rift.wheel.base"] then
for y=-92,91 do
    local mid=y+0.5
    local outer=math.sqrt(math.max(0,92*92-mid*mid))
    local inner=math.sqrt(math.max(0,49*49-mid*mid))
    local cuts={-outer,outer}
    if inner>0 then table.insert(cuts,-inner);table.insert(cuts,inner) end
    for _,x in ipairs({mid*tan,-mid*tan,mid/tan,-mid/tan}) do
        if x>-outer and x<outer then table.insert(cuts,x) end
    end
    table.sort(cuts)
    for k=1,#cuts-1 do
        local a,b=cuts[k],cuts[k+1]
        local x=(a+b)/2
        if b-a>1 and x*x+mid*mid>=49*49 then
            local sector=(math.floor(math.atan2(x,-mid)/(math.pi/4)+0.5)%8)+1
            table.insert(bands,{x=a+0.45,y=y,w=b-a-0.9,sector=sector})
        end
    end
end
end
local function draw(w)
    local d=omni.draw
    local layer={layer="menu"}
    if art["rift.wheel.base"] then
        d.icon(cx-92,cy-92,184,184,"rift.wheel.base",{tint=0xFFFFFFFF,layer="menu"})
        d.icon(cx-92,cy-92,184,184,"rift.wheel.focus."..(w.selected-1),{tint=0xFFFFFFFF,layer="menu"})
    else
        for _,b in ipairs(bands) do
            local active=b.sector==w.selected
            local filled=w.slots[b.sector]>1
            d.rect(cx+b.x,cy+b.y,b.w,1,active and 0x1B6385EC or (filled and 0x0B2135DE or 0x0A182894),layer)
        end
    end
    for i,id in ipairs(w.slots) do
        local angle=(i-1)*math.pi/4
        local x,y=cx+math.sin(angle)*71,cy-math.cos(angle)*71
        if id>1 then
            if art["rift.item."..id] then
                d.icon(x-22,y-22,44,44,"rift.item."..id,{tint=0xFFFFFFFF,layer="menu"})
            else
                local icon=(items[id] and items[id][2]) or ("item."..id)
                if string.sub(icon,1,7)=="weapon." then icon..=".hud" end
                d.icon(x-12,y-12,24,24,icon,{tint=0xFFFFFFFF,layer="menu"})
            end
        else
            d.rect(x-2,y-1,4,2,0x637B9560,layer)
        end
        if i==w.selected then
            -- Thin cyan accent outside the selected sector, keeping its icon clear.
            local ox,oy=cx+math.sin(angle)*88,cy-math.cos(angle)*88
            d.rect(ox-3,oy-2,6,4,0x4CE7FFFF,layer)
        end
    end
    local id=w.slots[w.selected]
    if art["rift.item."..id] then
        d.text(cx,cy-41,"PAUSIERT",{size=0.4,align="center",color=0xA9D5E8FF,shadow=0x071321FF,layer="menu"})
        d.icon(cx-31,cy-31,62,62,"rift.item."..id,{tint=0xFFFFFFFF,layer="menu"})
    else
        d.text(cx,cy-8,"PAUSIERT",{size=0.42,align="center",color=0xD6F6FFFF,shadow=0x071321FF,layer="menu"})
    end
    d.text(cx,cy+104,(items[id] and items[id][1]) or ("ITEM "..id),{size=0.46,align="center",color=0xF0FBFFFF,shadow=0x071321FF,layer="menu"})
end

function M.setup(state)
    local previous,consumed=false,false
    local warned=false
    local native_ready,native_fade=nil,nil
    local guard_api,guard_field=pcall(function() return omni.fields.omni.rift.wheel_draw_guard end)
    guard_api=guard_api and type(guard_field)=="number"
    -- Older native builds registered gameplay routines by an ambiguous address
    -- text match. Never enable that guard; retain the fade fallback instead.
    local function native_guard()
        if not guard_api or omni.fields.omni.rift.wheel_draw_guard~=1 then return false end
        local ok,revision=pcall(function() return omni.fields.omni.rift.wheel_guard_revision end)
        return ok and type(revision)=="number" and revision>=2
    end
    local function request_guard()
        if guard_api then
            local wanted=omni.setting("pause_wheel") and native_guard() and 1 or 0
            if omni.fields.omni.rift.hide_original_wheel~=wanted then omni.fields.omni.rift.hide_original_wheel=wanted end
        end
    end
    -- Let retail resolve Triangle's contextual action and original hold delay.
    -- Only take over after its own Quick Select HUD has actually begun opening.
    if omni.has("rac1.omni.weapon.quick_select") then
        omni.before("rac1.omni.weapon.quick_select",function(element)
            -- Preserve the original opening clock for the update, then hide only
            -- its drawing fade before the separate HUD draw runs.
            if native_fade and native_fade.element==element and native_fade.level==omni.level() then
                omni.write("u8",element+0x70,native_fade.fade)
            end
            native_fade=nil
        end)
        omni.after("rac1.omni.weapon.quick_select",function(element)
            if element<0x100000 or element>=0x2000000 then native_ready=nil;return end
            if not omni.setting("pause_wheel") then native_ready=nil;return end
            local fade=omni.read("u8",element+0x70)
            if not state.wheel and not consumed and omni.mode()=="gameplay" then
                native_ready=fade>=8 and {element=element,level=omni.level()} or nil
                if fade>0 and not native_guard() then native_fade={element=element,level=omni.level(),fade=fade} end
            else native_ready=nil end
            if native_guard() then return end
            -- Includes short taps, fading out, airborne use and the takeover frame.
            -- A partial original wheel must never flash behind the custom wheel.
            omni.write("u8",element+0x70,0)
        end)
    end
    if omni.has("rac1.omni.vendor.open") then
        omni.after("rac1.omni.vendor.open",function()
            native_ready=nil;native_fade=nil
            -- Vendor opening can animate for a few ticks before mode=vendor.
            -- Once accepted, this same Triangle hold belongs to that interaction.
            if not state.wheel then consumed=true end
        end)
    end
    local function pad(port,r)
        if port~=0 then return end
        request_guard()
        local down=buttons(r)
        local held=bit32.band(down,0x10)~=0
        local mode=omni.mode()
        local w=state.wheel
        if not held then native_ready=nil;consumed=false end
        if not w and consumed and held then
            -- A cancelled/finished hold cannot reopen either wheel before release.
            -- Remove only Triangle; preserve movement and every other button.
            local released=bit32.band(bit32.bnot(bit32.band(down,0xffef)),0xffff)
            buffer.writeu8(r,0,bit32.rshift(released,8));buffer.writeu8(r,1,bit32.band(released,255))
            buffer.writeu8(r,10,0)
            previous=held
            return
        end
        -- The first report always reaches the game, including a fresh press
        -- while an earlier wheel is fading out: vendors/interactions get priority.
        if not w and not consumed and held and previous and native_ready and native_ready.level==omni.level()
            and omni.setting("pause_wheel") and mode=="gameplay" then
            local base=layout.hero()
            local slots=base and entries(base) or nil
            if base and slots and omni.read("u8",base+0x20a4)==0 then
                local selected=1
                local equipped=omni.fields.omni.weapon.equipped
                for i,id in ipairs(slots) do if id==equipped then selected=i;break elseif id>1 then selected=i end end
                w={phase="opening",age=0,slots=slots,selected=selected,base=base,mx=0,my=0,request=false,resume=0}
                state.wheel=w
                if pause_view.begin(w) then
                    consumed=true
                    -- The custom paused wheel now owns the display and commit.
                    -- Retire retail's fade so it cannot commit a stale selection on resume.
                    omni.write("u8",native_ready.element+0x70,0)
                    native_ready=nil;native_fade=nil
                    omni.log("quick select opening: original native hold accepted")
                    set(r,0x800)
                else
                    state.wheel=nil
                end
            end
        elseif w then
            if mode~="pause" and mode~="gameplay" then pause_view.restore(w);state.wheel=nil;previous=held;return end
            if not held or bit32.band(down,0x801)~=0 then
                w.cancel=w.cancel or bit32.band(down,0x801)~=0
                w.closing=true
            end
            choose(w,buffer.readu8(r,4)-128,buffer.readu8(r,5)-128)
            if bit32.band(down,0x1000)~=0 then choose(w,0,-127)
            elseif bit32.band(down,0x2000)~=0 then choose(w,127,0)
            elseif bit32.band(down,0x4000)~=0 then choose(w,0,127)
            elseif bit32.band(down,0x8000)~=0 then choose(w,-127,0) end
            local out=0
            if w.resume>0 then out=0x800;w.resume-=1 end
            set(r,out)
        end
        previous=held
    end
    omni.on_pad(function(port,r)
        local ok,err=pcall(pad,port,r)
        if not ok then
            pause_view.restore(state.wheel)
            state.wheel=nil
            if not warned then warned=true;omni.warn("paused wheel input failed: "..tostring(err)) end
        end
    end)

    local function frame()
        request_guard()
        pause_view.scan()
        local w=state.wheel
        if not w then return end
        local mode=omni.mode()
        w.age+=1
        if mode=="pause" and omni.pause_page()=="root" then
            pause_view.hide(w)
            if w.phase=="opening" then
                w.phase="active"
                w.pause_age=0
                omni.log("quick select paused: native Pause mode entered")
            end
            w.pause_age+=1
            -- Pointer coordinates are in the same 512x448 space as the wheel.
            -- Accept the table and multiple-return shapes used by compatible loaders.
            local ok,p,q,inside=pcall(omni.pointer)
            if ok then
                local x,y=p,q
                if type(p)=="table" then x,y,inside=p.x or p[1],p.y or p[2],p.inside or p[3] end
                if type(x)=="number" and type(y)=="number" and (inside==true or inside==1) then
                    if w.px and w.pause_age>6 and math.abs(x-w.px)+math.abs(y-w.py)>2 then choose(w,x-cx,y-cy) end
                    w.px,w.py=x,y
                end
            end
            if w.closing and w.pause_age>=35 and not w.request then
                local base=layout.hero()
                local id=w.slots[w.selected]
                if not w.cancel and base==w.base and id>1 then
                    -- Same request word written by native QuickSelect_Update on release.
                    -- The hero applies it through his normal item-switch path after resume.
                    omni.write("i32",base+0x20b8,id)
                    w.expected=id
                end
                w.request=true
                w.resume=3
            end
            draw(w)
        elseif mode=="gameplay" and w.phase=="active" and w.request then
            pause_view.restore(w)
            omni.log("quick select resumed: requested="..tostring(w.expected)..", equipped="..tostring(omni.fields.omni.weapon.equipped))
            state.wheel=nil
        elseif w.age>180 and w.phase=="opening" then
            pause_view.restore(w)
            state.wheel=nil
            omni.warn("paused wheel: native pause did not open; original controls restored")
        elseif mode~="gameplay" and mode~="pause" then pause_view.restore(w);state.wheel=nil end
    end
    omni.on_frame(function()
        local ok,err=pcall(frame)
        if not ok then
            pause_view.restore(state.wheel)
            state.wheel=nil
            if not warned then warned=true;omni.warn("paused wheel display failed: "..tostring(err)) end
        end
    end)
end
return M

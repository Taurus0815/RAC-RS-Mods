--!nonstrict
-- Presentation only: read the same menu records used by RAC-RS's mouse menu.
-- Native UI skin request changes presentation only; selection, saves and input stay native.
local M = {}
local pal = { 0x1b9cf4,0x1ba0f4,0x1ba274,0x1b9d74,0x1b9df4,0x1ba174,0x1ba3f4,0x1b9cf4,0x1ba474,0x1b9df4,0x1ba0f4,0x1ba674,0x1ba0f4,0x1b9f74,0x1ba3f4,0x1ba274,0x1ba0f4,0x1ba574,0x1ba674 }
local ntsc = { 0x1b9cf4,0x1ba174,0x1ba2f4,0x1b9df4,0x1b9e74,0x1ba174,0x1ba474,0x1b9d74,0x1ba4f4,0x1b9e74,0x1ba174,0x1ba6f4,0x1ba174,0x1b9ff4,0x1ba3f4,0x1ba2f4,0x1ba174,0x1ba5f4,0x1ba6f4 }
local titles = {root="PAUSE",weapons="WAFFEN",gadgets="GADGETS",quick_select="SCHNELLAUSWAHL",items="AUSRUESTUNG",help="HILFE",options="OPTIONEN",goodies="EXTRAS",map="KARTE",quit="SPIEL VERLASSEN",goals="MISSIONEN",moves="BEWEGUNGEN",save="SPEICHERN",load="LADEN",skill_points="SKILL-PUNKTE"}
local labels = { [0x4ee2]="WAFFEN", [0x4ee3]="GADGETS", [0x4ee4]="SCHNELLAUSWAHL", [0x4ee5]="AUSRUESTUNG", [0x4ee6]="HILFE", [0x4ee7]="OPTIONEN", [0x4fc2]="EXTRAS" }
local function ptr(p)
    -- RAC-RS stores its added Graphics/Controls/Mods pages in the PC extension area.
    return type(p)=="number" and p%4==0 and ((p>=0x100000 and p<0x2000000) or (p>=0xb0000 and p<0xc0000))
end
local function u(p) return omni.read("u32",p) end

local function snapshot(all_pages)
    local level = omni.level()
    local pp = (omni.version=="ntsc" and ntsc or pal)[level+1]
    if not pp then return nil end
    local page = u(pp)
    if not ptr(page) then return nil end
    local id=u(page+0x3c)
    -- Wait for the native fly-in to finish; the recorded rects then match the panels.
    if u(pp-4)~=id or (not all_pages and id~=2) then return nil end
    local result = {current=bit32.band(u(page+0x40),0x1ffffff),items={}}
    local seen={}
    for slot=0,13 do
        local item=u(page+0x44+slot*4)
        if ptr(item) and not seen[item] then
            seen[item]=true
            local x,y,w,h=omni.read("i32",item+0x18),omni.read("i32",item+0x1c),omni.read("i32",item+0x20),omni.read("i32",item+0x24)
            local data=u(item+0x34)
            if w>0 and h>0 and w<=512 and h<=448 and x>=0 and y>=0 and x+w<=512 and y+h<=448 then
                local text=ptr(data) and omni.read("u16",data) or 0
                if all_pages or (text>=0x4e00 and text<=0x5700) then
                    table.insert(result.items,{address=item,x=x,y=y,w=w,h=h,text=text,slot=slot})
                end
            end
        end
    end
    return result
end

function M.setup(state)
    local reported, failed, enabled=false,false,true
    local native_ok,field=pcall(function() return omni.fields.omni.rift.menu_style end)
    native_ok=native_ok and type(field)=="number"
    local seen={}
    local function skin(on)
        if native_ok then
            local wanted=on and 1 or 0
            if omni.fields.omni.rift.menu_style~=wanted then omni.fields.omni.rift.menu_style=wanted end
        end
    end
    local d=omni.draw
    local layer={layer="menu"}
    omni.on_frame(function()
        local mode=omni.mode()
        local menu_mode=mode=="pause" or mode=="title" or mode=="vendor" or mode=="dialog"
        local toggle=omni.setting("menu_key") or "KeyU"
        for key in string.gmatch(menu_mode and toggle or "", "[^,]+") do
            if omni.pressed(string.match(key,"^%s*(.-)%s*$")) then enabled=not enabled;break end
        end
        local active=menu_mode and not state.wheel and enabled and omni.setting("modern_menu")~=false and not failed
        skin(active)
        if not active then return end
        local ok,err=pcall(function()
            local page=mode=="pause" and (omni.pause_page() or "root") or mode
            local snap=mode=="pause" and page=="root" and snapshot() or nil
            if not seen[page] then
                seen[page]=true
                omni.log("modern menu skin: "..page.." / native="..tostring(native_ok))
            end
            if snap and not reported and #snap.items>=6 then
                local info={}
                for _,it in ipairs(snap.items) do table.insert(info,string.format("slot%d:text%04x@%d,%d,%d,%d",it.slot,it.text,it.x,it.y,it.w,it.h)) end
                omni.log("pause menu verified: "..table.concat(info,";"))
                reported=true
            end
            -- Keep native page contents and their navigation; frame in the Rift HUD palette.
            d.rect(0,0,512,7,0x071321FF,layer)
            d.rect(0,7,512,2,0x4CE7FFFF,layer)
            d.rect(0,432,512,16,0x071321FF,layer)
            d.rect(0,431,512,1,0xBC8CFFFF,layer)
            d.text(14,435,"RIFT MODERN  /  "..(titles[page] or ({title="START / LADEN / OPTIONEN",vendor="GADGETRON",dialog="BESTAETIGUNG"})[page] or "OPTIONEN"),{size=0.42,color=0xA9D5E8FF,layer="menu"})
            d.text(498,435,"ORIGINALANSICHT: "..string.gsub(toggle,"Key",""),{size=0.38,align="right",color=0xBBA2E8FF,layer="menu"})
            if mode=="pause" and page~="root" then
                local panels=snapshot(true)
                if panels then
                    for _,it in ipairs(panels.items) do
                        if it.w>28 and it.h>15 and it.w<500 and it.h<420 then
                            -- Borders only: native text, icons and 3D previews remain visible.
                            d.rect(it.x,it.y,1,it.h,0x4CE7FFFF,layer)
                            d.rect(it.x+1,it.y,it.w-1,0.6,0x36536AFF,layer)
                            d.rect(it.x+1,it.y+it.h-0.6,it.w-1,0.6,0xBC8CFFFF,layer)
                        end
                    end
                end
            end
            if snap then
                local rows={}
                for _,it in ipairs(snap.items) do if labels[it.text] then table.insert(rows,it) end end
                table.sort(rows,function(a,b) return a.y<b.y end)
                if #rows>=6 then
                    local first,last=rows[1],rows[#rows]
                    d.rect(first.x-12,first.y-32,first.w+24,last.y+last.h-first.y+44,0x071321ED,layer)
                    d.text(first.x,first.y-24,"PAUSE",{size=0.9,color=0xF0FBFFFF,layer="menu"})
                    d.text(first.x+first.w,first.y-18,"RIFT MODERN",{size=0.4,align="right",color=0xBC8CFFFF,layer="menu"})
                end
                for _,it in ipairs(snap.items) do
                    if labels[it.text] then
                        local selected=it.address==snap.current
                        d.rect(it.x,it.y,it.w,it.h,selected and 0x15334BFF or 0x091625FF,layer)
                        d.rect(it.x,it.y,selected and 3 or 1,it.h,selected and 0x4CE7FFFF or 0x36536AFF,layer)
                        d.text(it.x+10,it.y+it.h/2-6,labels[it.text],{size=0.8,color=selected and 0xF0FBFFFF or 0x96AEC0FF,layer="menu"})
                    end
                end
            end
        end)
        if not ok and not failed then failed=true;skin(false);omni.warn("modern menu disabled: "..tostring(err));enabled=false end
    end)
end
return M

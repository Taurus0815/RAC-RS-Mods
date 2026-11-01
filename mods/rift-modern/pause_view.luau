--!nonstrict
-- Use the native neutral panel sequence 0 while the wheel owns the Pause root.
-- Restore the original sequence IDs on resume; never alter frame ownership.
local M={}
local pal={0x1b9cf4,0x1ba0f4,0x1ba274,0x1b9d74,0x1b9df4,0x1ba174,0x1ba3f4,0x1b9cf4,0x1ba474,0x1b9df4,0x1ba0f4,0x1ba674,0x1ba0f4,0x1b9f74,0x1ba3f4,0x1ba274,0x1ba0f4,0x1ba574,0x1ba674}
local ntsc={0x1b9cf4,0x1ba174,0x1ba2f4,0x1b9df4,0x1b9e74,0x1ba174,0x1ba474,0x1b9d74,0x1ba4f4,0x1b9e74,0x1ba174,0x1ba6f4,0x1ba174,0x1b9ff4,0x1ba3f4,0x1ba2f4,0x1ba174,0x1ba5f4,0x1ba6f4}
local function ptr(p) return type(p)=="number" and p>=0x100000 and p<0x2000000 and p%4==0 end
local search={}
local labels={ [0x4ee2]=true,[0x4ee3]=true,[0x4ee4]=true,[0x4ee5]=true,[0x4ee6]=true,[0x4ee7]=true }
local function items(page)
    if not ptr(page) or omni.read("u32",page+0x3c)~=2 then return nil end
    local result,seen,texts={},{},{}
    local count=0
    for slot=0,13 do
        local item=omni.read("u32",page+0x44+slot*4)
        if ptr(item) and not seen[item] then
            seen[item]=true
            local draw=omni.read("u32",item+4)
            if not ptr(draw) then return nil end
            local data=omni.read("u32",item+0x34)
            local text=ptr(data) and omni.read("u16",data) or 0
            if labels[text] and not texts[text] then texts[text]=true;count+=1 end
            table.insert(result,{address=item,draw=draw,bit=bit32.band(omni.read("u32",item+0x10),4)})
        end
    end
    return count==6 and result or nil
end
function M.scan()
    if omni.mode()~="gameplay" then return end
    local level=omni.level()
    local pp=(omni.version=="ntsc" and ntsc or pal)[level+1]
    if not pp then return end
    if search.level~=level then
        search={level=level,pp=pp,next=math.floor(pp/0x10000)*0x10000}
        -- Verified Veldin layout; other layouts use the validated search below.
        if items(pp-0x776c) then search.page=pp-0x776c end
    end
    if search.page then return end
    -- Bounded read-only batches keep discovery within the script time budget.
    for _=1,128 do
        local at=search.next
        if at>=pp-0x100 then return end
        search.next+=4
        if omni.read("u32",at)==2 then
            local page=at-0x3c
            if items(page) then search.page=page;omni.log(string.format("compact wheel root verified: %x",page));return end
        end
    end
end
function M.begin(w)
    if search.level~=omni.level() or not search.page then return false end
    local saved=items(search.page)
    if not saved then return false end
    local sequences={}
    for slot=0,13 do
        local value=omni.read("u32",search.page+slot*4)
        if value>4095 then return false end
        sequences[slot+1]=value
    end
    w.hidden={level=search.level,page=search.page,items=saved,sequences=sequences}
    for slot=0,13 do omni.write("u32",search.page+slot*4,0) end
    return true
end
function M.hide(w)
    local h=w.hidden
    if not h or h.level~=omni.level() then return end
    -- MenuDraw (Veldin 0x276c50+0x304) skips item flag 4 at +0x10.
    for _,it in ipairs(h.items) do
        if omni.read("u32",it.address+4)==it.draw then
            omni.write("u32",it.address+0x10,bit32.bor(omni.read("u32",it.address+0x10),4))
        end
    end
end
function M.restore(w)
    local h=w and w.hidden
    if not h then return end
    if omni.level()==h.level and omni.read("u32",h.page+0x3c)==2 then
        for slot,value in ipairs(h.sequences) do
            if omni.read("u32",h.page+(slot-1)*4)==0 then omni.write("u32",h.page+(slot-1)*4,value) end
        end
        for _,it in ipairs(h.items) do
            if omni.read("u32",it.address+4)==it.draw then
                local flags=omni.read("u32",it.address+0x10)
                omni.write("u32",it.address+0x10,bit32.bor(bit32.band(flags,bit32.bnot(4)),it.bit))
            end
        end
    end
    w.hidden=nil
end
return M

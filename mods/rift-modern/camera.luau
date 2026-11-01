--!nonstrict
-- Requests native shoulder framing and camera-relative strafe locomotion.
-- Weapon aiming remains tied to real input; native wall and floor tests stay active.
local M={}
local layout=require("layout")
function M.setup()
    local ok,value=pcall(function() return omni.fields.omni.rift.shoulder_walk end)
    if not ok or type(value)~="number" then
        omni.log("walking shoulder camera requires the installed Rift camera build")
        return
    end
    local reported=false
    local latched,was_aiming,second_tap=false,false,false
    local tick,pressed_at,first_tap=0,nil,nil
    local hz=omni.ticks_per_second and omni.ticks_per_second() or 50
    local tap_ticks=math.floor(hz*0.25+0.5)
    local gap_ticks=math.floor(hz*0.35+0.5)
    omni.on_frame(function()
        tick+=1
        local allowed=omni.setting("walk_shoulder")~=false
        if not allowed then latched=false end
        local base=omni.mode()=="gameplay" and layout.hero() or nil
        if allowed and base and omni.read("u8",base+0x20a4)==0 then
            -- The native modern camera sets this only while actual aiming is on.
            -- It covers both the controller aim action and right mouse button,
            -- without synthesizing input or relying on a physical button binding.
            local aiming=omni.read("u32",base+0x12b0)==1
            if first_tap and tick-first_tap>gap_ticks then first_tap=nil end
            if aiming and not was_aiming then
                second_tap=first_tap~=nil and tick-first_tap<=gap_ticks
                first_tap=nil;pressed_at=tick
            end
            if not aiming and was_aiming then
                if pressed_at and tick-pressed_at<=tap_ticks then
                    if second_tap then
                        latched=not latched;first_tap=nil
                        omni.log("walking shoulder double-tap toggle: "..tostring(latched))
                    else first_tap=tick end
                else first_tap=nil end
                pressed_at=nil
                second_tap=false
            end
            was_aiming=aiming
        else
            was_aiming=false;pressed_at=nil;first_tap=nil;second_tap=false
        end
        local wanted=allowed and latched and 1 or 0
        if omni.fields.omni.rift.shoulder_walk~=wanted then
            omni.fields.omni.rift.shoulder_walk=wanted
        end
        if not reported and omni.mode()=="gameplay" then
            reported=true
            omni.log("double-tap aim toggles shoulder camera and strafe movement; starts off, normal hold-to-aim retained")
        end
    end)
end
return M

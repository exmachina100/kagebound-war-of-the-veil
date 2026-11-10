-- Original KAGEBOUND locomotion policy. Design targets only until runtime validation.
-- Server must authorize stamina-consuming and traversal abilities.
local Rules={}
Rules.StatePriority={Idle=0,Walk=1,Run=2,Sprint=3,Jump=4,Fall=4,Land=5,Dash=6,Parry=7,Attack=8,Stagger=9,Veilfall=10}
Rules.Speed={Idle=0,Walk=8,Run=16,Sprint=23}
Rules.Transition={Start=0.14,Stop=0.18,Pivot=0.16,Land=0.18}
Rules.Sprint={costPerSecond=7,regenDelay=0.7,minStamina=8}
Rules.Traversal={
    Slide={enabled=false,cooldown=1.4,cost=16,maxDuration=0.65},
    Roll={enabled=false,cooldown=1.2,cost=12,maxDuration=0.55},
    WallKick={enabled=false,cooldown=1.0,cost=18,maxHeight=9},
    Mantle={enabled=false,cooldown=0.7,cost=14,maxHeight=7},
}
function Rules.StateFor(speed,grounded,verticalSpeed,sprinting)
    if typeof(speed)~="number" or speed~=speed or speed<0 then return nil end
    if not grounded then return verticalSpeed>0.5 and "Jump" or "Fall" end
    if speed<0.7 then return "Idle" end
    if sprinting and speed>=Rules.Speed.Run then return "Sprint" end
    if speed<Rules.Speed.Walk then return "Walk" end
    return "Run"
end
function Rules.CanStart(state,ability)
    local requested=Rules.StatePriority[ability]
    local current=Rules.StatePriority[state]
    if not requested or not current then return false end
    return requested>=current
end
return Rules

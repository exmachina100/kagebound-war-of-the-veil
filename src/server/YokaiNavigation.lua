-- KAGEBOUND Yokai navigation v0.2 (server-only).
-- Direct movement on clear routes; bounded PathfindingService plans if obstructed.
-- The model is an anchored prototype, not a Humanoid rig; follow waypoints by pivot.
local PathfindingService=game:GetService("PathfindingService")
local Workspace=game:GetService("Workspace")
local Navigation={}

function Navigation.New()
    return {waypoints=nil,index=2,replanAt=0,target=nil,failed=false}
end

local function planarDelta(from,to)
    return Vector3.new(to.X-from.X,0,to.Z-from.Z)
end

local function obstacle(model,from,to)
    local delta=planarDelta(from,to)
    if delta.Magnitude<.25 then return nil end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={model}
    params.RespectCanCollide=true
    return Workspace:Raycast(from,delta,params)
end

function Navigation.MoveToward(model,target,speed,dt,state)
    local root=model and model.PrimaryPart
    if not root or typeof(target)~="Vector3" then return false end
    local origin=root.Position
    local delta=planarDelta(origin,target)
    if delta.Magnitude<.4 then return true end
    local goal=target
    local hit=obstacle(model,origin,target)

    if hit then
        local now=os.clock()
        local targetMoved=not state.target or planarDelta(state.target,target).Magnitude>11
        if now>=state.replanAt or targetMoved then
            state.replanAt=now+2.5 -- cap expensive navigation computations
            state.target=target
            local path=PathfindingService:CreatePath({
                AgentRadius=2.5,
                AgentHeight=5,
                AgentCanJump=false,
                WaypointSpacing=6
            })
            local ok=pcall(function()
                path:ComputeAsync(origin,target)
            end)
            if ok and path.Status==Enum.PathStatus.Success then
                state.waypoints=path:GetWaypoints()
                state.index=2
                state.failed=false
            else
                state.waypoints=nil
                state.failed=true
            end
        end
        local waypoints=state.waypoints
        if not waypoints or #waypoints<2 then
            model:SetAttribute("NavigationStatus","Blocked")
            return false -- do not tunnel through solid walls on a failed path
        end
        while state.index<=#waypoints do
            local waypoint=waypoints[state.index]
            if planarDelta(origin,waypoint.Position).Magnitude>2.5 then
                goal=waypoint.Position
                break
            end
            state.index+=1
        end
        if state.index>#waypoints then
            model:SetAttribute("NavigationStatus","Blocked")
            return false
        end
    else
        state.waypoints=nil
        state.index=2
        state.target=target
        state.failed=false
    end

    local desired=planarDelta(origin,goal)
    if desired.Magnitude<.15 then return true end
    -- A waypoint can become blocked after being calculated; hold position
    -- and allow the next capped replan instead of walking through geometry.
    if obstacle(model,origin,goal) then
        state.replanAt=os.clock()+1
        model:SetAttribute("NavigationStatus","Blocked")
        return false
    end
    local direction=desired.Unit
    local distance=math.min(desired.Magnitude,math.max(0,speed*dt))
    local nextPosition=origin+direction*distance
    model:PivotTo(CFrame.lookAt(nextPosition,nextPosition+direction))
    model:SetAttribute("NavigationStatus",hit and "Path" or "Direct")
    return true
end
return Navigation

if not getrenv or not getrenv()._G or not newcclosure or not hookfunction then -- Checks If Executor Is Supported.
    game:GetService("Players").LocalPlayer:Kick("Executor Is Not Supported");
end;

if not getrenv()._G.exe_set then -- Checks If "FFlagDebugRunParallelLuaOnMainThread" Is On "True" So We Can Run This Inside Of The Actor.
    game:GetService("Players").LocalPlayer:Kick('Make Sure "FFlagDebugRunParallelLuaOnMainThread" Is On "True"');
end;


-- // Varibales
local LocalPlayer = game:GetService("Players").LocalPlayer;
local CurrentCamera = game:GetService("Workspace").CurrentCamera;
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");

-- // Game Variables
local Set = getrenv()._G.exe_set;
local BulletCore = getrenv()._G.exe_set_t.FPV_SOL_BULLET_SPAWN;
local Equipment = getrenv()._G.globals.gbl_sol_equipments;
local LodoutState = getrenv()._G.globals.loadout_state;
-- 
local RootParts = getrenv()._G.globals.sol_root_parts;
local IsAlive = getrenv()._G.globals.soldiers_alive;
local Teams = getrenv()._G.globals.cli_teams;
local LocalPlayerId = getrenv()._G.globals.cli_state.fpv_sol_id;

-- // Tables
local SilentAim = {
    Enabled = true,
    
    Fov = {
        Visible = true,
        Radius = 300
    }
};

-- // Functions
local Functions = { }; 
do
    
    function Functions:GetClosestPlayer()
        local Closest, Part = SilentAim.Fov.Radius, nil;
       
        for PlayerID, RootPart in next, RootParts do
            local ScreenPosition, OnScreen = CurrentCamera:WorldToViewportPoint(RootPart.Position); 
            local Disatnce = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude; 
            
            if OnScreen and Disatnce < Closest and IsAlive[PlayerID] and Teams[PlayerID] ~= Teams[LocalPlayerId] then -- Cool Tower (I Did 911).
                Part = RootPart;
                Closest = Disatnce;
            end;
        end;
        
        return Part;
    end;
    
end;

-- // Hooks
do
    
    local OldSet; OldSet = hookfunction(Set, newcclosure(function(Name, ...)
        local HitBox = Functions:GetClosestPlayer();
        
        if Name == BulletCore and HitBox and SilentAim.Enabled and Equipment and LodoutState and Equipment[tonumber(LodoutState.loadout_id)] then -- Check If Set(Network) Is Sending Bullets And Also Checks If We Have Our Weapon.
            
            local Time, Four, Position, Velocity = ...; -- Opend Up The Arguments To Make More Sence.
            warn("working")
            local MuzzleVelocity = Equipment[tonumber(LodoutState.loadout_id)].fire_params.muzzle_velocity; -- Will Need It To Create The Velocity.
            Velocity = (HitBox.Position - Position).Unit * MuzzleVelocity; -- LookVector * MuzzleVelocity = Velocity.
            
            return OldSet(Name, Time, Four, Position, Velocity); -- Return The Modified Arguments.
        end;
        
        
        return OldSet(Name, ...); -- Returns Un-Modified Arguments.
    end));
    
end;

-- // Fov Circle
local Circle = Drawing.new("Circle");
Circle.Sides = 1000;
Circle.Filled = false;
Circle.Thickness = 1;
Circle.Color = Color3.fromRGB(255, 125, 125);
RunService.Heartbeat:Connect(function()
    Circle.Visible = SilentAim.Enabled and SilentAim.Fov.Visible;
    if Circle.Visible then
        Circle.Position = UserInputService:GetMouseLocation();
        Circle.Radius = SilentAim.Fov.Radius;
    end;
end);

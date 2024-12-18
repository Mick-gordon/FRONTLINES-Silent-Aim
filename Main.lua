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
    Enabled = false,
    
    Fov = {
        Visible = false,
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
    
    local OldSet = Set; 
    Set = newcclosure(function(Name, ...) -- I Am Not Using HookFunction As Shitty Free Executors(Argon) Crys About To Many Up Values.
        local HitBox = Functions:GetClosestPlayer();
        
        if Name == BulletCore and HitBox and SilentAim.Enabled and Equipment and LodoutState and Equipment[tonumber(LodoutState.loadout_id)] then -- Check If Set(Network) Is Sending Bullets And Also Checks If We Have Our Weapon.
            
            local Time, Four, Position, Velocity = ...; -- Opend Up The Arguments To Make More Sence.
            warn("working")
            local MuzzleVelocity = Equipment[tonumber(LodoutState.loadout_id)].fire_params.muzzle_velocity; -- Will Need It To Create The Velocity.
            Velocity = (HitBox.Position - Position).Unit * MuzzleVelocity; -- LookVector * MuzzleVelocity = Velocity.
            
            return OldSet(Name, Time, Four, Position, Velocity); -- Return The Modified Arguments.
        end;
        
        
        return OldSet(Name, ...); -- Returns Un-Modified Arguments.
    end);
    
end;

-- // GUI
local GUIHolder = Instance.new("ScreenGui", game.CoreGui); GUIHolder.ResetOnSpawn = false;
local Frame = Instance.new("Frame", GUIHolder); Frame.Visible = true; Frame.Draggable = true; Frame.Active = true; Frame.BackgroundColor3 = Color3.fromRGB(52, 52, 52); Frame.Size = UDim2.fromOffset(241, 248); Frame.BorderColor3 = Color3.fromRGB(255, 255, 255);
local Frame2 = Instance.new("Frame", Frame); Frame2.BackgroundTransparency = 1; Frame2.Position = UDim2.new(0.288, 0,0.155, 0); Frame2.Size = UDim2.new(0, 100,0, 164);
local UiListLayout = Instance.new("UIListLayout", Frame2); UiListLayout.FillDirection = "Vertical"; UiListLayout.SortOrder = "LayoutOrder"; UiListLayout.Padding = UDim.new(0,5);
local EnableButton = Instance.new("TextButton", Frame2); EnableButton.Text = "Enable"; EnableButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52); EnableButton.BorderColor3 = Color3.fromRGB(255, 255, 255); EnableButton.Font = "Roboto"; EnableButton.TextSize = 17; EnableButton.TextColor3 = Color3.fromRGB(255, 255, 255); EnableButton.TextXAlignment = "Center"; EnableButton.Size = UDim2.new(0, 122,0, 24);
local ShowFovButton = Instance.new("TextButton", Frame2); ShowFovButton.Text = "Show Fov"; ShowFovButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52); ShowFovButton.BorderColor3 = Color3.fromRGB(255, 255, 255); ShowFovButton.Font = "Roboto"; ShowFovButton.TextSize = 17; ShowFovButton.TextColor3 = Color3.fromRGB(255, 255, 255); ShowFovButton.TextXAlignment = "Center"; ShowFovButton.Size = UDim2.new(0, 122,0, 24);
local TextLabel = Instance.new("TextLabel", Frame2); TextLabel.Text = "Fov Size"; TextLabel.BackgroundTransparency = 1; TextLabel.TextXAlignment = "Center"; TextLabel.TextSize = 17; TextLabel.Font = "Roboto"; TextLabel.TextColor3 = Color3.fromRGB(17, 223, 255); TextLabel.Size = UDim2.new(0, 100,0, 17);
local FovSizeText = Instance.new("TextBox", Frame2); FovSizeText.Text = "600"; FovSizeText.BackgroundColor3 = Color3.fromRGB(52, 52, 52); FovSizeText.BorderColor3 = Color3.fromRGB(255, 255, 255); FovSizeText.Font = "Roboto"; FovSizeText.TextSize = 17; FovSizeText.TextColor3 = Color3.fromRGB(255, 255, 255); FovSizeText.TextXAlignment = "Center"; FovSizeText.Size = UDim2.new(0, 122,0, 24); FovSizeText.ClearTextOnFocus = false;
local Name = Instance.new("TextLabel", Frame); Name.Text = "DeleteMob | FL Silent Aim"; Name.BackgroundTransparency = 1; Name.TextXAlignment = "Center"; Name.TextSize = 19; Name.Font = "Roboto"; Name.TextColor3 = Color3.fromRGB(17, 223, 255); Name.Size = UDim2.new(0, 200,0, 50); Name.Position = UDim2.new(0.083, 0,-0.056, 0);
local Discord = Instance.new("TextBox", Frame); Discord.Text = "https://discord.gg/FsApQ7YNTq - ClickMe"; Discord.BackgroundTransparency = 1; Discord.BorderColor3 = Color3.fromRGB(255, 255, 255); Discord.Font = "Roboto"; Discord.TextSize = 14; Discord.TextColor3 = Color3.fromRGB(255, 255, 255); Discord.TextXAlignment = "Center"; Discord.Size = UDim2.new(0, 200,0, 23); Discord.Position = UDim2.new(0.083, 0,0.873, 0); Discord.ClearTextOnFocus = false; Discord.TextEditable = false;
EnableButton.MouseButton1Down:Connect(function()
	if SilentAim.Enabled then 
		SilentAim.Enabled = false 
		EnableButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52);
	else
		SilentAim.Enabled = true 
		EnableButton.BackgroundColor3 = Color3.fromRGB(2, 54, 8);
	end;
end);
ShowFovButton.MouseButton1Down:Connect(function()
	if SilentAim.Fov.Visible then 
		SilentAim.Fov.Visible = false 
		ShowFovButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52);
	else
		SilentAim.Fov.Visible = true 
		ShowFovButton.BackgroundColor3 = Color3.fromRGB(2, 54, 8);
	end;
end);

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
        
        if not (FovSizeText.Text == "") then
		    SilentAim.Fov.Radius = tonumber(FovSizeText.Text);
	    end;
        Circle.Radius = SilentAim.Fov.Radius;
    end;
end);

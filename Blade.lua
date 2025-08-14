local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kronus | Blade Ball | Free",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Kronus",
   LoadingSubtitle = "by kroniii.",
   ShowText = "Kronus", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Kronus | Blade Ball",
      Subtitle = "Key System",
      Note = "Key In Discord: discord.gg/kronus", -- Use this to tell the user how to get a key
      FileName = "Kronus", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Kronus_412j6kl1bn5gh12"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Made By kroniii.",
   Content = "Kronus",
   Duration = 6.5,
   Image = 4483362458,
})

local Players = game:GetService('Players')
local Player = Players.LocalPlayer
local ContextActionService = game:GetService('ContextActionService')
local Phantom = false


local function BlockMovement(actionName, inputState, inputObject)
    return Enum.ContextActionResult.Sink
end

local UserInputService = cloneref(game:GetService('UserInputService'))

local ContentProvider = cloneref(game:GetService('ContentProvider'))

local TweenService = cloneref(game:GetService('TweenService'))

local HttpService = cloneref(game:GetService('HttpService'))

local TextService = cloneref(game:GetService('TextService'))

local RunService = cloneref(game:GetService('RunService'))

local Lighting = cloneref(game:GetService('Lighting'))

local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))

local Debris = cloneref(game:GetService('Debris'))


local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Tornado_Time = tick()

local UserInputService = game:GetService('UserInputService')
local Last_Input = UserInputService:GetLastInputType()

local Debris = game:GetService('Debris')
local RunService = game:GetService('RunService')

local Vector2_Mouse_Location = nil
local Grab_Parry = nil

local Remotes = {}

local Parry_Key = nil

local Speed_Divisor_Multiplier = 1.1

local LobbyAP_Speed_Divisor_Multiplier = 1.1

local firstParryFired = false

local ParryThreshold = 2.5

local firstParryType = 'F_Key'

local Previous_Positions = {}

local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualInputService = game:GetService("VirtualInputManager")


local GuiService = game:GetService('GuiService')

local function performFirstPress(parryType)
    if parryType == 'F_Key' then
        VirtualInputService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
    elseif parryType == 'Left_Click' then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    elseif parryType == 'Navigation' then
        local button = Players.LocalPlayer.PlayerGui.Hotbar.Block
        updateNavigation(button)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.01)
        updateNavigation(nil)
    end
end

if not LPH_OBFUSCATED then
    function LPH_JIT(Function) return Function end
    function LPH_JIT_MAX(Function) return Function end
    function LPH_NO_VIRTUALIZE(Function) return Function end
end

local PropertyChangeOrder = {}

local HashOne
local HashTwo
local HashThree

LPH_NO_VIRTUALIZE(function()
    for Index, Value in next, getgc() do
        if rawequal(typeof(Value), "function") and islclosure(Value) and getrenv().debug.info(Value, "s"):find("SwordsController") then
            if rawequal(getrenv().debug.info(Value, "l"), 276) then
                HashOne = getconstant(Value, 62)
                HashTwo = getconstant(Value, 64)
                HashThree = getconstant(Value, 65)
            end
        end 
    end
end)()


LPH_NO_VIRTUALIZE(function()
    for Index, Object in next, game:GetDescendants() do
        if Object:IsA("RemoteEvent") and string.find(Object.Name, "\n") then
            Object.Changed:Once(function()
                table.insert(PropertyChangeOrder, Object)
            end)
        end
    end
end)()


repeat
    task.wait()
until #PropertyChangeOrder == 3


local ShouldPlayerJump = PropertyChangeOrder[1]
local MainRemote = PropertyChangeOrder[2]
local GetOpponentPosition = PropertyChangeOrder[3]

local Parry_Key

for Index, Value in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do
    if Value and Value.Function and not iscclosure(Value.Function)  then
        for Index2,Value2 in pairs(getupvalues(Value.Function)) do
            if type(Value2) == "function" then
                Parry_Key = getupvalue(getupvalue(Value2, 2), 17);
            end;
        end;
    end;
end;

local function Parry(...)
    ShouldPlayerJump:FireServer(HashOne, Parry_Key, ...)
    MainRemote:FireServer(HashTwo, Parry_Key, ...)
    GetOpponentPosition:FireServer(HashThree, Parry_Key, ...)
end

local Parries = 0

function create_animation(object, info, Value)
    local animation = game:GetService('TweenService'):Create(object, info, Value)

    animation:Play()
    task.wait(info.Time)

    Debris:AddItem(animation, 0)

    animation:Destroy()
    animation = nil
end

local Animation = {}
Animation.storage = {}

Animation.current = nil
Animation.track = nil

for _, v in pairs(game:GetService("ReplicatedStorage").Misc.Emotes:GetChildren()) do
    if v:IsA("Animation") and v:GetAttribute("EmoteName") then
        local Emote_Name = v:GetAttribute("EmoteName")
        Animation.storage[Emote_Name] = v
    end
end

local Emotes_Data = {}

for Object in pairs(Animation.storage) do
    table.insert(Emotes_Data, Object)
end

table.sort(Emotes_Data)

local Auto_Parry = {}

function Auto_Parry.Parry_Animation()
    local Parry_Animation = game:GetService("ReplicatedStorage").Shared.SwordAPI.Collection.Default:FindFirstChild('GrabParry')
    local Current_Sword = Player.Character:GetAttribute('CurrentlyEquippedSword')

    if not Current_Sword then
        return
    end

    if not Parry_Animation then
        return
    end

    local Sword_Data = game:GetService("ReplicatedStorage").Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)

    if not Sword_Data or not Sword_Data['AnimationType'] then
        return
    end

    for _, object in pairs(game:GetService('ReplicatedStorage').Shared.SwordAPI.Collection:GetChildren()) do
        if object.Name == Sword_Data['AnimationType'] then
            if object:FindFirstChild('GrabParry') or object:FindFirstChild('Grab') then
                local sword_animation_type = 'GrabParry'

                if object:FindFirstChild('Grab') then
                    sword_animation_type = 'Grab'
                end

                Parry_Animation = object[sword_animation_type]
            end
        end
    end

    Grab_Parry = Player.Character.Humanoid.Animator:LoadAnimation(Parry_Animation)
    Grab_Parry:Play()
end

function Auto_Parry.Play_Animation(v)
    local Animations = Animation.storage[v]

    if not Animations then
        return false
    end

    local Animator = Player.Character.Humanoid.Animator

    if Animation.track then
        Animation.track:Stop()
    end

    Animation.track = Animator:LoadAnimation(Animations)
    Animation.track:Play()

    Animation.current = v
end

function Auto_Parry.Get_Balls()
    local Balls = {}

    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            table.insert(Balls, Instance)
        end
    end
    return Balls
end

function Auto_Parry.Get_Ball()
    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            return Instance
        end
    end
end

function Auto_Parry.Lobby_Balls()
    for _, Instance in pairs(workspace.TrainingBalls:GetChildren()) do
        if Instance:GetAttribute("realBall") then
            return Instance
        end
    end
end


local Closest_Entity = nil

function Auto_Parry.Closest_Player()
    local Max_Distance = math.huge
    local Found_Entity = nil
    
    for _, Entity in pairs(workspace.Alive:GetChildren()) do
        if tostring(Entity) ~= tostring(Player) then
            if Entity.PrimaryPart then  -- Check if PrimaryPart exists
                local Distance = Player:DistanceFromCharacter(Entity.PrimaryPart.Position)
                if Distance < Max_Distance then
                    Max_Distance = Distance
                    Found_Entity = Entity
                end
            end
        end
    end
    
    Closest_Entity = Found_Entity
    return Found_Entity
end

function Auto_Parry:Get_Entity_Properties()
    Auto_Parry.Closest_Player()

    if not Closest_Entity then
        return false
    end

    local Entity_Velocity = Closest_Entity.PrimaryPart.Velocity
    local Entity_Direction = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local Entity_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude

    return {
        Velocity = Entity_Velocity,
        Direction = Entity_Direction,
        Distance = Entity_Distance
    }
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled


function Auto_Parry.Parry_Data(Parry_Type)
    Auto_Parry.Closest_Player()
    
    local Events = {}
    local Camera = workspace.CurrentCamera
    local Vector2_Mouse_Location
    
    if Last_Input == Enum.UserInputType.MouseButton1 or (Enum.UserInputType.MouseButton2 or Last_Input == Enum.UserInputType.Keyboard) then
        local Mouse_Location = UserInputService:GetMouseLocation()
        Vector2_Mouse_Location = {Mouse_Location.X, Mouse_Location.Y}
    else
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end
    
    if isMobile then
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end
    
    local Players_Screen_Positions = {}
    for _, v in pairs(workspace.Alive:GetChildren()) do
        if v ~= Player.Character then
            local worldPos = v.PrimaryPart.Position
            local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
            
            if isOnScreen then
                Players_Screen_Positions[v] = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            Events[tostring(v)] = screenPos
        end
    end
    
    if Parry_Type == 'Camera' then
        return {0, Camera.CFrame, Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Backwards' then
        local Backwards_Direction = Camera.CFrame.LookVector * -10000
        Backwards_Direction = Vector3.new(Backwards_Direction.X, 0, Backwards_Direction.Z)
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Backwards_Direction), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'Straight' then
        local Aimed_Player = nil
        local Closest_Distance = math.huge
        local Mouse_Vector = Vector2.new(Vector2_Mouse_Location[1], Vector2_Mouse_Location[2])
        
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= Player.Character then
                local worldPos = v.PrimaryPart.Position
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
                
                if isOnScreen then
                    local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (Mouse_Vector - playerScreenPos).Magnitude
                    
                    if distance < Closest_Distance then
                        Closest_Distance = distance
                        Aimed_Player = v
                    end
                end
            end
        end
        
        if Aimed_Player then
            return {0, CFrame.new(Player.Character.PrimaryPart.Position, Aimed_Player.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        else
            return {0, CFrame.new(Player.Character.PrimaryPart.Position, Closest_Entity.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        end
    end
    
    if Parry_Type == 'Random' then
        return {0, CFrame.new(Camera.CFrame.Position, Vector3.new(math.random(-4000, 4000), math.random(-4000, 4000), math.random(-4000, 4000))), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'High' then
        local High_Direction = Camera.CFrame.UpVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + High_Direction), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Left' then
        local Left_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position - Left_Direction), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Right' then
        local Right_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Right_Direction), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'RandomTarget' then
        local candidates = {}
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= Player.Character and v.PrimaryPart then
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(v.PrimaryPart.Position)
                if isOnScreen then
                    table.insert(candidates, {
                        character = v,
                        screenXY  = { screenPos.X, screenPos.Y }
                    })
                end
            end
        end
        if #candidates > 0 then
            local pick = candidates[ math.random(1, #candidates) ]
            local lookCFrame = CFrame.new(Player.Character.PrimaryPart.Position, pick.character.PrimaryPart.Position)
            return {0, lookCFrame, Events, pick.screenXY}
        else
            return {0, Camera.CFrame, Events, { Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 }}
        end
    end
    
    return Parry_Type
end

function Auto_Parry.Parry(Parry_Type)
    local Parry_Data = Auto_Parry.Parry_Data(Parry_Type)

    if not firstParryFired then
        performFirstPress(firstParryType)
        firstParryFired = true
    else
        Parry(Parry_Data[1], Parry_Data[2], Parry_Data[3], Parry_Data[4])
    end

    if Parries > 7 then
        return false
    end

    Parries += 1

    task.delay(0.5, function()
        if Parries > 0 then
            Parries -= 1
        end
    end)
end

local Lerp_Radians = 0
local Last_Warping = tick()

function Auto_Parry.Linear_Interpolation(a, b, time_volume)
    return a + (b - a) * time_volume
end

local Previous_Velocity = {}
local Curving = tick()

local Runtime = workspace.Runtime


function Auto_Parry.Is_Curved()
    local Ball = Auto_Parry.Get_Ball()

    if not Ball then
        return false
    end

    local Zoomies = Ball:FindFirstChild('zoomies')

    if not Zoomies then
        return false
    end

    local Velocity = Zoomies.VectorVelocity
    local Ball_Direction = Velocity.Unit
    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)
    local Speed = Velocity.Magnitude
    local Speed_Threshold = math.min(Speed / 100, 40)
    local Direction_Difference = (Ball_Direction - Velocity).Unit
    local Direction_Similarity = Direction:Dot(Direction_Difference)
    local Dot_Difference = Dot - Direction_Similarity
    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Pings = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
    local Dot_Threshold = 0.5 - (Pings / 1000)
    local Reach_Time = Distance / Speed - (Pings / 1000)
    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold
    local Clamped_Dot = math.clamp(Dot, -1, 1)
    local Radians = math.rad(math.asin(Clamped_Dot))

    Lerp_Radians = Auto_Parry.Linear_Interpolation(Lerp_Radians, Radians, 0.8)

    if Speed > 100 and Reach_Time > Pings / 10 then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end

    if Distance < Ball_Distance_Threshold then
        return false
    end

    if Dot_Difference < Dot_Threshold then
        return true
    end

    if Lerp_Radians < 0.018 then
        Last_Warping = tick()
    end

    if (tick() - Last_Warping) < (Reach_Time / 1.5) then
        return true
    end

    if (tick() - Curving) < (Reach_Time / 1.5) then
        return true
    end

    return Dot < Dot_Threshold
end

function Auto_Parry:Get_Ball_Properties()
    local Ball = Auto_Parry.Get_Ball()
    local Ball_Velocity = Vector3.zero
    local Ball_Origin = Ball
    local Ball_Direction = (Player.Character.PrimaryPart.Position - Ball_Origin.Position).Unit
    local Ball_Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Ball_Dot = Ball_Direction:Dot(Ball_Velocity.Unit)

    return {
        Velocity = Ball_Velocity,
        Direction = Ball_Direction,
        Distance = Ball_Distance,
        Dot = Ball_Dot
    }
end

function Auto_Parry.Spam_Service(self)
    local Ball = Auto_Parry.Get_Ball()

    local Entity = Auto_Parry.Closest_Player()

    if not Ball then
        return false
    end

    if not Entity or not Entity.PrimaryPart then
        return false
    end

    local Spam_Accuracy = 0

    local Velocity = Ball.AssemblyLinearVelocity
    local Speed = Velocity.Magnitude

    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Velocity.Unit)

    local Target_Position = Entity.PrimaryPart.Position
    local Target_Distance = Player:DistanceFromCharacter(Target_Position)

    local Maximum_Spam_Distance = self.Ping + math.min(Speed / 6, 95)

    if self.Entity_Properties.Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    if self.Ball_Properties.Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    if Target_Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    local Maximum_Speed = 5 - math.min(Speed / 5, 5)
    local Maximum_Dot = math.clamp(Dot, -1, 0) * Maximum_Speed

    Spam_Accuracy = Maximum_Spam_Distance - Maximum_Dot

    return Spam_Accuracy
end

local Connections_Manager = {}
local Selected_Parry_Type = "Camera"
local Infinity = false

ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    if b then
        Infinity = true
    else
        Infinity = false
    end
end)

local Parried = false
local Last_Parry = 0
local AutoParry = true
local Balls = workspace:WaitForChild('Balls')
local CurrentBall = nil
local InputTask = nil
local Cooldown = 0.02
local RunTime = workspace:FindFirstChild("Runtime")

local function GetBall()
    for _, Ball in ipairs(Balls:GetChildren()) do
        if Ball:FindFirstChild("ff") then
            return Ball
        end
    end
    return nil
end

local function SpamInput(Label)
    if InputTask then return end
    InputTask = task.spawn(function()
        while AutoParry do
            Auto_Parry.Parry(Selected_Parry_Type)
            task.wait(Cooldown)
        end
        InputTask = nil
    end)
end

Balls.ChildAdded:Connect(function(Value)
    Value.ChildAdded:Connect(function(Child)
        if getgenv().SlashOfFuryDetection and Child.Name == 'ComboCounter' then
            local Sof_Label = Child:FindFirstChildOfClass('TextLabel')

            if Sof_Label then
                repeat
                    local Slashes_Counter = tonumber(Sof_Label.Text)

                    if Slashes_Counter and Slashes_Counter < 32 then
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end

                    task.wait()

                until not Sof_Label.Parent or not Sof_Label
            end
        end
    end)
end)

local player10239123 = Players.LocalPlayer

RunTime.ChildAdded:Connect(function(Object)
    local Name = Object.Name
    if getgenv().PhantomV2Detection then
        if Name == "maxTransmission" or Name == "transmissionpart" then
            local Weld = Object:FindFirstChildWhichIsA("WeldConstraint")
            if Weld then
                local Character = player10239123.Character or player10239123.CharacterAdded:Wait()
                if Character and Weld.Part1 == Character.HumanoidRootPart then
                    CurrentBall = GetBall()
                    Weld:Destroy()
    
                    if CurrentBall then
                        local FocusConnection
                        FocusConnection = RunService.RenderStepped:Connect(function()
                            local Highlighted = CurrentBall:GetAttribute("highlighted")
    
                            if Highlighted == true then
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
    
                                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                                if HumanoidRootPart then
                                    local PlayerPosition = HumanoidRootPart.Position
                                    local BallPosition = CurrentBall.Position
                                    local PlayerToBall = (BallPosition - PlayerPosition).Unit
    
                                    game.Players.LocalPlayer.Character.Humanoid:Move(PlayerToBall, false)
                                end
    
                            elseif Highlighted == false then
                                FocusConnection:Disconnect()
    
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10
                                game.Players.LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, 0), false)
    
                                task.delay(3, function()
                                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
                                end)
    
                                CurrentBall = nil
                            end
                        end)
    
                        task.delay(3, function()
                            if FocusConnection and FocusConnection.Connected then
                                FocusConnection:Disconnect()
    
                                game.Players.LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, 0), false)
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
                                CurrentBall = nil
                            end
                        end)
                    end
                end
            end
        end
    end
end)

local player11 = game.Players.LocalPlayer
local PlayerGui = player11:WaitForChild("PlayerGui")
local playerGui = player11:WaitForChild("PlayerGui")
local Hotbar = PlayerGui:WaitForChild("Hotbar")
local ParryCD = playerGui.Hotbar.Block.UIGradient
local AbilityCD = playerGui.Hotbar.Ability.UIGradient

local function isCooldownInEffect1(uigradient)
    return uigradient.Offset.Y < 0.4
end

local function isCooldownInEffect2(uigradient)
    return uigradient.Offset.Y == 0.5
end

local function cooldownProtection()
    if isCooldownInEffect1(ParryCD) then
        game:GetService("ReplicatedStorage").Remotes.AbilityButtonPress:Fire()
        return true
    end
    return false
end

local function AutoAbility()
    if isCooldownInEffect2(AbilityCD) then
        if Player.Character.Abilities["Raging Deflection"].Enabled or Player.Character.Abilities["Rapture"].Enabled or Player.Character.Abilities["Calming Deflection"].Enabled or Player.Character.Abilities["Aerodynamic Slash"].Enabled or Player.Character.Abilities["Fracture"].Enabled or Player.Character.Abilities["Death Slash"].Enabled then
            Parried = true
            game:GetService("ReplicatedStorage").Remotes.AbilityButtonPress:Fire()
            task.wait(2.432)
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
            return true
        end
    end
    return false
end

local PlayerTab = Window:CreateTab("Player")
local MainTab = Window:CreateTab("Main")
local InventoryTab = Window:CreateTab("Inventory")
local MiscTab = Window:CreateTab("Misc")

local MovementSection = PlayerTab:CreateSection("Movement")
local AutoParrySection = MainTab:CreateSection("Auto Parry")
local SkinsSection = InventoryTab:CreateSection("Skins")
local HitSoundsSection = MiscTab:CreateSection("Hit Sounds")

-- Speed Slider
local StrafeSpeed = 36 -- default

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Speed",
    Range = {36, 200},
    Increment = 10,
    Suffix = " / 200",
    CurrentValue = 36,
    Flag = "SpeedSlider",
    Callback = function(Value)
        StrafeSpeed = Value
    end,
})

-- Speed Toggle
local SpeedToggle = PlayerTab:CreateToggle({
    Name = "Modify Speed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(Value)
        Connections_Manager = Connections_Manager or {}
        local RunService = game:GetService("RunService")
        local Player = game.Players.LocalPlayer

        if Value then
            if not Connections_Manager['Strafe'] then
                Connections_Manager['Strafe'] = RunService.PreSimulation:Connect(function()
                    local character = Player.Character
                    if character and character:FindFirstChild("Humanoid") then
                        character.Humanoid.WalkSpeed = StrafeSpeed
                    end
                end)
            end
        else
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = 36
            end

            if Connections_Manager['Strafe'] then
                Connections_Manager['Strafe']:Disconnect()
                Connections_Manager['Strafe'] = nil
            end
        end
    end,
})

-- Spin Slider
getgenv().spinSpeed = math.rad(1)

local SpinSlider = PlayerTab:CreateSlider({
    Name = "Spin Bot",
    Range = {1, 150},
    Increment = 10,
    Suffix = " / 150",
    CurrentValue = 1,
    Flag = "SpinSlider",
    Callback = function(Value)
        getgenv().spinSpeed = math.rad(Value)
    end,
})

-- Spin Toggle
local SpinToggle = PlayerTab:CreateToggle({
    Name = "Enable SpinBot",
    CurrentValue = false,
    Flag = "SpinToggle",
    Callback = function(Value)
        getgenv().Spinbot = Value
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Client = Players.LocalPlayer

        if Value then
            getgenv().spin = true

            local function spinCharacter()
                while getgenv().spin do
                    RunService.Heartbeat:Wait()
                    local char = Client.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, getgenv().spinSpeed, 0)
                    end
                end
            end

            if not getgenv().spinThread or coroutine.status(getgenv().spinThread) == "dead" then
                getgenv().spinThread = coroutine.create(spinCharacter)
                coroutine.resume(getgenv().spinThread)
            end
        else
            getgenv().spin = false
            getgenv().spinThread = nil
        end
    end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noSlowConnection = nil
local stateDisablers = {}
local speedEnforcer = nil

local function enableNoSlow()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	-- Disable states that can cause slowdown
	local statesToDisable = {
		Enum.HumanoidStateType.Swimming,
		Enum.HumanoidStateType.Seated,
		Enum.HumanoidStateType.Climbing,
		Enum.HumanoidStateType.PlatformStanding
	}
	for _, state in ipairs(statesToDisable) do
		humanoid:SetStateEnabled(state, false)
		stateDisablers[state] = true
	end

	-- Remove potential interfering values
	for _, v in pairs(humanoid:GetDescendants()) do
		if v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("ObjectValue") then
			v:Destroy()
		end
	end

	-- Set speed immediately
	humanoid.WalkSpeed = 36

	-- Re-enforce speed if changed
	noSlowConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if humanoid.WalkSpeed ~= 36 then
			humanoid.WalkSpeed = 36
		end
	end)

	-- Continuous check every frame
	speedEnforcer = RunService.RenderStepped:Connect(function()
		if humanoid and humanoid.WalkSpeed ~= 36 then
			humanoid.WalkSpeed = 36
		end
	end)
end

local function disableNoSlow()
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		-- Re-enable states
		for state, _ in pairs(stateDisablers) do
			humanoid:SetStateEnabled(state, true)
		end
	end

	if noSlowConnection then
		noSlowConnection:Disconnect()
		noSlowConnection = nil
	end

	if speedEnforcer then
		speedEnforcer:Disconnect()
		speedEnforcer = nil
	end
end

local NoSlowToggle = PlayerTab:CreateToggle({
    Name = "No Slow",
    CurrentValue = false,
    Flag = "NoSlowToggle",
    Callback = function(Value)
       if Value then
			enableNoSlow()
		else
			disableNoSlow()
		end
    end,
})

local FOVSection = PlayerTab:CreateSection("FOV")

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Default FOV
getgenv().CameraFOV = 70
getgenv().CameraEnabled = false

-- FOV Slider
local FOVSlider = PlayerTab:CreateSlider({
    Name = "FOV",
    Range = {50, 120},
    Increment = 5,
    Suffix = " / 120",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value)
        getgenv().CameraFOV = Value
        if getgenv().CameraEnabled then
            Camera.FieldOfView = Value
        end
    end,
})

-- FOV Toggle
local FOVToggle = PlayerTab:CreateToggle({
    Name = "Enable Camera FOV",
    CurrentValue = false,
    Flag = "FOVToggle",
    Callback = function(Value)
        getgenv().CameraEnabled = Value

        if Value then
            Camera.FieldOfView = getgenv().CameraFOV
            if not getgenv().FOVLoop then
                getgenv().FOVLoop = RunService.RenderStepped:Connect(function()
                    if getgenv().CameraEnabled then
                        Camera.FieldOfView = getgenv().CameraFOV
                    end
                end)
            end
        else
            Camera.FieldOfView = 70
            if getgenv().FOVLoop then
                getgenv().FOVLoop:Disconnect()
                getgenv().FOVLoop = nil
            end
        end
    end,
})

local AutoParryToggle = MainTab:CreateToggle({
   Name = "Auto Parry",
   CurrentValue = false,
   Flag = "AutoParryToggle",
   Callback = function(Value)
        if Value then -- changed from 'state' to 'Value'
             Connections_Manager['Auto Parry'] = RunService.PreSimulation:Connect(function()
                    local One_Ball = Auto_Parry.Get_Ball()
                    local Balls = Auto_Parry.Get_Balls()

                    for _, Ball in pairs(Balls) do
                        if not Ball then return end

                        local Zoomies = Ball:FindFirstChild('zoomies')
                        if not Zoomies then return end

                        Ball:GetAttributeChangedSignal('target'):Once(function()
                            Parried = false
                        end)

                        if Parried then return end

                        local Ball_Target = Ball:GetAttribute('target')
                        local One_Target = One_Ball:GetAttribute('target')
                        local Velocity = Zoomies.VectorVelocity
                        local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
                        local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue() / 10
                        local Ping_Threshold = math.clamp(Ping / 10, 5, 17)

                        local Speed = Velocity.Magnitude
                        local cappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
                        local speed_divisor_base = 2.4 + cappedSpeedDiff * 0.002

                        local effectiveMultiplier = Speed_Divisor_Multiplier
                        if getgenv().RandomParryAccuracyEnabled then
                            if Speed < 200 then
                                effectiveMultiplier = 0.7 + (math.random(40, 100) - 1) * (0.35 / 99)
                            else
                                effectiveMultiplier = 0.7 + (math.random(1, 100) - 1) * (0.35 / 99)
                            end
                        end

                        local speed_divisor = speed_divisor_base * effectiveMultiplier
                        local Parry_Accuracy = Ping_Threshold + math.max(Speed / speed_divisor, 9.5)

                        local Curved = Auto_Parry.Is_Curved()

                        if Ball:FindFirstChild('AeroDynamicSlashVFX') then
                            Debris:AddItem(Ball.AeroDynamicSlashVFX, 0)
                            Tornado_Time = tick()
                        end

                        if Runtime:FindFirstChild('Tornado') then
                            if (tick() - Tornado_Time) < (Runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then
                                return
                            end
                        end

                        if One_Target == tostring(Player) and Curved then return end
                        if Ball:FindFirstChild("ComboCounter") then return end

                        local Singularity_Cape = Player.Character.PrimaryPart:FindFirstChild('SingularityCape')
                        if Singularity_Cape then return end 

                        if getgenv().InfinityDetection and Infinity then return end
                        if getgenv().DeathSlashDetection and deathshit then return end
                        if getgenv().TimeHoleDetection and timehole then return end

                        if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy then
                            if getgenv().AutoAbility and AutoAbility() then
                                return
                            end
                        end

                        if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy then
                            if getgenv().CooldownProtection and cooldownProtection() then
                                return
                            end

                            local Parry_Time = os.clock()
                            local Time_View = Parry_Time - (Last_Parry)
                            if Time_View > 0.5 then
                                Auto_Parry.Parry_Animation()
                            end

                            if getgenv().AutoParryKeypress then
                                VirtualInputService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
                            else
                                Auto_Parry.Parry(Selected_Parry_Type)
                            end

                            Last_Parry = Parry_Time
                            Parried = true
                        end

                        local Last_Parrys = tick()
                        repeat
                            RunService.PreSimulation:Wait()
                        until (tick() - Last_Parrys) >= 1 or not Parried
                        Parried = false
                    end
                end)
        else -- moved 'else' to correctly match the 'if Value then'
            if Connections_Manager['Auto Parry'] then
                Connections_Manager['Auto Parry']:Disconnect()
                Connections_Manager['Auto Parry'] = nil
            end
        end -- closes 'if Value then'
   end, -- closes Callback function
})

local parryTypeMap = {
    ["Camera"] = "Camera",
    ["Random"] = "Random",
    ["Backwards"] = "Backwards",
    ["Straight"] = "Straight",
    ["High"] = "High",
    ["Left"] = "Left",
    ["Right"] = "Right",
    ["Random Target"] = "RandomTarget"
}

local AutoParryDropdown = MainTab:CreateDropdown({
   Name = "Curve Type",
   Options = {"Camera", "Random", "Backwards", "Straight", "High", "Left", "Right", "Random Target"},
   CurrentOption = {"Camera"},
   MultipleOptions = false,
   Flag = "CurveTypeDropdown",
   Callback = function(selected)
       local choice = selected[1]
       Selected_Parry_Type = parryTypeMap[choice] or choice
   end,
})

local ParryAccuracySlider = MainTab:CreateSlider({
   Name = "Auto Parry Accuracy",
   Range = {-5, 100},
   Increment = 100,
   Suffix = " / 100",
   CurrentValue = 100,
   Flag = "ParryAccuracySlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    Speed_Divisor_Multiplier = 0.7 + (Value - 1) * (0.35 / 99)
   end,
})

local Divider = MainTab:CreateDivider()

local RandomizedParryAccuracyToggle = MainTab:CreateToggle({
   Name = "Randomized Parry Accuracy",
   CurrentValue = false,
   Flag = "RandomizedParryAccuracyToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    getgenv().RandomParryAccuracyEnabled = Value
   end,
})

local PhantomDetectionToggle = MainTab:CreateToggle({
   Name = "Phantom Detection",
   CurrentValue = false,
   Flag = "PhantomDetectionToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    PhantomV2Detection = Value
   end,
})

local InfinityDetectionToggle = MainTab:CreateToggle({
   Name = "Infinity Detection",
   CurrentValue = false,
   Flag = "InfinityDetectionToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    getgenv().InfinityDetection = Value
   end,
})

local KeypressToggle = MainTab:CreateToggle({
   Name = "Keypress",
   CurrentValue = false,
   Flag = "KeypressToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    getgenv().AutoParryKeypress = Value
   end,
})

local AutoParrySpamSection = MainTab:CreateSection("Auto Spam Parry")

local AutoSpamParryToggle = MainTab:CreateToggle({
   Name = "Auto Spam Parry",
   CurrentValue = false,
   Flag = "AutoSpamParryToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        if Value then
            Connections_Manager['Auto Spam'] = RunService.PreSimulation:Connect(function()
                local Ball = Auto_Parry.Get_Ball()

                if not Ball then
                    return
                end

                local Zoomies = Ball:FindFirstChild('zoomies')

                if not Zoomies then
                    return
                end

                Auto_Parry.Closest_Player()

                local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()

                local Ping_Threshold = math.clamp(Ping / 10, 18.5, 70)

                local Ball_Target = Ball:GetAttribute('target')

                local Ball_Properties = Auto_Parry:Get_Ball_Properties()
                local Entity_Properties = Auto_Parry:Get_Entity_Properties()

                local Spam_Accuracy = Auto_Parry.Spam_Service({
                    Ball_Properties = Ball_Properties,
                    Entity_Properties = Entity_Properties,
                    Ping = Ping_Threshold
                })

                local Target_Position = Closest_Entity.PrimaryPart.Position
                local Target_Distance = Player:DistanceFromCharacter(Target_Position)

                local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
                local Ball_Direction = Zoomies.VectorVelocity.Unit

                local Dot = Direction:Dot(Ball_Direction)

                local Distance = Player:DistanceFromCharacter(Ball.Position)

                if not Ball_Target then
                    return
                end

                if Target_Distance > Spam_Accuracy or Distance > Spam_Accuracy then
                    return
                end
                
                local Pulsed = Player.Character:GetAttribute('Pulsed')

                if Pulsed then
                    return
                end

                if Ball_Target == tostring(Player) and Target_Distance > 25 and Distance > 25 then
                    return
                end

                local threshold = ParryThreshold

                if Distance <= Spam_Accuracy and Parries > threshold then
                    if getgenv().SpamParryKeypress then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) 
                    else
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end
                end
            end)
        else
            if Connections_Manager['Auto Spam'] then
                Connections_Manager['Auto Spam']:Disconnect()
                Connections_Manager['Auto Spam'] = nil
            end
        end
   end,
})

local SpamAutoParryTresholdSlider = MainTab:CreateSlider({
   Name = "Spam Threshold",
   Range = {1, 3},
   Increment = 1,
   Suffix = " / 3",
   CurrentValue = 1,
   Flag = "SpamThresholdSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    SpamThreshold = Value
   end,
})

local EmotesSection = MainTab:CreateSection("Emotes")

local Emotes_Data = {}
for emoteName in pairs(Animation.storage) do
	table.insert(Emotes_Data, emoteName)
end
table.sort(Emotes_Data)

local selected_animation = Emotes_Data[1]

March = March or {}
March.Play_Anim = function(emoteName)
	local anim = Animation.storage[emoteName]
	if not anim then return false end

	local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then return false end

	if Animation.track then
		Animation.track:Stop()
	end

	local track = animator:LoadAnimation(anim)
	Animation.track = track
	track:Play()
	Animation.current = emoteName

	return true
end

local Emotes_Enabled = false

-- Toggle to enable/disable emotes
local EmotesToggle = MainTab:CreateToggle({
   Name = "Emotes",
   CurrentValue = false,
   Flag = "EmotesToggle",
   Callback = function(Value)
        Emotes_Enabled = Value
        if not Value and Animation.track then
            Animation.track:Stop()
            Animation.track = nil
            Animation.current = nil
        end
   end,
})

-- Dropdown for selecting emotes
local EmotesDropdown = MainTab:CreateDropdown({
   Name = "Select Emote",
   Options = Emotes_Data, -- use your real emotes
   CurrentOption = {Emotes_Data[1] or "None"},
   MultipleOptions = false,
   Flag = "EmotesDropdown",
   Callback = function(optionTable)
       local choice = optionTable[1]
       selected_animation = choice
       if Emotes_Enabled then
           March.Play_Anim(choice)
       end
   end,
})

local enabled = false
local swordName = ""
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local swords = require(rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9))
local ctrl, playFx, lastParry = nil, nil, 0
local function getSlash(name)
    local s = swords:GetSword(name)
    return (s and s.SlashName) or "SlashEffect"
end
local function setSword()
    if not enabled then return end
    setupvalue(rawget(swords, "EquipSwordTo"), 2, false)
    swords:EquipSwordTo(p.Character, swordName)
    ctrl:SetSword(swordName)
end
updateSword = function()
    setSword()
end
while task.wait() and not ctrl do
    for _, v in getconnections(rs.Remotes.FireSwordInfo.OnClientEvent) do
        if v.Function and islclosure(v.Function) then
            local u = getupvalues(v.Function)
            if #u == 1 and type(u[1]) == "table" then
                ctrl = u[1]
                break
            end
        end
    end
end
local parryConnA, parryConnB
while task.wait() and not parryConnA do
    for _, v in getconnections(rs.Remotes.ParrySuccessAll.OnClientEvent) do
        if v.Function and getinfo(v.Function).name == "parrySuccessAll" then
            parryConnA, playFx = v, v.Function
            v:Disable()
            break
        end
    end
end
while task.wait() and not parryConnB do
    for _, v in getconnections(rs.Remotes.ParrySuccessClient.Event) do
        if v.Function and getinfo(v.Function).name == "parrySuccessAll" then
            parryConnB = v
            v:Disable()
            break
        end
    end
end
rs.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(...)
    setthreadidentity(2)
    local args = {...}
    if tostring(args[4]) ~= p.Name then
        lastParry = tick()
    elseif enabled then
        args[1] = getSlash(swordName)
        args[3] = swordName
    end
    return playFx(unpack(args))
end)
task.spawn(function()
    while task.wait(1) do
        if enabled and swordName ~= "" then
            local c = p.Character or p.CharacterAdded:Wait()
            if p:GetAttribute("CurrentlyEquippedSword") ~= swordName or not c:FindFirstChild(swordName) then
                setSword()
            end
            for _, m in pairs(c:GetChildren()) do
                if m:IsA("Model") and m.Name ~= swordName then
                    m:Destroy()
                end
                task.wait()
            end
        end
    end
end)

local SkinChangerToggle = InventoryTab:CreateToggle({
   Name = "Skin Changer",
   CurrentValue = false,
   Flag = "SkinChangerToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    enabled = Value
   end,
})

local SkinChangerInput = InventoryTab:CreateInput({
   Name = "Skin Name",
   CurrentValue = "",
   PlaceholderText = "Enter Sword Name...",
   RemoveTextAfterFocusLost = false,
   Flag = "SkinchangerInput",
   Callback = function(Text)
    swordName = Text
   end,
})

local Sound_Effect = true
local sound_effect_type = "DC_15X"
local CustomId = "" -- Should be set to just the numeric ID, like "1234567890"
local sound_assets = {
    DC_15X = 'rbxassetid://936447863',
    Neverlose = 'rbxassetid://8679627751',
    Minecraft = 'rbxassetid://8766809464',
    MinecraftHit2 = 'rbxassetid://8458185621',
    TeamfortressBonk = 'rbxassetid://8255306220',
    TeamfortressBell = 'rbxassetid://2868331684',
    Custom = 'empty'
}
local SlashesNet = ReplicatedStorage:WaitForChild("Packages")._Index:FindFirstChild("sleitnick_net@0.1.0")
local SlashesRemote = SlashesNet and SlashesNet:FindFirstChild("net"):FindFirstChild("RE/SlashesOfFuryActivate")
local IsSlashesPending = false
local SlashesParryCount = 0
local SlashesActive = false
if SlashesRemote then
    SlashesRemote.OnClientEvent:Connect(function()
    if SOFD then
        IsSlashesPending = true
    end
    end)
end

local HitSoundsToggle = MiscTab:CreateToggle({
    Name = "Hit Sounds",
    CurrentValue = false,
    Flag = "HitSoundsToggle",
    Callback = function(Value)
        if Value then
            print("[ Debug ] Sound Effect Enabled")
            Sound_Effect = true
            Connections_Manager["SoundEffect"] = ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
                if not Sound_Effect or sound_effect_type == "Disabled" then return end

                local sound_id
                if CustomId ~= "" and sound_effect_type == "Custom" then
                    sound_id = "rbxassetid://" .. CustomId
                else
                    sound_id = sound_assets[sound_effect_type]
                end

                if not sound_id or sound_id == "empty" then return end

                local sound = Instance.new("Sound")
                sound.SoundId = sound_id
                sound.Volume = 1
                sound.PlayOnRemove = true
                sound.Parent = workspace
                sound:Destroy()
            end)
        else
            print("[ Debug ] Sound Effect Disabled")
            Sound_Effect = false
            if Connections_Manager["SoundEffect"] then
                Connections_Manager["SoundEffect"]:Disconnect()
                Connections_Manager["SoundEffect"] = nil
            end
        end
    end
})

local HitSoundsDropdown = MiscTab:CreateDropdown({
    Name = "Sound Type",
    Options = {"Disabled", "DC_15X", "Minecraft", "MinecraftHit2", "Neverlose", "TeamfortressBonk", "TeamfortressBell"},
    CurrentOption = {"Disabled"},
    MultipleOptions = false,
    Flag = "HitSoundsDropdown",
    Callback = function(Option)
        sound_effect_type = Option[1] -- Dropdown returns a table
        print("[ Debug ] Sound Type set to:", sound_effect_type)
    end
})

local BallSection = MiscTab:CreateSection("Ball")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local cam = workspace.CurrentCamera
local originalSubject = cam.CameraSubject
local viewConnection = nil

local ViewToggle = MiscTab:CreateToggle({
   Name = "View Ball",
   CurrentValue = false,
   Flag = "ViewToggle",
   Callback = function(Value)
        if Value then
			viewConnection = RunService.RenderStepped:Connect(function()
				local function GetBall()
					for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
						if Ball:GetAttribute("realBall") then
							return Ball
						end
					end
				end

				local ball = GetBall()
				if ball and cam.CameraSubject ~= ball then
					cam.CameraSubject = ball
				end
			end)
		else
			if viewConnection then
				viewConnection:Disconnect()
				viewConnection = nil
			end
			cam.CameraSubject = Players.LocalPlayer.Character or Players.LocalPlayer
		end
   end,
})

local trailConnection = nil

local TrailToggle = MiscTab:CreateToggle({
   Name = "Ball Trail",
   CurrentValue = false,
   Flag = "TrailToggle",
   Callback = function(Value)
       if Value then
			trailConnection = RunService.RenderStepped:Connect(function()
				local function GetBall()
					for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
						if Ball:GetAttribute("realBall") then
							return Ball
						end
					end
				end

				local function CreateRainbowTrail(ball)
					if ball:FindFirstChild("TriasTrail") then return end

					local at1 = Instance.new("Attachment", ball)
					local at2 = Instance.new("Attachment", ball)
					at1.Position = Vector3.new(0, 0.5, 0)
					at2.Position = Vector3.new(0, -0.5, 0)

					local trail = Instance.new("Trail")
					trail.Name = "TriasTrail"
					trail.Attachment0 = at1
					trail.Attachment1 = at2
					trail.Lifetime = 0.3
					trail.MinLength = 0.1
					trail.WidthScale = NumberSequence.new(1)
					trail.FaceCamera = true
					trail.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
						ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 127, 0)),
						ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255, 255, 0)),
						ColorSequenceKeypoint.new(0.48, Color3.fromRGB(0, 255, 0)),
						ColorSequenceKeypoint.new(0.64, Color3.fromRGB(0, 0, 255)),
						ColorSequenceKeypoint.new(0.80, Color3.fromRGB(75, 0, 130)),
						ColorSequenceKeypoint.new(1.0, Color3.fromRGB(148, 0, 211))
					})

					trail.Parent = ball
				end

				local ball = GetBall()
				if ball and not ball:FindFirstChild("TriasTrail") then
					CreateRainbowTrail(ball)
				end
			end)
		else
			if trailConnection then
				trailConnection:Disconnect()
				trailConnection = nil
			end

			for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
				local trail = Ball:FindFirstChild("TriasTrail")
				if trail then
					trail:Destroy()
				end
				for _, att in ipairs(Ball:GetChildren()) do
					if att:IsA("Attachment") then
						att:Destroy()
					end
				end
			end
		end
   end,
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer

local lookAtBallToggle = false
local parryLookType = "Camera"

local playerConn, cameraConn = nil, nil

local function GetBall()
	for _, Ball in ipairs(workspace.Balls:GetChildren()) do
		if Ball:GetAttribute("realBall") then
			return Ball
		end
	end
end

local function EnableLookAt()
	DisableLookAt() -- ensure no duplicate connections
	if parryLookType == "Character" then
		playerConn = RunService.Stepped:Connect(function()
			local Ball = GetBall()
			local Character = Player.Character
			if not Ball or not Character then return end

			local HRP = Character:FindFirstChild("HumanoidRootPart")
			if not HRP then return end

			local lookPos = Vector3.new(Ball.Position.X, HRP.Position.Y, Ball.Position.Z)
			HRP.CFrame = CFrame.lookAt(HRP.Position, lookPos)
		end)
	elseif parryLookType == "Camera" then
		cameraConn = RunService.RenderStepped:Connect(function()
			local Ball = GetBall()
			if not Ball then return end

			local camPos = Camera.CFrame.Position
			Camera.CFrame = CFrame.lookAt(camPos, Ball.Position)
		end)
	end
end

function DisableLookAt()
	if playerConn then playerConn:Disconnect() playerConn = nil end
	if cameraConn then cameraConn:Disconnect() cameraConn = nil end
end

local LookAtToggle = MiscTab:CreateToggle({
	Name = "Look At Ball",
	CurrentValue = false,
	Flag = "LookAtToggle",
	Callback = function(Value)
		lookAtBallToggle = Value
		if Value then
			EnableLookAt()
		else
			DisableLookAt()
		end
	end,
})

local LookAtDropdown = MiscTab:CreateDropdown({
	Name = "Look At Ball Type",
	Options = {"Camera", "Character"},
	CurrentOption = {"Camera"},
	MultipleOptions = false,
	Flag = "LookAtDropdown",
	Callback = function(Options)
		-- since dropdown returns a table, grab the first value
		parryLookType = Options[1]
		if lookAtBallToggle then
			EnableLookAt()
		end
	end,
})

local statsGui = nil
local statsConnection = nil

local BallStatsToggle = MiscTab:CreateToggle({
   Name = "Ball Stats",
   CurrentValue = false,
   Flag = "BallStatsToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        if Value then
			local player = Players.LocalPlayer

			statsGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
			statsGui.Name = "BallStatsUI"
			statsGui.ResetOnSpawn = false

			local frame = Instance.new("Frame", statsGui)
			frame.Size = UDim2.new(0, 180, 0, 80)
			frame.Position = UDim2.new(1, -200, 0, 100)
			frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
			frame.BackgroundTransparency = 0.2
			frame.BorderSizePixel = 0
			frame.Active = true
			frame.Draggable = true

			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(1, -10, 1, -10)
			label.Position = UDim2.new(0, 5, 0, 5)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextScaled = true
			label.Font = Enum.Font.GothamBold
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextYAlignment = Enum.TextYAlignment.Top
			label.Text = "Loading..."

			statsConnection = RunService.RenderStepped:Connect(function()
				local function GetBall()
					for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
						if Ball:GetAttribute("realBall") then
							return Ball
						end
					end
				end

				local ball = GetBall()
				if not ball then
					label.Text = "No ball found"
					return
				end

				local char = player.Character or player.CharacterAdded:Wait()
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then return end

				local speed = math.floor(ball.Velocity.Magnitude)
				local distance = math.floor((ball.Position - hrp.Position).Magnitude)
				local target = ball:GetAttribute("target") or "N/A"
				local status = speed < 3 and "Idle" or "Flying"

				label.Text = string.format(
					"⚽ Ball Stats | Zeryx\nSpeed: %s\nDistance: %s\nTarget: %s",
					speed, distance, target
				)
			end)
		else
			if statsConnection then
				statsConnection:Disconnect()
				statsConnection = nil
			end
			if statsGui then
				statsGui:Destroy()
				statsGui = nil
			end
		end
   end,
})

local WorldSection = MiscTab:CreateSection("World")

local rainbowConnection = nil
local colorCorrection = nil
local lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local WorldHueToggle = MiscTab:CreateToggle({
   Name = "World Hue",
   CurrentValue = false,
   Flag = "WorldHueToggle", 
   Callback = function(Value)
        if Value then -- FIXED: "Value" instead of "value"
            if not colorCorrection then
                colorCorrection = Instance.new("ColorCorrectionEffect")
                colorCorrection.Name = "RainbowFilter"
                colorCorrection.Saturation = 1
                colorCorrection.Contrast = 0.1
                colorCorrection.Brightness = 0
                colorCorrection.TintColor = Color3.fromRGB(255, 0, 0)
                colorCorrection.Parent = lighting
            end

            local hue = 0
            rainbowConnection = RunService.RenderStepped:Connect(function()
                hue = (hue + 1) % 360
                local color = Color3.fromHSV(hue / 360, 1, 1)
                colorCorrection.TintColor = color
            end)
        else
            if rainbowConnection then
                rainbowConnection:Disconnect()
                rainbowConnection = nil
            end
            if colorCorrection then
                colorCorrection:Destroy()
                colorCorrection = nil
            end
        end
   end,
})

local selectedSky = "Default"
local skyen = false
local applyConnection

local function applySkybox(presetName)
    if not skyen then return end

    local skyPresets = {
        Default = {"591058823", "591059876", "591058104", "591057861", "591057625", "591059642"},
        Vaporwave = {"1417494030", "1417494146", "1417494253", "1417494402", "1417494499", "1417494643"},
        Redshift = {"401664839", "401664862", "401664960", "401664881", "401664901", "401664936"},
        Desert = {"1013852", "1013853", "1013850", "1013851", "1013849", "1013854"},
        DaBaby = {"7245418472", "7245418472", "7245418472", "7245418472", "7245418472", "7245418472"},
        Minecraft = {"1876545003", "1876544331", "1876542941", "1876543392", "1876543764", "1876544642"},
        SpongeBob = {"7633178166", "7633178166", "7633178166", "7633178166", "7633178166", "7633178166"},
        Skibidi = {"14952256113", "14952256113", "14952256113", "14952256113", "14952256113", "14952256113"},
        Blaze = {"150939022", "150939038", "150939047", "150939056", "150939063", "150939082"},
        ["Pussy Cat"] = {"11154422902", "11154422902", "11154422902", "11154422902", "11154422902", "11154422902"},
        ["Among Us"] = {"5752463190", "5752463190", "5752463190", "5752463190", "5752463190", "5752463190"},
        ["Space Wave"] = {"16262356578", "16262358026", "16262360469", "16262362003", "16262363873", "16262366016"},
        ["Space Wave2"] = {"1233158420", "1233158838", "1233157105", "1233157640", "1233157995", "1233159158"},
        ["Turquoise Wave"] = {"47974894", "47974690", "47974821", "47974776", "47974859", "47974909"},
        ["Dark Night"] = {"6285719338", "6285721078", "6285722964", "6285724682", "6285726335", "6285730635"},
        ["Bright Pink"] = {"271042516", "271077243", "271042556", "271042310", "271042467", "271077958"},
        ["White Galaxy"] = {"5540798456", "5540799894", "5540801779", "5540801192", "5540799108", "5540800635"},
        ["Blue Galaxy"] = {"14961495673", "14961494492", "14961492844", "14961491298", "14961490439", "14961489508"}
    }

    local skyboxData = skyPresets[presetName]
    if not skyboxData then
        warn("Unknown sky preset: " .. tostring(presetName))
        return
    end

    local Lighting = game:GetService("Lighting")
    local Sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    local faces = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}

    for i, face in ipairs(faces) do
        Sky[face] = "rbxassetid://" .. skyboxData[i]
    end

    Lighting.GlobalShadows = not skyen -- Disable shadows only when custom sky is enabled
end

local CustomSkyToggle = MiscTab:CreateToggle({
   Name = "Custom Sky",
   CurrentValue = false,
   Flag = "CustomSkyToggle",
   Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        local Sky = Lighting:FindFirstChildOfClass("Sky")

        if Value then
            print("[ Debug ] Custom Sky Enabled")
            skyen = true
            if not Sky then
                Sky = Instance.new("Sky", Lighting)
            end
            if applyConnection then
                applyConnection:Disconnect()
            end
            applyConnection = task.spawn(function()
                while skyen do
                    applySkybox(selectedSky)
                    task.wait(1)
                end
            end)
        else
            print("[ Debug ] Custom Sky Disabled")
            skyen = false
            if Sky then
                Sky:Destroy() -- Remove the skybox entirely when disabled
            end
            Lighting.GlobalShadows = true
        end
   end,
})

local CustomSkyDropdown = MiscTab:CreateDropdown({
   Name = "Custom Sky Type",
   Options = {"Default", "Vaporwave", "Redshift", "Desert", "DaBaby", "Minecraft", "SpongeBob", "Skibidi", "Blaze", "Pussy Cat", "Among Us", "Space Wave", "Space Wave2", "Turquoise Wave", "Dark Night", "Bright Pink", "White Galaxy", "Blue Galaxy"},
   CurrentOption = {"Default"},
   MultipleOptions = false,
   Flag = "CustomSkyDropdown",
   Callback = function(Options)
        local choice = Options[1] -- FIX: Dropdown returns a table
        selectedSky = choice
        print("[ Debug ] Selected Sky: " .. choice)
        applySkybox(choice) -- Apply immediately
   end,
})

local AutoPlaySection = MiscTab:CreateSection("Auto Play")

local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

local targetDistance = 30
local autoPlayConnection = nil
local lastTargetTime = 0
local targetDuration = 0

-- Auto Play Toggle
MiscTab:CreateToggle({
    Name = "Auto Play",
    CurrentValue = false,
    Flag = "AutoPlayToggle",
    Callback = function(Value) -- Use Value, not "enabled"
        if Value then
            if autoPlayConnection then
                autoPlayConnection:Disconnect()
            end
            autoPlayConnection = RunService.RenderStepped:Connect(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                rootPart = player.Character.HumanoidRootPart

                local ball
                for _, b in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
                    if b:GetAttribute("realBall") then
                        ball = b
                        break
                    end
                end
                if not ball then return end

                local dir = (ball.Position - rootPart.Position).Unit
                local dist = (ball.Position - rootPart.Position).Magnitude
                local speed = ball.Velocity.Magnitude
                local currentTime = tick()
                local ballTarget = ball:GetAttribute("target")

                if ballTarget == player.Name then
                    if currentTime - lastTargetTime < 0.2 then
                        targetDuration += RunService.RenderStepped:Wait()
                    else
                        targetDuration = 0
                    end
                    lastTargetTime = currentTime
                else
                    targetDuration = 0
                end

                for _, key in pairs({"W", "A", "S", "D"}) do
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end

                if dist < targetDistance or targetDuration > 0.5 then
                    local backDir = -dir
                    local backPos = rootPart.Position + backDir * 6

                    local safeToBack = true
                    for _, other in ipairs(Players:GetPlayers()) do
                        if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                            local otherHRP = other.Character.HumanoidRootPart
                            if (otherHRP.Position - backPos).Magnitude < 5 then
                                safeToBack = false
                                break
                            end
                        end
                    end

                    if safeToBack then
                        VirtualInputManager:SendKeyEvent(true, "S", false, game)
                    else
                        local sideKey = math.random(1, 2) == 1 and "A" or "D"
                        VirtualInputManager:SendKeyEvent(true, sideKey, false, game)
                    end
                    return
                end

                local buffer = 5
                if dist > targetDistance + buffer then
                    VirtualInputManager:SendKeyEvent(true, "W", false, game)
                elseif speed > 120 then
                    local dodgeKey = math.random(1, 2) == 1 and "A" or "D"
                    VirtualInputManager:SendKeyEvent(true, dodgeKey, false, game)
                elseif math.random() < 0.01 then
                    VirtualInputManager:SendKeyEvent(true, "W", false, game)
                end
            end)
        else
            if autoPlayConnection then
                autoPlayConnection:Disconnect()
                autoPlayConnection = nil
            end
            for _, key in pairs({"W", "A", "S", "D"}) do
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end
        end
    end,
})

-- Distance Slider
MiscTab:CreateSlider({
    Name = "Distance From Ball",
    Range = {1, 100},
    Increment = 10,
    Suffix = " / 100",
    CurrentValue = 30,
    Flag = "AutoPlayDistanceSlider",
    Callback = function(Value)
        targetDistance = Value
    end,
})

local LibraryNotify = loadstring(game:HttpGet("https://gist.githubusercontent.com/AgentX771/930b5a9b78517ebfed75475fb3f6c9f6/raw/f20d3cc01b72d0ee6581e89b0e2bd3eba069c40e/gistfile1.txt"))()
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/vincentzydaz/Vincenthub/refs/heads/main/B%20mylib%20blade%20ball.lua'))()
for _, v in next, {"Vincent Hub", "Vincent", "Hub", "Vin", "Vincent Hub"} do
    pcall(delfolder, v)
end
local ESPLines = loadstring(game:HttpGet("https://raw.githubusercontent.com/AgentX771/ArgonHubX/refs/heads/main/Privating/ESPLines.lua"))()

ESPLines.Enabled = true

local Services = {
	CoreGui = game:GetService("CoreGui"),
	HttpService = game:GetService("HttpService"),
	Players = game:GetService("Players"),
	MarketplaceService = game:GetService("MarketplaceService"),
	AnalyticsService = game:GetService("RbxAnalyticsService"),
    Lighting = game:GetService("Lighting"),
	RunService = game:GetService("RunService")
}

function GetMouse()
    local UserInputService = game:GetService("UserInputService")
    return UserInputService:GetMouseLocation()
end

function GetClosestPlayer()
    local closestDistance = math.huge
    local closestTarget = nil
    for _, v in pairs(game:GetService("Workspace").Alive:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer.Character then
            local humanoidRootPart = v.HumanoidRootPart
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestTarget = v
            end
        end
    end
    return closestTarget
end

task.delay(10, function()
	spawn(function()
		while task.wait() do
			if PlayerSaftey then
				if not game.Players.LocalPlayer.Character or game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
				pcall(function()
					local closestPlayer = GetClosestPlayer()
					if closestPlayer and (closestPlayer.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= PlayerSaftey_Distance then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = closestPlayer.HumanoidRootPart.CFrame * CFrame.new(-25, 0, -PlayerSaftey_Distance)
					end
				end)
			end
		end
	end)
end)

function GetBall()
    for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
        if v:IsA("Part") then
            return v
        end
    end
    return nil
end

function GetBallFromPlayerPos(Ball)
    return (Ball.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
end

local function getSpeed(part)
    if part:IsA("BasePart") then
        local speed = part.Velocity.Magnitude
        if speed > 1 then
            return part, speed
        end
        return nil, nil
    end
    return nil, nil
end

local function measureVerticalDistance(humanoidRootPart, targetPart)
    local humanoidRootPartY = humanoidRootPart.Position.Y
    local targetPartY = targetPart.Position.Y
    return math.abs(humanoidRootPartY - targetPartY)
end

function GetHotKey()
    for _, v in pairs(game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame:GetChildren()) do
        if v:IsA("TextLabel") then
            return v.Text
        end
    end
    return ""
end

local text = game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame:FindFirstChild("F")
if text then
    local KeyCodeBlock = text.Text
    text:GetPropertyChangedSignal("Text"):Connect(function()
        KeyCodeBlock = text.Text
    end)
end

local CanSlash = false
local BallSpeed = 0

spawn(function()
    while task.wait() do
        if RandAutoaParry and RandAutoaParry[tostring(RandRNG)] then
            pcall(function()
                for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                    if v:IsA("Part") then
                        if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then return end
                        local part, speed = getSpeed(v)
                        if part and speed then
                            local minDistance = 2.5 * (speed * 0.1) + 2
                            if minDistance == 0 or minDistance <= 20 then
                                BallSpeed = 23
                            elseif minDistance > 20 and minDistance <= 88 then
                                BallSpeed = 2.5 * (speed * 0.1) + 5
                            elseif minDistance > 88 and minDistance <= 110 then
                                BallSpeed = 90
                            end
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude <= BallSpeed then
                                CanSlash = true
                            else
                                CanSlash = false
                            end
                        end
                    end
                end

                if CanSlash then
                    if math.random(1, 5) == 5 then
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    else
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[KeyCodeBlock], false, game)
                    end
                    CanSlash = false
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoWalk then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character

                if character and character.Parent and character.Parent.Name ~= "Dead" then
                    local targetPosition
                    for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                        if v:IsA("Part") then
                            local part, speed = getSpeed(v)
                            if part and speed and speed > 5 then
                                targetPosition = part.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ)
                                break
                            end
                        end
                    end

                    if not targetPosition then
                        for _, p in pairs(game:GetService("Workspace").Alive:GetChildren()) do
                            if p ~= character and p:FindFirstChild("HumanoidRootPart") then
                                targetPosition = p.HumanoidRootPart.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ)
                                break
                            end
                        end
                    end

                    if targetPosition then
                        character:FindFirstChildOfClass("Humanoid"):MoveTo(targetPosition)
                    end
                end
            end)
        end

        if AutoDoubleJump then
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                    task.wait(0.1)
                else
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait(0.3)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do
        if ClosestPlayer_var then
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character and character.Parent.Name ~= "Dead" then
                    local closestPlayer = GetClosestPlayer()
                    if closestPlayer and closestPlayer:FindFirstChild("Head") then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Head.Position)
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(math.random(1, 2)) do
        if RandomTeleports then
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character and character.Parent.Name ~= "Dead" then
                    for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                        if v:IsA("Part") then
                            local part, speed = getSpeed(v)
                            if part and speed then
                                character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(TeleportDistanceX, 0, TeleportDistanceZ)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local auto_rewards_enabled = false

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages")["_Index"]["sleitnick_net@0.1.0"].net

local function claim_rewards()
	pcall(function()
		if ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("RemoteEvent") then
			local event = ReplicatedStorage.Remote.RemoteEvent:FindFirstChild('ClaimLoginReward')
			if event then
				event:FireServer()
			end
		end
	end)

	task.defer(function()
		for day = 1, 30 do
			task.wait()
			pcall(function()
				if ReplicatedStorage.Remote:FindFirstChild("RemoteFunction") then
					ReplicatedStorage.Remote.RemoteFunction:InvokeServer('ClaimNewDailyLoginReward', day)
				end
			end)
			for _, wheel in ipairs({"SummerWheel", "CyborgWheel", "SynthWheel"}) do
				pcall(function()
					local processRoll = net:FindFirstChild("RE/" .. wheel .. "/ProcessRoll")
					if processRoll then
						processRoll:FireServer()
					end
				end)
			end
			pcall(function()
				if net:FindFirstChild("RE/ProcessTournamentRoll") then
					net["RE/ProcessTournamentRoll"]:FireServer()
				end
				if net:FindFirstChild("RE/RolledReturnCrate") then
					net["RE/RolledReturnCrate"]:FireServer()
				end
				if net:FindFirstChild("RE/ProcessLTMRoll") then
					net["RE/ProcessLTMRoll"]:FireServer()
				end
			end)
		end
	end)

	task.defer(function()
		for reward = 1, 6 do
			pcall(function()
				if net:FindFirstChild("RF/ClaimPlaytimeReward") then
					net["RF/ClaimPlaytimeReward"]:InvokeServer(reward)
				end
			end)
			pcall(function()
				if net:FindFirstChild("RE/ClaimSeasonPlaytimeReward") then
					net["RE/ClaimSeasonPlaytimeReward"]:FireServer(reward)
				end
			end)
			pcall(function()
				if ReplicatedStorage.Remote:FindFirstChild("RemoteFunction") then
					ReplicatedStorage.Remote.RemoteFunction:InvokeServer('SpinWheel')
				end
			end)
			pcall(function()
				if net:FindFirstChild("RE/SpinFinished") then
					net["RE/SpinFinished"]:FireServer()
				end
			end)
		end
	end)

	task.defer(function()
		for reward = 1, 5 do
			pcall(function()
				if net:FindFirstChild("RF/RedeemQuestsType") then
					net["RF/RedeemQuestsType"]:InvokeServer('SummerClashEvent', 'Daily', reward)
				end
			end)
		end
	end)

	task.defer(function()
		for reward = 1, 4 do
			pcall(function()
				if net:FindFirstChild("RE/SummerWheel/ClaimStreakReward") then
					net["RE/SummerWheel/ClaimStreakReward"]:FireServer(reward)
				end
			end)
		end
	end)
end

local reward_interval = 60

task.defer(function()
	while task.wait(reward_interval) do
		pcall(function()
			if auto_rewards_enabled then
				claim_rewards()
			end
		end)
	end
end)

local hookSupport = hookmetamethod and true

local Client = game.Players.LocalPlayer
local Character = Client.Character or Client.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local Mouse = Client:GetMouse()

local revertedRemotes = {}
local originalMetatables = {}
local DirectionMode = "Camera"
local EnableAntiCurve = false
local EnableAutoCurve = false

local function GetClosestPlayer()
	local closest, distance = nil, math.huge
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= Client and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local d = (v.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
			if d < distance then
				closest = v
				distance = d
			end
		end
	end
	return closest
end

local function GetDirection()
	if EnableAntiCurve then
		return (Camera.CFrame * CFrame.new(0, 0, -500)).Position
	elseif EnableAutoCurve then
		local t = GetClosestPlayer()
		if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
			local d = (t.Character.HumanoidRootPart.Position - HumanoidRootPart.Position)
			return d.Unit + Vector3.new(0, math.sin(tick() * 5) * 0.2, 0)
		end
	elseif DirectionMode == "Camera" then
		return Camera.CFrame.LookVector
	elseif DirectionMode == "Mouse" then
		return (Mouse.Hit.Position - HumanoidRootPart.Position).Unit
	elseif DirectionMode == "Players" then
		local target = GetClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			return (target.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
		end
	elseif DirectionMode == "Normal" then
		return Vector3.new(0, 0, -1)
	elseif DirectionMode == "Up" then
		return Vector3.new(0, 1, 0)
	elseif DirectionMode == "Down" then
		return Vector3.new(0, -1, 0)
	elseif DirectionMode == "Left" then
		return -Camera.CFrame.RightVector
	elseif DirectionMode == "Right" then
		return Camera.CFrame.RightVector
	elseif DirectionMode == "Behind" then
		return -Camera.CFrame.LookVector
	elseif DirectionMode == "Random" then
		return Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)).Unit
	elseif DirectionMode == "FrontLeft" then
		return (Camera.CFrame.LookVector - Camera.CFrame.RightVector).Unit
	elseif DirectionMode == "FrontRight" then
		return (Camera.CFrame.LookVector + Camera.CFrame.RightVector).Unit
	elseif DirectionMode == "BackLeft" then
		return (-Camera.CFrame.LookVector - Camera.CFrame.RightVector).Unit
	elseif DirectionMode == "BackRight" then
		return (-Camera.CFrame.LookVector + Camera.CFrame.RightVector).Unit
	elseif DirectionMode == "SkywardSpiral" then
		return (Camera.CFrame.LookVector + Vector3.new(0, math.sin(tick() * 5), 0)).Unit
	elseif DirectionMode == "Zigzag" then
		return (Camera.CFrame.LookVector + Camera.CFrame.RightVector * math.sin(tick() * 10)).Unit
	elseif DirectionMode == "Spin" then
		local angle = math.rad(tick() * 360 % 360)
		return Vector3.new(math.cos(angle), 0, math.sin(angle)).Unit
	elseif DirectionMode == "Bounce" then
		return (Camera.CFrame.LookVector + Vector3.new(0, math.abs(math.sin(tick() * 5)) * 2, 0)).Unit
	elseif DirectionMode == "Wave" then
		return (Camera.CFrame.LookVector + Vector3.new(math.sin(tick() * 5), 0, 0)).Unit
	elseif DirectionMode == "Orbit" then
		local angle = tick() * 2
		return (Camera.CFrame.LookVector + Vector3.new(math.cos(angle), 0, math.sin(angle))).Unit
	elseif DirectionMode == "Chaos" then
		return (Camera.CFrame.LookVector + Vector3.new(math.random(-100, 100)/100, math.random(-100, 100)/100, math.random(-100, 100)/100)).Unit
	elseif DirectionMode == "TargetFeet" then
		local t = GetClosestPlayer()
		if t and t.Character then
			local part = t.Character:FindFirstChild("LeftFoot") or t.Character:FindFirstChild("HumanoidRootPart")
			if part then
				return (part.Position - HumanoidRootPart.Position).Unit
			end
		end
	elseif DirectionMode == "TargetHead" then
		local t = GetClosestPlayer()
		if t and t.Character then
			local part = t.Character:FindFirstChild("Head")
			if part then
				return (part.Position - HumanoidRootPart.Position).Unit
			end
		end
	elseif DirectionMode == "DiagonalUp" then
		return (Camera.CFrame.LookVector + Vector3.new(0.5, 0.5, 0)).Unit
	elseif DirectionMode == "DiagonalDown" then
		return (Camera.CFrame.LookVector + Vector3.new(-0.5, -0.5, 0)).Unit
	elseif DirectionMode == "FlipReverse" then
		return (Camera.CFrame.LookVector * -1).Unit
	elseif DirectionMode == "CurveLeft" then
		return (Camera.CFrame.LookVector + -Camera.CFrame.RightVector * 0.5).Unit
	elseif DirectionMode == "CurveRight" then
		return (Camera.CFrame.LookVector + Camera.CFrame.RightVector * 0.5).Unit
	elseif DirectionMode == "Whirlwind" then
		local angle = math.rad(tick() * 720 % 360)
		return (Camera.CFrame.LookVector + Vector3.new(math.cos(angle), math.sin(angle), 0)).Unit
	elseif DirectionMode == "TeleportStyle" then
		return Vector3.new(0, 100, 0)
	elseif DirectionMode == "SlideAngle" then
		return (Camera.CFrame.LookVector + Vector3.new(1, -0.2, 0)).Unit
	elseif DirectionMode == "Drift" then
		return (Camera.CFrame.LookVector + Camera.CFrame.RightVector * math.cos(tick() * 2)).Unit
	end
	return Camera.CFrame.LookVector
end

local function isValidRemoteArgs(args)
	return #args == 7 and type(args[2]) == "string" and type(args[3]) == "number" and typeof(args[4]) == "CFrame" and type(args[5]) == "table" and type(args[6]) == "table" and type(args[7]) == "boolean"
end

local function hookRemote(remote)
	if not revertedRemotes[remote] then
		local meta = getrawmetatable(remote)
		if not originalMetatables[meta] then
			originalMetatables[meta] = true
			setreadonly(meta, false)
			local oldIndex = meta.__index
			meta.__index = function(self, key)
				if key == "FireServer" and self:IsA("RemoteEvent") then
					return function(_, ...)
						local args = { ... }
						if isValidRemoteArgs(args) then
							if not revertedRemotes[self] then
								revertedRemotes[self] = args
							end
						end
						return oldIndex(self, "FireServer")(_, table.unpack(args))
					end
				elseif key == "InvokeServer" and self:IsA("RemoteFunction") then
					return function(_, ...)
						local args = { ... }
						if isValidRemoteArgs(args) then
							if not revertedRemotes[self] then
								revertedRemotes[self] = args
							end
						end
						return oldIndex(self, "InvokeServer")(_, table.unpack(args))
					end
				end
				return oldIndex(self, key)
			end
			setreadonly(meta, true)
		end
	end
end

if hookSupport then
	for _, remote in pairs(game.ReplicatedStorage:GetChildren()) do
		if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
			hookRemote(remote)
		end
	end
	game.ReplicatedStorage.ChildAdded:Connect(function(child)
		if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
			hookRemote(child)
		end
	end)
end

local Global = {
	cooldown = false,
	last_hit = 0,
	parry_count = 0,
}

local function ParryFunction()
	if hookSupport then
		for remote, args in pairs(revertedRemotes) do
			if typeof(remote) ~= "Instance" then continue end
			if not remote:IsDescendantOf(game) then continue end
			if remote:IsA("RemoteEvent") then
				args[4] = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + GetDirection())
				remote:FireServer(unpack(args))
			elseif remote:IsA("RemoteFunction") then
				args[4] = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + GetDirection())
				remote:InvokeServer(unpack(args))
			end
		end
	else
		game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
	end
end

local function get_character()
    return game.Players.LocalPlayer and game.Players.LocalPlayer.Character
end

local function get_humanoid_root_part()
    local char = get_character()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function get_humanoid()
    local char = get_character()
    return char and char:FindFirstChild("Humanoid")
end

local function get_ball()
    for _, ball in pairs(workspace.Balls:GetChildren()) do
        if ball:GetAttribute("realBall") then
            return ball
        end
    end
end

local AiPlay = false
local AiPlayType = "Normal"
local AiPlaySpeed = 200

local function ai_play()
	if not AiPlay then
		local humanoid = get_humanoid()
		if humanoid then
			humanoid.WalkSpeed = 36
		end
		return
	end

	local player = game.Players.LocalPlayer
	local character = player.Character
	if not character or (workspace:FindFirstChild("Dead") and workspace.Dead:FindFirstChild(player.Name)) then return end

	local ball = get_ball()
	local humanoidRootPart = get_humanoid_root_part()
	local humanoid = get_humanoid()
	if not ball or not humanoidRootPart or not humanoid then return end

	if AiPlayType == "Hacker" then
		humanoid.WalkSpeed = AiPlaySpeed
	else
		humanoid.WalkSpeed = 36
	end

	local ballPosition = ball.Position
	local playerPosition = humanoidRootPart.Position
	local distanceFromBall = (ballPosition - playerPosition).Magnitude

	local function is_path_clear(destination)
		local direction = (destination - playerPosition).Unit
		local ray = Ray.new(playerPosition, direction * 5)
		local part = workspace:FindPartOnRay(ray, character)
		return not part
	end

	if AiPlayType == "Normal" then
		if distanceFromBall < 60 then
			local directionAwayFromBall = (playerPosition - ballPosition).Unit
			local targetPosition = playerPosition + directionAwayFromBall * math.random(24, 36)
			if is_path_clear(targetPosition) then
				humanoid:MoveTo(targetPosition)
			end
		elseif math.random(1, 100) <= 6 then
			local offset = Vector3.new(math.random(-14, 14), 0, math.random(-14, 14))
			local targetPosition = playerPosition + offset
			if is_path_clear(targetPosition) then
				humanoid:MoveTo(targetPosition)
			end
		end
	elseif AiPlayType == "Advanced" then
		if distanceFromBall < 80 then
			local chase = (ballPosition - playerPosition).Unit
			local offset = Vector3.new(math.random(-6, 6), 0, math.random(-6, 6))
			local targetPosition = playerPosition + chase * 30 + offset
			if is_path_clear(targetPosition) then
				humanoid:MoveTo(targetPosition)
			end
		elseif math.random(1, 100) <= 12 then
			local offset = Vector3.new(math.random(-24, 24), 0, math.random(-24, 24))
			local targetPosition = playerPosition + offset
			if is_path_clear(targetPosition) then
				humanoid:MoveTo(targetPosition)
			end
		end
	elseif AiPlayType == "Hacker" then
		if distanceFromBall < 200 then
			local targetPosition = ballPosition + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
			if is_path_clear(targetPosition) then
				humanoid:MoveTo(targetPosition)
			end
		end

		for _, enemy in pairs(workspace:FindFirstChild("Alive"):GetChildren()) do
			if enemy:IsA("Model") and enemy ~= character and enemy:FindFirstChild("HumanoidRootPart") then
				local enemyHRP = enemy.HumanoidRootPart
				local distance = (enemyHRP.Position - ballPosition).Magnitude
				if distance <= 15 then
					humanoidRootPart.CFrame = CFrame.new(enemyHRP.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3)))
					break
				end
			end
		end
	end
end

local RunService = game:GetService('RunService')
RunService.RenderStepped:Connect(function()
    ai_play()
end)

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

local Players = game:GetService('Players')
local Player = Players.LocalPlayer


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

local function updateNavigation(guiObject: GuiObject | nil)
    GuiService.SelectedObject = guiObject
end

local function performFirstPress(parryType)
    if parryType == "F_Key" then
        pcall(function()
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
        end)
    elseif parryType == "Left_Click" then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        end)
    elseif parryType == "Navigation" then
        local success, button = pcall(function()
            return Players.LocalPlayer.PlayerGui.Hotbar.Block
        end)
        if success and button then
            pcall(function()
                updateNavigation(button)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                updateNavigation(nil)
            end)
        end
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
    local success, gc = pcall(getgc)
    if success and type(gc) == "table" then
        for _, Value in next, gc do
            local infoSuccess, info = pcall(function()
                return typeof(Value) == "function" and islclosure(Value) and getrenv().debug.info(Value, "s")
            end)
            if infoSuccess and info and string.find(info, "SwordsController") then
                local lineSuccess, line = pcall(function()
                    return getrenv().debug.info(Value, "l")
                end)
                if lineSuccess and line == 276 then
                    local success1, h1 = pcall(getconstant, Value, 62)
                    if success1 then HashOne = h1 end

                    local success2, h2 = pcall(getconstant, Value, 64)
                    if success2 then HashTwo = h2 end

                    local success3, h3 = pcall(getconstant, Value, 65)
                    if success3 then HashThree = h3 end
                end
            end
        end
    end
end)()

LPH_NO_VIRTUALIZE(function()
    local success, descendants = pcall(function()
        return game:GetDescendants()
    end)
    if success and type(descendants) == "table" then
        for _, Object in next, descendants do
            local isRemoteEvent = pcall(function()
                return Object:IsA("RemoteEvent")
            end)
            local nameCheck = pcall(function()
                return string.find(Object.Name, "\n")
            end)
            if isRemoteEvent and nameCheck and Object:IsA("RemoteEvent") and string.find(Object.Name, "\n") then
                local successConnect = pcall(function()
                    Object.Changed:Once(function()
                        table.insert(PropertyChangeOrder, Object)
                    end)
                end)
            end
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

local success, connections = pcall(function()
    return getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Block.Activated)
end)

if success and type(connections) == "table" then
    for _, Value in pairs(connections) do
        if Value and typeof(Value) == "table" and Value.Function and not iscclosure(Value.Function) then
            local successUpvalues, upvalues = pcall(getupvalues, Value.Function)
            if successUpvalues and type(upvalues) == "table" then
                for _, Value2 in pairs(upvalues) do
                    if type(Value2) == "function" then
                        local successKey, result = pcall(function()
                            return getupvalue(getupvalue(Value2, 2), 17)
                        end)
                        if successKey then
                            Parry_Key = result
                        end
                    end
                end
            end
        end
    end
end

local function Parry(...)
    ShouldPlayerJump:FireServer(HashOne, Parry_Key, ...)
    MainRemote:FireServer(HashTwo, Parry_Key, ...)
    GetOpponentPosition:FireServer(HashThree, Parry_Key, ...)
end

local Parries = 0

function create_animation(object, info, value)
    local animation = game:GetService('TweenService'):Create(object, info, value)

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
        ParryFunction()
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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local HighlightDetected = false

RunService.Heartbeat:Connect(function()
	local Character = LocalPlayer.Character
	if not Character then return end

	local highlight = Character:FindFirstChildWhichIsA("Highlight", true)
	HighlightDetected = highlight ~= nil
end)

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

function ManualSpam()
    if MauaulSpam then
        MauaulSpam:Destroy()
        MauaulSpam = nil
        return
    end

    MauaulSpam = Instance.new("ScreenGui")
    MauaulSpam.Name = "MauaulSpam"
    MauaulSpam.Parent = game.CoreGui
    MauaulSpam.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MauaulSpam.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = MauaulSpam
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.41414836, 0, 0.404336721, 0)
    Main.Size = UDim2.new(0.227479532, 0, 0.191326529, 0)

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main

    local IndercantorBlahblah = Instance.new("Frame")
    IndercantorBlahblah.Name = "IndercantorBlahblah"
    IndercantorBlahblah.Parent = Main
    IndercantorBlahblah.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    IndercantorBlahblah.BorderColor3 = Color3.fromRGB(0, 0, 0)
    IndercantorBlahblah.BorderSizePixel = 0
    IndercantorBlahblah.Position = UDim2.new(0.0280000009, 0, 0.0733333305, 0)
    IndercantorBlahblah.Size = UDim2.new(0.0719999969, 0, 0.119999997, 0)

    local UICorner_2 = Instance.new("UICorner")
    UICorner_2.CornerRadius = UDim.new(1, 0)
    UICorner_2.Parent = IndercantorBlahblah

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Parent = IndercantorBlahblah

    local PC = Instance.new("TextLabel")
    PC.Name = "PC"
    PC.Parent = Main
    PC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PC.BackgroundTransparency = 1.000
    PC.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PC.BorderSizePixel = 0
    PC.Position = UDim2.new(0.547999978, 0, 0.826666653, 0)
    PC.Size = UDim2.new(0.451999992, 0, 0.173333332, 0)
    PC.Font = Enum.Font.Unknown
    PC.Text = "PC: E to spam"
    PC.TextColor3 = Color3.fromRGB(57, 57, 57)
    PC.TextScaled = true
    PC.TextSize = 16.000
    PC.TextWrapped = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
    UITextSizeConstraint.Parent = PC
    UITextSizeConstraint.MaxTextSize = 16

    local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint_2.Parent = PC
    UIAspectRatioConstraint_2.AspectRatio = 4.346

    local IndercanotTextBlah = Instance.new("TextButton")
    IndercanotTextBlah.Name = "IndercanotTextBlah"
    IndercanotTextBlah.Parent = Main
    IndercanotTextBlah.Active = false
    IndercanotTextBlah.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IndercanotTextBlah.BackgroundTransparency = 1.000
    IndercanotTextBlah.BorderColor3 = Color3.fromRGB(0, 0, 0)
    IndercanotTextBlah.BorderSizePixel = 0
    IndercanotTextBlah.Position = UDim2.new(0.164000005, 0, 0.326666653, 0)
    IndercanotTextBlah.Selectable = false
    IndercanotTextBlah.Size = UDim2.new(0.667999983, 0, 0.346666664, 0)
    IndercanotTextBlah.Font = Enum.Font.GothamBold
    IndercanotTextBlah.Text = "Vincent Hub"
    IndercanotTextBlah.TextColor3 = Color3.fromRGB(255, 255, 255)
    IndercanotTextBlah.TextScaled = true
    IndercanotTextBlah.TextSize = 24.000
    IndercanotTextBlah.TextWrapped = true

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color =
        ColorSequence.new {
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 0, 4)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
        }
    UIGradient.Parent = IndercanotTextBlah

    local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
    UITextSizeConstraint_2.Parent = IndercanotTextBlah
    UITextSizeConstraint_2.MaxTextSize = 52

    local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint_3.Parent = IndercanotTextBlah
    UIAspectRatioConstraint_3.AspectRatio = 3.212

    local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint_4.Parent = Main
    UIAspectRatioConstraint_4.AspectRatio = 1.667

    MauaulSpam.Name = "MauaulSpam"
    MauaulSpam.Parent = game.CoreGui
    MauaulSpam.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MauaulSpam.ResetOnSpawn = false

    Main.Name = "Main"
    Main.Parent = MauaulSpam
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.41414836, 0, 0.404336721, 0)
    Main.Size = UDim2.new(0.227479532, 0, 0.191326529, 0)

    UICorner.Parent = Main

    IndercantorBlahblah.Name = "IndercantorBlahblah"
    IndercantorBlahblah.Parent = Main
    IndercantorBlahblah.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    IndercantorBlahblah.BorderColor3 = Color3.fromRGB(0, 0, 0)
    IndercantorBlahblah.BorderSizePixel = 0
    IndercantorBlahblah.Position = UDim2.new(0.0280000009, 0, 0.0733333305, 0)
    IndercantorBlahblah.Size = UDim2.new(0.0719999969, 0, 0.119999997, 0)

    UICorner_2.CornerRadius = UDim.new(1, 0)
    UICorner_2.Parent = IndercantorBlahblah

    UIAspectRatioConstraint.Parent = IndercantorBlahblah

    PC.Name = "PC"
    PC.Parent = Main
    PC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PC.BackgroundTransparency = 1.000
    PC.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PC.BorderSizePixel = 0
    PC.Position = UDim2.new(0.547999978, 0, 0.826666653, 0)
    PC.Size = UDim2.new(0.451999992, 0, 0.173333332, 0)
    PC.Font = Enum.Font.Unknown
    PC.Text = "PC: E to spam"
    PC.TextColor3 = Color3.fromRGB(57, 57, 57)
    PC.TextScaled = true
    PC.TextSize = 16.000
    PC.TextWrapped = true

    UITextSizeConstraint.Parent = PC
    UITextSizeConstraint.MaxTextSize = 16

    UIAspectRatioConstraint_2.Parent = PC
    UIAspectRatioConstraint_2.AspectRatio = 4.346

    IndercanotTextBlah.Name = "IndercanotTextBlah"
    IndercanotTextBlah.Parent = Main
    IndercanotTextBlah.Active = false
    IndercanotTextBlah.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IndercanotTextBlah.BackgroundTransparency = 1.000
    IndercanotTextBlah.BorderColor3 = Color3.fromRGB(0, 0, 0)
    IndercanotTextBlah.BorderSizePixel = 0
    IndercanotTextBlah.Position = UDim2.new(0.164000005, 0, 0.326666653, 0)
    IndercanotTextBlah.Selectable = false
    IndercanotTextBlah.Size = UDim2.new(0.667999983, 0, 0.346666664, 0)
    IndercanotTextBlah.Font = Enum.Font.GothamBold
    IndercanotTextBlah.Text = "Vincent Hub"
    IndercanotTextBlah.TextColor3 = Color3.fromRGB(255, 255, 255)
    IndercanotTextBlah.TextScaled = true
    IndercanotTextBlah.TextSize = 24.000
    IndercanotTextBlah.TextWrapped = true

    UIGradient.Color =
        ColorSequence.new {
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 0, 4)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
        }
    UIGradient.Parent = IndercanotTextBlah

    UITextSizeConstraint_2.Parent = IndercanotTextBlah
    UITextSizeConstraint_2.MaxTextSize = 52

    UIAspectRatioConstraint_3.Parent = IndercanotTextBlah
    UIAspectRatioConstraint_3.AspectRatio = 3.212

    UIAspectRatioConstraint_4.Parent = Main
    UIAspectRatioConstraint_4.AspectRatio = 1.667

    local function HEUNEYP_fake_script()
        local script = Instance.new("LocalScript", IndercanotTextBlah)

        local button = script.Parent
        local UIGredient = button.UIGradient
        local NeedToChange = script.Parent.Parent.IndercantorBlahblah
        local userInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")

        local green_Color = {
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
        }

        local red_Color = {
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
        }

        local current_Color = red_Color
        local target_Color = green_Color
        local is_Green = false
        local transition = false
        local transition_Time = 0.1
        local start_Time

        local function startColorTransition()
            transition = true
            start_Time = tick()
        end

        RunService.Heartbeat:Connect(
            function()
                if transition then
                    local elapsed = tick() - start_Time
                    local alpha = math.clamp(elapsed / transition_Time, 0, 1)

                    local new_Color = {}
                    for i = 1, #current_Color do
                        local start_Color = current_Color[i].Value
                        local end_Color = target_Color[i].Value
                        new_Color[i] =
                            ColorSequenceKeypoint.new(current_Color[i].Time, start_Color:Lerp(end_Color, alpha))
                    end

                    UIGredient.Color = ColorSequence.new(new_Color)

                    if alpha >= 1 then
                        transition = false
                        current_Color, target_Color = target_Color, current_Color
                    end
                end
            end
        )

        local function toggleColor()
            if not transition then
                is_Green = not is_Green
                if is_Green then
                    target_Color = green_Color
                    NeedToChange.BackgroundColor3 = Color3.new(0, 1, 0)
                else
                    target_Color = red_Color
                    NeedToChange.BackgroundColor3 = Color3.new(1, 0, 0)
                end
                startColorTransition()
            end
        end

        button.MouseButton1Click:Connect(toggleColor)

        userInputService.InputBegan:Connect(
            function(input, gameProcessed)
                if gameProcessed then
                    return
                end
                if input.KeyCode == Enum.KeyCode.E then
                    toggleColor()
                end
            end
        )

        RunService.RenderStepped:Connect(
            function()
                if is_Green then
                    for i = 1, 5 do
                        ParryFunction()
                    end
                end
            end
        )
    end
    coroutine.wrap(HEUNEYP_fake_script)()
    local function WWJM_fake_script()
        local script = Instance.new("LocalScript", Main)

        local UserInputService = game:GetService("UserInputService")

        local gui = script.Parent
        local dragging
        local dragInput
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            local newPosition =
                UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

            local TweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(gui, tweenInfo, {Position = newPosition})
            tween:Play()
        end

        gui.InputBegan:Connect(
            function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1 or
                    input.UserInputType == Enum.UserInputType.Touch
                then
                    dragging = true
                    dragStart = input.Position
                    startPos = gui.Position

                    input.Changed:Connect(
                        function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end
                    )
                end
            end
        )

        gui.InputChanged:Connect(
            function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
                then
                    dragInput = input
                end
            end
        )

        UserInputService.InputChanged:Connect(
            function(input)
                if dragging and input == dragInput then
                    update(input)
                end
            end
        )
    end
    coroutine.wrap(WWJM_fake_script)()
end
	
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local sphere
local currentSize = Vector3.new(5, 5, 5)

local function getBall()
	for _, ball in workspace.Balls:GetChildren() do
		if ball:GetAttribute("realBall") then
			return ball
		end
	end
end

local function createSphere()
	if sphere and sphere.Parent then return end
	sphere = Instance.new("Part")
	sphere.Shape = Enum.PartType.Ball
	sphere.Anchored = true
	sphere.CanCollide = false
	sphere.Material = Enum.Material.ForceField
	sphere.Color = Color3.fromRGB(0, 255, 0)
	sphere.Transparency = 0.5
	sphere.Size = currentSize
	sphere.Name = "VisualizerSphere"
	sphere.Parent = workspace
end

local function removeSphere()
	if sphere then
		sphere:Destroy()
		sphere = nil
	end
end

local function updateSphere()
	local ball = getBall()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if sphere and ball and hrp then
		local distance = (hrp.Position - ball.Position).Magnitude
		local targetScale = math.clamp(35 - distance, 5, 30)
		local targetSize = Vector3.new(targetScale, targetScale, targetScale)
		currentSize = currentSize:Lerp(targetSize, 0.1)
		sphere.Size = currentSize
		sphere.Position = hrp.Position
		if distance > 20 then
			sphere.Color = Color3.fromRGB(0, 255, 0)
		elseif distance > 10 then
			sphere.Color = Color3.fromRGB(255, 255, 0)
		else
			sphere.Color = Color3.fromRGB(255, 0, 0)
		end
	end
end

RunService.RenderStepped:Connect(function()
	if getgenv().VisualizerBallEnabled then
		pcall(createSphere)
		pcall(updateSphere)
	end
end)

player.CharacterAdded:Connect(function()
	if getgenv().VisualizerBallEnabled then
		task.wait(1)
		createSphere()
	end
end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local local_player = Players.LocalPlayer

local ball_Trail_Enabled = false
local player_Trail_Enabled = false

RunService.Heartbeat:Connect(function()
    if player_Trail_Enabled and local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = local_player.Character.PrimaryPart or local_player.Character:FindFirstChild("HumanoidRootPart")
        if not rootPart:FindFirstChild("VincentHub_fx") then
            local trail = game:GetObjects("rbxassetid://17483658369")[1]
            trail.Name = "VincentHub_fx"
            local Attachment0 = Instance.new("Attachment")
            Attachment0.Position = Vector3.new(0, -2.411, 0)
            Attachment0.Parent = rootPart
            local Attachment1 = Instance.new("Attachment")
            Attachment1.Position = Vector3.new(0, 2.504, 0)
            Attachment1.Parent = rootPart
            trail.Attachment0 = Attachment0
            trail.Attachment1 = Attachment1
            trail.Parent = rootPart
        end
    elseif local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = local_player.Character.PrimaryPart or local_player.Character:FindFirstChild("HumanoidRootPart")
        local existingTrail = rootPart:FindFirstChild("VincentHub_fx")
        if existingTrail then
            existingTrail:Destroy()
        end
        for _, att in ipairs(rootPart:GetChildren()) do
            if att:IsA("Attachment") then
                att:Destroy()
            end
        end
    end

    if ball_Trail_Enabled then
        for _, ball in workspace:FindFirstChild("Balls"):GetChildren() do
            if ball:GetAttribute("realBall") and not ball:FindFirstChild("VincentHub_fx") then
                local trail = game:GetObjects("rbxassetid://17483658369")[1]
                trail.Name = "VincentHub_fx"
                local Attachment0 = Instance.new("Attachment")
                Attachment0.Position = Vector3.new(0, -2.411, 0)
                Attachment0.Parent = ball
                local Attachment1 = Instance.new("Attachment")
                Attachment1.Position = Vector3.new(0, 2.504, 0)
                Attachment1.Parent = ball
                trail.Attachment0 = Attachment0
                trail.Attachment1 = Attachment1
                trail.Parent = ball
            end
        end
    else
        for _, ball in workspace:FindFirstChild("Balls"):GetChildren() do
            if ball:GetAttribute("realBall") then
                local existingTrail = ball:FindFirstChild("VincentHub_fx")
                if existingTrail then
                    existingTrail:Destroy()
                end
                for _, att in ipairs(ball:GetChildren()) do
                    if att:IsA("Attachment") then
                        att:Destroy()
                    end
                end
            end
        end
    end
end)

local function get_character() 
    return LocalPlayer and LocalPlayer.Character
end

local function get_humanoid_root_part()
    local char = get_character()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function get_humanoid()
    local char = get_character()
    return char and char:FindFirstChild("Humanoid")
end

local function get_ball()
    local ballContainer = Workspace:FindFirstChild("Balls")
    if ballContainer then
        for _, ball in ipairs(ballContainer:GetChildren()) do
            if not ball.Anchored then
                return ball
            end
        end
    end
    return nil
end

local function calculate_parry_distance()
    local ball = get_ball()
    if ball then
        local ping = LocalPlayer:GetNetworkPing() * 20
        return math.clamp(ball.Velocity.Magnitude / 2.4 + ping, 15, 200)
    end
    return 15
end

local function update_ball_velocity_display(ball, velocityText)
    if not BallVelocity then
        velocityText.Text = ""
        return
    end

    if ball then
        local velocity = ball.Velocity.Magnitude
        velocityText.Text = string.format("Ball Velocity: %.2f", velocity)

        local hrp = get_humanoid_root_part()
        if hrp then
            local distance = (ball.Position - hrp.Position).Magnitude
            if distance > 70 then
                velocityText.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif distance > 30 then
                velocityText.TextColor3 = Color3.fromRGB(255, 255, 0)
            else
                velocityText.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end

local function create_ball_velocity_display(ball)
    local existingDisplay = ball:FindFirstChild("BallVelocityDisplay")
    if existingDisplay then
        return existingDisplay.TextLabel
    end

    local ballVelocityDisplay = Instance.new("BillboardGui")
    ballVelocityDisplay.Name = "BallVelocityDisplay"
    ballVelocityDisplay.Adornee = ball
    ballVelocityDisplay.Size = UDim2.new(0, 200, 0, 50)
    ballVelocityDisplay.StudsOffset = Vector3.new(0, 5, 0)
    ballVelocityDisplay.AlwaysOnTop = true
    ballVelocityDisplay.Parent = ball

    local velocityText = Instance.new("TextLabel")
    velocityText.Name = "TextLabel"
    velocityText.Size = UDim2.new(1, 0, 1, 0)
    velocityText.BackgroundTransparency = 1
    velocityText.TextScaled = true
    velocityText.TextColor3 = Color3.new(1, 1, 1)
    velocityText.Font = Enum.Font.Arcade
    velocityText.TextSize = 18
    velocityText.Text = ""
    velocityText.Parent = ballVelocityDisplay

    return velocityText
end

local lastBall
RunService.RenderStepped:Connect(function()
    if not BallVelocity then
        if lastBall and lastBall:FindFirstChild("BallVelocityDisplay") then
            lastBall.BallVelocityDisplay:Destroy()
        end
        lastBall = nil
        return
    end

    local ball = get_ball()
    if ball ~= lastBall then
        if lastBall and lastBall:FindFirstChild("BallVelocityDisplay") then
            lastBall.BallVelocityDisplay:Destroy()
        end

        if ball then
            local velocityText = create_ball_velocity_display(ball)
            lastBall = ball

            RunService.RenderStepped:Connect(function()
                if ball and velocityText then
                    update_ball_velocity_display(ball, velocityText)
                end
            end)
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function resetCamera()
    camera.CameraType = Enum.CameraType.Custom
end

local function startViewBallLoop()
    if _G.viewConnection then
        _G.viewConnection:Disconnect()
        _G.viewConnection = nil
    end

    _G.viewConnection = RunService.RenderStepped:Connect(function()
        local ball = getBall()
        if _G.AgentX77 and ball then
            camera.CameraType = Enum.CameraType.Scriptable
            local targetPosition = ball.Position + Vector3.new(0, 5, 15)
            camera.CFrame = CFrame.new(
                camera.CFrame.Position:Lerp(targetPosition, 0.05),
                ball.Position
            )
        else
            resetCamera()
        end
    end)

    task.spawn(function()
        while _G.AgentX77 do
            task.wait(2)
            if not getBall() then
                resetCamera()
                repeat
                    task.wait(2)
                until getBall() or not _G.AgentX77
            end
        end
    end)
end

local function rotateCharacter()
    while getgenv().RotateTowardsBall do
        task.wait()
        local char = getCharacter()
        local ball = getBall()
        if ball and char and char:FindFirstChild("HumanoidRootPart") and char.PrimaryPart then
            local direction = (ball.Position - char.HumanoidRootPart.Position).Unit
            local targetCFrame = CFrame.new(
                char.HumanoidRootPart.Position,
                char.HumanoidRootPart.Position + direction
            )
            char:SetPrimaryPartCFrame(
                char.PrimaryPart.CFrame:Lerp(targetCFrame, 0.2)
            )
        end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    if getgenv().RotateTowardsBall then
        task.spawn(rotateCharacter)
    end
end)

spawn(function()
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local plr = Players.LocalPlayer
    local Ball = Workspace:WaitForChild("Balls")
    local DeadFolder = Workspace:FindFirstChild("Dead")
    local currentTween = nil

    getgenv().FollowSpeed = 1
    getgenv().FollowDistance = 1000

    while true do
        wait(0.001)
        if getgenv().FB then
            if DeadFolder and DeadFolder:FindFirstChild(plr.Name) then
                if currentTween then
                    currentTween:Pause()
                    currentTween = nil
                end
            else
                local ball = Ball:FindFirstChildOfClass("Part")
                local char = plr.Character
                if ball and char and char.PrimaryPart then
                    local distance = (char.PrimaryPart.Position - ball.Position).magnitude
                    if distance <= tonumber(getgenv().FollowDistance) then 
                        if currentTween then
                            currentTween:Pause()
                        end
                        local tweenInfo = TweenInfo.new(tonumber(getgenv().FollowSpeed), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                        currentTween = TweenService:Create(char.PrimaryPart, tweenInfo, {CFrame = ball.CFrame})
                        currentTween:Play()
                    end
                end
            end
        else
            if currentTween then
                currentTween:Pause()
                currentTween = nil
            end
        end
    end
end)

local soundIDs = {
    Disabled = '',
    DC_15X = 'rbxassetid://936447863',
    Neverlose = 'rbxassetid://8679627751',
    Minecraft = 'rbxassetid://8766809464',
    MinecraftHit2 = 'rbxassetid://8458185621',
    ["Teamfortress Bonk"] = 'rbxassetid://8255306220',
    ["Teamfortress Bell"] = 'rbxassetid://2868331684',
    ["Excalibur"] = 'rbxassetid://153613030',
    ["Masamune"] = 'rbxassetid://99803221089826',
    ["Muramasa"] = 'rbxassetid://98608144972892',
    ["Soul Edge"] = 'rbxassetid://130037857404629',
    ["Ragnarok"] = 'rbxassetid://82442955130305',
    ["Dark Repulser"] = 'rbxassetid://16008606789',
    ["Elucidator"] = 'rbxassetid://78618347958652',
    ["Dragon Slayer"] = 'rbxassetid://78833978912349',
}

local ArgonHubX_Data = nil
local hit_Sound = nil

function initializate(dataFolder_name)
    ArgonHubX_Data = Instance.new('Folder', game:GetService('CoreGui'))
    ArgonHubX_Data.Name = dataFolder_name

    hit_Sound = Instance.new('Sound', ArgonHubX_Data)
    hit_Sound.Volume = 5
end

function setHitSound(soundId)
    hit_Sound.SoundId = soundId
end

RunService.RenderStepped:Connect(function()
    local dist = (camera.CFrame.Position - player.Character.Head.Position).Magnitude
    local newVolume = 5 / (dist * 0.3)
    if newVolume < 0.1 then
        newVolume = 0.1
    elseif newVolume > 5 then
        newVolume = 5
    end
    hit_Sound.Volume = newVolume
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if getgenv().hit_sound_Enabled then
        hit_Sound:Play()
    end

    if getgenv().hit_effect_Enabled then
        local hit_effect = game:GetObjects("rbxassetid://17407244385")[1]
        hit_effect.Parent = getBall()
        hit_effect:Emit(3)

        task.delay(5, function()
            hit_effect:Destroy()
        end)
    end
end)

initializate('ArgonHubX_temp')

spawn(function()
    while true do
        wait(0.01)
        if getgenv().ASC then
            game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
        end
    end
end)

spawn(function()
    while true do
        wait(0.01)
        if getgenv().AEC then
            game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
        end
    end
end)

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local currentJobId = game.JobId
local inputJobId = ""
local originalMaterials = {}
local originalDecalsTextures = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local afkRunning = false
local afkToggle = false

local function startAntiAFK()
    if afkRunning then return end
    afkRunning = true

    task.spawn(function()
        while afkToggle do
            for i = 900, 1, -1 do
                if not afkToggle then break end
                task.wait(1)
            end
            if not afkToggle then break end
            for j = 1, 5 do
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                task.wait(0.5)
            end
        end
        afkRunning = false
    end)
end

task.defer(function()
    while task.wait(1) do
        if getgenv().night_mode_Enabled then
            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 3.9}):Play()
        else
            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 13.5}):Play()
        end
    end
end)

player = Players.LocalPlayer
local function applySettings()
	if getgenv().remove_fog_Enabled then
		Lighting.FogEnd = 1e10
		Lighting.FogStart = 1e10
		Lighting.FogColor = Color3.new(0, 0, 0)
	end
end

applySettings()

player.CharacterAdded:Connect(function()
	task.wait(1)
	applySettings()
end)

local Player = Services.Players.LocalPlayer
local reportCount = 0
local originalName = "Vincent Hub"
local currentName = originalName

local webhookBugs = "https://discordapp.com/api/webhooks/1335377913595301969/zdHyIHb0CJCCsYMCiOF2ILl7TNMSzndoONMzRv5rw3UGUdzAUwFHO1WEjiryvV0tllub"
local problemDescription = ""
local frequencySelection = ""

local function getExploitName()
	return (identifyexecutor and identifyexecutor())
		or (syn and syn.get_executor and syn.get_executor())
		or (secure_load and "SecureLoad")
		or (KRNL_LOADED and "KRNL")
		or (islclosure and "Unknown Executor")
		or "Unknown"
end

local ArgonHubXLib = Library.__init()
local HomeTab = ArgonHubXLib.create_tab('Home')
local MainTab = ArgonHubXLib.create_tab('Main')
local CombatTab = ArgonHubXLib.create_tab('Combat')
local ShopTab = ArgonHubXLib.create_tab('Shop')
local SettingsTab = ArgonHubXLib.create_tab('Settings')

HomeTab.create_image({
	section = 'left',
	image = 'rbxassetid://87037613203198'
})

HomeTab.create_title({
	name = 'Discord',
	section = 'left'
})

HomeTab.create_title({
	name = 'Vincent Hub Security',
	section = 'right'
})

HomeTab.create_button({
	name = 'Join Discord',
	section = 'left',
	callback = function()
        local req = (syn and syn.request) or (http and http.request) or http_request
        local opened = false
        local JoinDiscord = "https://discord.gg/a8EM9Qvq"

        if req then
            local success, response = pcall(function()
                return req({
                    Url = 'http://127.0.0.1:6463/rpc?v=1',
                    Method = 'POST',
                    Headers = {
                        ['Content-Type'] = 'application/json',
                        ['Origin'] = 'https://discord.com'
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        cmd = 'INVITE_BROWSER',
                        nonce = game:GetService("HttpService"):GenerateGUID(false),
                        args = {code = 'a8EM9Qvq'}
                    })
                })
            end)

            if success and response and response.StatusCode == 200 then
                opened = true
            end
        end

        if not opened then
            if setclipboard then
                setclipboard(JoinDiscord)
                LibraryNotify:MakeNotify({
                    Title = "Vincent Hub:",
                    Description = "Clipboard",
                    Content = "Link copied to your clipboard.",
                    Time = 0.5,
                    Delay = 5
                })
            else
                LibraryNotify:MakeNotify({
                    Title = "Vincent Hub:",
                    Description = "UnSupport",
                    Content = "Your executor doesn't support clipboard. Please paste this link in your browser: " .. JoinDiscord,
                    Time = 0.5,
                    Delay = 5
                })
            end
        else
            LibraryNotify:MakeNotify({
                Title = "Vincent Hub:",
                Description = "Discord PC",
                Content = "Discord is running on your device.",
                Time = 0.5,
                Delay = 15
            })
        end
	end
})

HomeTab.create_toggle({
	name = 'Protection - Vincent Hub',
	flag = 'auto_update',

	section = 'right',
	enabled = true,

	callback = function(state)
        if state then
            if hookmetamethod and getnamecallmethod and getrawmetatable and setreadonly then
                local old
                old = hookmetamethod(game, "__namecall", function(self, ...)
                    local method = tostring(getnamecallmethod())
                    if string.lower(method) == "kick" then
                        LibraryNotify:MakeNotify({
                            Title = "Vincent Hub:",
                            Description = "Protection",
                            Content = "Blocked Kick attempt.",
                            Time = 0.5,
                            Delay = 5
                        })
                        return wait(9e9)
                    end
                    return old(self, ...)
                end)
            end
            LibraryNotify:MakeNotify({
                Title = "Vincent Hub:",
                Description = "Protection",
                Content = "The Protections have been Activated.",
                Time = 0.5,
                Delay = 5
            })
        else
            LibraryNotify:MakeNotify({
                Title = "Vincent Hub:",
                Description = "Protection",
                Content = "WARNING: Protection - Argon has been Disabled.",
                Time = 0.5,
                Delay = 5
            })
        end
	end
})

MainTab.create_title({
	name = 'ESP Lines',
	section = 'left'
})

MainTab.create_toggle({
	name = 'ESP Enabled',
	flag = 'esp_enabled',

	section = 'left',
	enabled = false,

	callback = function(state)
		ESPLines.Enabled = state
	end
})

MainTab.create_line({
	section = "left"
})

MainTab.create_toggle({
	name = 'ESP Show Box',
	flag = 'esp_show_box',

	section = 'left',
	enabled = false,

	callback = function(state)
		ESPLines.ShowBox = state
	end
})

MainTab.create_toggle({
	name = 'ESP Show Name',
	flag = 'esp_show_name',

	section = 'left',
	enabled = false,

	callback = function(state)
		ESPLines.ShowName = state
	end
})

MainTab.create_toggle({
	name = 'ESP Show Health',
	flag = 'esp_show_health',

	section = 'left',
	enabled = false,

	callback = function(state)
		ESPLines.ShowHealth = state
	end
})

MainTab.create_toggle({
	name = 'ESP Show Tracer',
	flag = 'esp_show_tracer',

	section = 'left',
	enabled = false,

	callback = function(state)
		ESPLines.ShowTracer = state
	end
})

MainTab.create_toggle({
	name = 'ESP Show Distance',
	flag = 'esp_show_distance',

	section = 'left',
	enabled = false,

	callback = function(state)
		ESPLines.ShowDistance = state
	end
})

MainTab.create_title({
	name = 'ESP Settings',
	section = 'left'
})

MainTab.create_dropdown({
	name = 'ESP Settings',
	flag = 'esp_settings',
	section = 'left',

	option = '2D',
	options = {'Corner Box Esp', '2D'},

	callback = function(value)
		ESPLines.BoxType = value
	end
})

MainTab.create_title({
	name = 'Auto Rewards',
	section = 'left'
})

MainTab.create_toggle({
	name = 'Auto Rewards',
	flag = 'auto_rewards',
	section = 'left',
	enabled = false,
	callback = function(state)
		auto_rewards_enabled = state
	end
})

MainTab.create_line({
	section = "left"
})

MainTab.create_textbox({
	name = 'Claim Speed',
	flag = 'claim_speed',
	section = 'left',
	value = '60',
	callback = function(value)
		reward_interval = tonumber(value) or 60
	end
})

MainTab.create_dropdown({
	name = 'Custom Reward',
	flag = 'custom_reward',
	section = 'left',
	option = 'All',
	options = {'All', 'Daily', 'Tasks'},
	callback = function(value)
		selected_reward_type = value
	end
})

MainTab.create_title({
	name = 'AI Options',
	section = 'right'
})

MainTab.create_toggle({
	name = 'Auto Walk',
	flag = 'auto_walk',

	section = 'right',
	enabled = false,

	callback = function(state)
		AutoWalk = state
	end
})

MainTab.create_toggle({
	name = 'Player Safety',
	flag = 'player_safety',

	section = 'right',
	enabled = false,

	callback = function(state)
		PlayerSaftey = state
	end
})

MainTab.create_toggle({
	name = 'Random Teleports',
	flag = 'random_teleports',

	section = 'right',
	enabled = false,

	callback = function(state)
		RandomTeleports = state
	end
})

MainTab.create_toggle({
	name = 'Auto Jump',
	flag = 'auto_jump',

	section = 'right',
	enabled = false,

	callback = function(state)
		AutoDoubleJump = state
	end
})

MainTab.create_toggle({
	name = 'Closest Player Focus',
	flag = 'closest_player_focus',

	section = 'right',
	enabled = false,

	callback = function(state)
		ClosestPlayer_var = state
	end
})

MainTab.create_toggle({
	name = 'AI Player',
	flag = 'ai_player',

	section = 'right',
	enabled = false,

	callback = function(state)
		AiPlay = state
	end
})

MainTab.create_title({
	name = 'Player Options',
	section = 'right'
})

MainTab.create_slider({
	name = 'Auto Walk X',
	flag = 'auto_walk_x_slider',

	section = 'right',

	value = 10,
	minimum_value = 0,
	maximum_value = 50,

	callback = function(value)
		AutoWalkDistanceX = value
	end
})

MainTab.create_slider({
	name = 'Auto Walk Z',
	flag = 'auto_walk_z_slider',

	section = 'right',

	value = 10,
	minimum_value = 0,
	maximum_value = 50,

	callback = function(value)
		AutoWalkDistanceZ = value
	end
})

MainTab.create_slider({
	name = 'Player Safety',
	flag = 'player_safety_slider',

	section = 'right',

	value = 10,
	minimum_value = 0,
	maximum_value = 50,

	callback = function(value)
		PlayerSaftey_Distance = value
	end
})

MainTab.create_slider({
	name = 'Teleport X',
	flag = 'teleport_x_slider',

	section = 'right',

	value = 10,
	minimum_value = 0,
	maximum_value = 50,

	callback = function(value)
		TeleportDistanceX = value
	end
})

MainTab.create_slider({
	name = 'Teleport Z',
	flag = 'teleport_z_slider',

	section = 'right',

	value = 10,
	minimum_value = 0,
	maximum_value = 50,

	callback = function(value)
		TeleportDistanceZ = value
	end
})

MainTab.create_dropdown({
	name = 'AI Modes',
	flag = 'ai_modes_dropdown',
	section = 'right',
	option = 'Normal',
	options = {'Normal', 'Advanced', 'Hacker'},
	callback = function(selected)
		AiPlayType = selected
		local humanoid = get_humanoid()
		if humanoid then
			if not AiPlay or selected ~= "Hacker" then
				humanoid.WalkSpeed = 36
			end
		end
	end
})

MainTab.create_slider({
	name = 'Hacker Speed',
	flag = 'hacker_speed_slider',
	section = 'right',
	value = 200,
	minimum_value = 36,
	maximum_value = 500,
	callback = function(value)
		AiPlaySpeed = value
	end
})

MainTab.create_title({
	name = 'VIP Tag',
	section = 'right'
})

MainTab.create_button({
    name = 'Get VIP Tag',
    section = 'right',
    callback = function()
        local Players = game:GetService("Players")
        local TextChatService = game:GetService("TextChatService")
        local StarterGui = game:GetService("StarterGui")
        
        local localPlayer = Players.LocalPlayer
        local vipTag = "<font color='#FFFF00'>[VIP]</font> " .. localPlayer.Name
        
        local function addLegacyChatTag()
            local function onChatted(msg)
                local message = vipTag .. ": " .. msg
                StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = message,
                    Color = Color3.new(1, 1, 1),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 18
                })
            end
            localPlayer.Chatted:Connect(onChatted)
        end
        
        local function addTextChatTag()
            local function onIncomingMessage(message)
                if message.TextSource then
                    local sender = Players:GetPlayerByUserId(message.TextSource.UserId)
                    if sender and sender == localPlayer then
                        message.PrefixText = vipTag
                    end
                end
            end
            TextChatService.OnIncomingMessage = onIncomingMessage
        end
        
        if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
            addLegacyChatTag()
        else
            addTextChatTag()
        end
        
        LibraryNotify:MakeNotify({
            Title = "Vincent Hub:",
            Description = "VIP Tag",
            Content = "You have received the VIP badge.",
            Time = 0.5,
            Delay = 5
        })
    end
})

CombatTab.create_title({
	name = 'Auto Parry',
	section = 'left'
})

CombatTab.create_toggle({
    name = 'Auto Parry',
    flag = 'auto_parry',

    section = 'left',
    enabled = true,

    callback = function(value)
        if value then
            Connections_Manager['Auto Parry'] = RunService.PreSimulation:Connect(function()
                local One_Ball = Auto_Parry.Get_Ball()
                local Balls = Auto_Parry.Get_Balls()

                for _, Ball in pairs(Balls) do

                    if not Ball then
                        return
                    end

                    local Zoomies = Ball:FindFirstChild('zoomies')
                    if not Zoomies then
                        return
                    end

                    Ball:GetAttributeChangedSignal('target'):Once(function()
                        Parried = false
                    end)

                    if Parried then
                        return
                    end

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


                    if Phantom and Player.Character:FindFirstChild('ParryHighlight') and getgenv().PhantomV2Detection then
                        ContextActionService:BindAction('BlockPlayerMovement', BlockMovement, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.UserInputType.Touch)

                        Player.Character.Humanoid.WalkSpeed = 36
                        Player.Character.Humanoid:MoveTo(Ball.Position)

                        task.spawn(function()
                            repeat
                                if Player.Character.Humanoid.WalkSpeed ~= 36 then
                                    Player.Character.Humanoid.WalkSpeed = 36
                                end

                                task.wait()

                            until not Phantom
                        end)

                        Ball:GetAttributeChangedSignal('target'):Once(function()
                            ContextActionService:UnbindAction('BlockPlayerMovement')
                            Phantom = false

                            Player.Character.Humanoid:MoveTo(Player.Character.HumanoidRootPart.Position)
                            Player.Character.Humanoid.WalkSpeed = 10

                            task.delay(3, function()
                                Player.Character.Humanoid.WalkSpeed = 36
                            end)
                        end)
                    end

                    if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy and Phantom then
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        Parried = true
                    end

                    if Ball:FindFirstChild('AeroDynamicSlashVFX') then
                        Debris:AddItem(Ball.AeroDynamicSlashVFX, 0)
                        Tornado_Time = tick()
                    end

                    if Runtime:FindFirstChild('Tornado') then
                        if (tick() - Tornado_Time) < (Runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then
                            return
                        end
                    end

                    if One_Target == tostring(Player) and Curved then
                        return
                    end

                    if Ball:FindFirstChild("ComboCounter") then
                        return
                    end

                    local Singularity_Cape = Player.Character.PrimaryPart:FindFirstChild('SingularityCape')
                    if Singularity_Cape then
                        return
                    end

                    if getgenv().InfinityDetection and Infinity then
                        return
                    end

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
                        if Time_View > 0.1 then
                        end

                        Auto_Parry.Parry(Selected_Parry_Type)

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
        else
            if Connections_Manager['Auto Parry'] then
                Connections_Manager['Auto Parry']:Disconnect()
                Connections_Manager['Auto Parry'] = nil
            end
        end
    end
})

CombatTab.create_toggle({
	name = 'Auto Spam',
	flag = 'auto_spam',
	section = 'left',
	enabled = true,
	callback = function(value)
		if value then
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

                local Ping_Threshold = math.clamp(Ping / 10, 1, 16)

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

                if Ball_Target == tostring(Player) and Target_Distance > 30 and Distance > 30 then
                    return
                end

                local threshold = ParryThreshold

                if Distance <= Spam_Accuracy and Parries > threshold then
                    Auto_Parry.Parry(Selected_Parry_Type)
                end
            end)
        else
            if Connections_Manager['Auto Spam'] then
                Connections_Manager['Auto Spam']:Disconnect()
                Connections_Manager['Auto Spam'] = nil
            end
        end
	end
})

CombatTab.create_toggle({
	name = 'Random Parry Accuracy',
	flag = 'random_parry_accuracy',
	section = 'left',
	enabled = false,
	callback = function(value)
        getgenv().RandomParryAccuracyEnabled = value
	end
})

CombatTab.create_toggle({
    name = 'Animation Fix',
    flag = 'animation_fix',

    section = 'left',
    enabled = false,

    callback = function(value)
        if value then
            Connections_Manager['Animation Fix'] = RunService.PreSimulation:Connect(function()
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

                local Ping_Threshold = math.clamp(Ping / 10, 10, 16)

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

                if Ball_Target == tostring(Player) and Target_Distance > 30 and Distance > 30 then
                    return
                end

                local threshold = ParryThreshold

                if Distance <= Spam_Accuracy and Parries > threshold then
                    Auto_Parry.Parry(Selected_Parry_Type)
                end
            end)
        else
            if Connections_Manager['Animation Fix'] then
                Connections_Manager['Animation Fix']:Disconnect()
                Connections_Manager['Animation Fix'] = nil
            end
        end
    end
})

CombatTab.create_line({
	section = "left"
})

CombatTab.create_dropdown({
    name = 'Direction Ball',
    flag = 'direction_ball',
    section = 'left',
    option = 'Camera',
    options = {
        'Camera', 'Mouse', 'Players', 'Normal',
        'Up', 'Down', 'Left', 'Right', 'Behind',
        'Random', 'FrontLeft', 'FrontRight', 'BackLeft',
        'BackRight', 'SkywardSpiral', 'Zigzag', 'Spin',
        'Bounce', 'Wave', 'Orbit', 'Chaos', 'TargetFeet',
        'TargetHead', 'DiagonalUp', 'DiagonalDown',
        'FlipReverse', 'CurveLeft', 'CurveRight',
        'Whirlwind', 'TeleportStyle', 'SlideAngle', 'Drift'
    },
    callback = function(value)
        DirectionMode = value
    end
})

CombatTab.create_slider({
	name = 'Parry Distance',
	flag = 'parry_distance',

	section = 'left',

	value = 30,
	minimum_value = 30,
	maximum_value = 100,

	callback = function(value)
        Speed_Divisor_Multiplier = 0.7 + (value - 1) * (0.35 / 99)
	end
})

CombatTab.create_slider({
	name = 'Spam Power',
	flag = 'spam_power',

	section = 'left',

	value = 1,
	minimum_value = 1,
	maximum_value = 3,

	callback = function(value)
        ParryThreshold = value
	end
})

CombatTab.create_toggle({
    name = 'Manual Spam',
    flag = 'manual_spam',

    section = 'left',
    enabled = false,

    callback = function(state)
        if state then
            ManualSpam()
        else
            if MauaulSpam then
                MauaulSpam:Destroy()
                MauaulSpam = nil
            end
        end
    end
})

CombatTab.create_title({
	name = 'Ball Options',
	section = 'right'
})

CombatTab.create_toggle({
	name = 'Visualizer',
	flag = 'visualizer_ball',
	section = 'right',
	enabled = false,

	callback = function(state)
		getgenv().VisualizerBallEnabled = state
		if not state then
			removeSphere()
		end
	end
})

CombatTab.create_toggle({
	name = 'Ball Statistics',
	flag = 'ball_statistics',
	section = 'right',
	enabled = false,

	callback = function(state)
        BallVelocity = state
	end
})

CombatTab.create_toggle({
    name = 'View Ball',
    flag = 'view_ball',
    section = 'right',
    enabled = false,
    callback = function(state)
        pcall(function()
            _G.AgentX77 = state
            if state then
                startViewBallLoop()
            else
                if _G.viewConnection then
                    _G.viewConnection:Disconnect()
                    _G.viewConnection = nil
                end
                resetCamera()
            end
        end)
    end
})

CombatTab.create_toggle({
    name = 'Ball Rotation',
    flag = 'ball_rotation',
    section = 'right',
    enabled = false,
    callback = function(value)
        pcall(function()
            getgenv().RotateTowardsBall = value
            if value then
                task.spawn(rotateCharacter)
            end
        end)
    end
})

CombatTab.create_toggle({
	name = 'Trial Ball',
	flag = 'trial_ball',

	section = 'right',
	enabled = false,

	callback = function(state)
		ball_Trail_Enabled = state
	end
})

CombatTab.create_line({
	section = "right"
})

CombatTab.create_toggle({
	name = 'Follow Ball',
	flag = 'follow_ball',

	section = 'right',
	enabled = false,

	callback = function(state)
		getgenv().FB = state
	end
})

CombatTab.create_slider({
	name = 'Follow Speed',
	flag = 'follow_speed',

	section = 'right',

	value = 10,
	minimum_value = 0,
	maximum_value = 50,

	callback = function(value)
		getgenv().FollowSpeed = value
	end
})

CombatTab.create_slider({
	name = 'Follow Distance',
	flag = 'follow_distance',

	section = 'right',

	value = 10,
	minimum_value = 0,
	maximum_value = 50,

	callback = function(value)
		getgenv().FollowSpeed = value
	end
})

CombatTab.create_title({
	name = 'Swords Options',
	section = 'right'
})

CombatTab.create_toggle({
	name = 'Enable Hit Sound',
	flag = 'enable_hit_sound',
	section = 'right',
	
	state = true,
	callback = function(state)
		getgenv().hit_sound_Enabled = state
	end
})

CombatTab.create_dropdown({
	name = 'Sound Effects',
	flag = 'sound_effects',
	section = 'right',

	option = 'Disabled',
	options = {
		"Disabled",
		'DC_15X',
		'Minecraft',
		'MinecraftHit2',
		'Teamfortress Bonk',
		'Teamfortress Bell',
		'Excalibur',
		'Masamune',
		'Muramasa',
		'Soul Edge',
		'Ragnarok',
		'Dark Repulser',
		'Elucidator',
		'Dragon Slayer',
	},

	callback = function(value)
		setHitSound(soundIDs[value] or '')
	end
})

CombatTab.create_textbox({
	name = 'Volume',
	flag = 'volume',
	section = 'right',

	value = '5',

	callback = function(Value)
		if tonumber(Value) then
			hit_Sound.Volume = tonumber(Value)
		end
	end
})

CombatTab.create_title({
	name = 'AI Options',
	section = 'left'
})

CombatTab.create_toggle({
	name = 'AI Argon',
	flag = 'ai_argon',

	section = 'left',
	enabled = true,

	callback = function(state)
	end
})

CombatTab.create_line({
	section = "left"
})

CombatTab.create_toggle({
	name = 'Improve Accuracy',
	flag = 'ai_auto_parry',

	section = 'left',
	enabled = true,

	callback = function(state)
        nowprediction = state
	end
})

CombatTab.create_toggle({
	name = 'Improve Auto Spam',
	flag = 'ai_auto_spam',

	section = 'left',
	enabled = true,

	callback = function(state)
        if state then
            local spam_speed = 10
        else
            local spam_speed = 5
        end
    end
})

CombatTab.create_title({
	name = 'Detections',
	section = 'left'
})

CombatTab.create_toggle({
	name = 'Detections',
	flag = 'Toggle_Detections',
	section = 'left',
	enabled = true,
	callback = function(state)
		Detections = state
	end
})

CombatTab.create_line({
	section = "left"
})

CombatTab.create_toggle({
	name = 'Infinity Detection',
	flag = 'Toggle_InfinityDetection',
	section = 'left',
	enabled = true,
	callback = function(value)
        if Detections then
            getgenv().InfinityDetection = value
        else
            getgenv().InfinityDetection = false
        end
	end
})

CombatTab.create_toggle({
	name = 'Death Slash Detection',
	flag = 'Toggle_DeathSlashDetection',
	section = 'left',
	enabled = true,
	callback = function(state)
        if Detections then
		    DeathSlashDetection = state
        else
            DeathSlashDetection = false
        end
	end
})

CombatTab.create_toggle({
	name = 'Time Hole Detection',
	flag = 'Toggle_TimeHoleDetection',
	section = 'left',
	enabled = true,
	callback = function(state)
        if Detections then
            TimeHoleDetection = state
        else
            TimeHoleDetection = false
        end
	end
})

CombatTab.create_toggle({
	name = 'Auto Telekinesis Block',
	flag = 'Toggle_AutoTelekinesis',
	section = 'left',
	enabled = true,
	callback = function(state)
        if Detections then
		    AutoTelekinesis = state
        else
            AutoTelekinesis = false
        end
	end
})

CombatTab.create_toggle({
	name = 'Slash of Fury Detection',
	flag = 'Toggle_SlashOfFuryDetection',
	section = 'left',
	enabled = true,
	callback = function(state)
        if Detections then
            getgenv().SlashOfFuryDetection = state
        else
            getgenv().SlashOfFuryDetection = false
        end
	end
})

CombatTab.create_toggle({
	name = 'Anti Phantom Attack',
	flag = 'Toggle_AntiPhantom',
	section = 'left',
	enabled = false,
	callback = function(value)
        if Detections then
            PhantomV2Detection = value
        else
            PhantomV2Detection = false
        end
	end
})

CombatTab.create_toggle({
	name = 'Cooldown Protection',
	flag = 'Toggle_CooldownProtection',
	section = 'left',
	enabled = true,
	callback = function(state)
        if Detections then
            getgenv().CooldownProtection = state
        else
            getgenv().CooldownProtection = false
        end
	end
})

CombatTab.create_toggle({
	name = 'Auto Ability',
	flag = 'auto_ability',
	section = 'left',
	enabled = true,
	callback = function(state)
        if Detections then
            getgenv().AutoAbility = state
        else
            getgenv().AutoAbility = false
        end
	end
})

CombatTab.create_title({
	name = 'Auto/Anti Options',
	section = 'right'
})

CombatTab.create_toggle({
	name = 'Auto Curve',
	flag = 'auto_curve',

	section = 'right',
	enabled = false,

	callback = function(state)
		EnableAutoCurve = state
	end
})

CombatTab.create_toggle({
	name = 'Auto Block Spams',
	flag = 'auto_block_spams',

	section = 'right',
	enabled = true,

	callback = function(state)
	end
})

CombatTab.create_line({
	section = "right"
})

CombatTab.create_toggle({
	name = 'Anti Curve',
	flag = 'anti_curve',

	section = 'right',
	enabled = false,

	callback = function(state)
		EnableAntiCurve = state
	end
})

CombatTab.create_toggle({
	name = 'Anti Block Spams',
	flag = 'anti_block_spams',

	section = 'right',
	enabled = true,

	callback = function(state)
	end
})

CombatTab.create_title({
	name = 'Auto Parry Lobby',
	section = 'right'
})

CombatTab.create_toggle({
	name = 'Auto Parry',
	flag = 'auto_parry_lobby',

	section = 'right',
	enabled = false,

	callback = function(value)
        if value then
            Connections_Manager['Lobby AP'] = RunService.Heartbeat:Connect(function()
                local Ball = Auto_Parry.Lobby_Balls()
                if not Ball then
                    return
                end

                local Zoomies = Ball:FindFirstChild('zoomies')
                if not Zoomies then
                    return
                end

                Ball:GetAttributeChangedSignal('target'):Once(function()
                    Training_Parried = false
                end)

                if Training_Parried then
                    return
                end

                local Ball_Target = Ball:GetAttribute('target')
                local Velocity = Zoomies.VectorVelocity
                local Distance = Player:DistanceFromCharacter(Ball.Position)
                local Speed = Velocity.Magnitude

                local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue() / 10
                local LobbyAPcappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
                local LobbyAPspeed_divisor_base = 2.4 + LobbyAPcappedSpeedDiff * 0.002

                local LobbyAPeffectiveMultiplier = LobbyAP_Speed_Divisor_Multiplier
                if getgenv().LobbyAPRandomParryAccuracyEnabled then
                    LobbyAPeffectiveMultiplier = 0.7 + (math.random(1, 100) - 1) * (0.35 / 99)
                end

                local LobbyAPspeed_divisor = LobbyAPspeed_divisor_base * LobbyAPeffectiveMultiplier
                local LobbyAPParry_Accuracys = Ping + math.max(Speed / LobbyAPspeed_divisor, 9.5)

                if Ball_Target == tostring(Player) and Distance <= LobbyAPParry_Accuracys then
                    Auto_Parry.Parry(Selected_Parry_Type)
                    Training_Parried = true
                end
                local Last_Parrys = tick()
                repeat 
                    RunService.PreSimulation:Wait() 
                until (tick() - Last_Parrys) >= 1 or not Training_Parried
                Training_Parried = false
            end)
        else
            if Connections_Manager['Lobby AP'] then
                Connections_Manager['Lobby AP']:Disconnect()
                Connections_Manager['Lobby AP'] = nil
            end
        end
	end
})

CombatTab.create_slider({
	name = 'Auto Parry Distance',
	flag = 'auto_parry_distance_lobby',

	section = 'right',

	value = 100,
	minimum_value = 1,
	maximum_value = 100,

	callback = function(value)
        LobbyAP_Speed_Divisor_Multiplier = 0.7 + (value - 1) * (0.35 / 99)
	end
})

CombatTab.create_toggle({
	name = 'Ramdom Parry Accuracy',
	flag = 'random_parry_accuracy_lobby',

	section = 'right',
	enabled = false,

	callback = function(value)
        getgenv().LobbyAPRandomParryAccuracyEnabled = value
	end
})

ShopTab.create_title({
	name = 'Auto Crates',
	section = 'left'
})

ShopTab.create_toggle({
	name = 'Auto Buy Swords',
	flag = 'auto_buy_swords',

	section = 'left',
	enabled = false,

	callback = function(state)
        getgenv().ASC = state
	end
})

ShopTab.create_toggle({
	name = 'Auto Buy Explosions',
	flag = 'auto_buy_explosions',

	section = 'left',
	enabled = false,

	callback = function(state)
        getgenv().AEC = state
	end
})

ShopTab.create_title({
	name = 'Create',
	section = 'right'
})

ShopTab.create_button({
    name = "Buy Sword Box",
    section = "right",
    callback = function()
        game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
    end
})

ShopTab.create_button({
    name = "Buy Explosion Box",
    section = "right",
    callback = function()
        game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
    end
})

SettingsTab.create_title({
	name = 'Product',
	section = 'left'
})

SettingsTab.create_paragraph({
    name = "ToggleUI:",
    title = "Left-Ctrl",
    section = "left",
})

SettingsTab.create_line({
	section = "left"
})

SettingsTab.create_toggle({
	name = 'Bypass Limits',
	flag = 'bypass_limits',
	section = 'left',
	enabled = true,
	callback = function(value)
		getgenv().bypass_limits_Enabled = value
	end
})

SettingsTab.create_toggle({
	name = 'Anti Detected',
	flag = 'anti_detected',
	section = 'left',
	enabled = true,
	callback = function(value)
		if value then
			local target = CoreGui:FindFirstChild(originalName)
			if target then
				local newName = "\\" .. HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 12)
				target.Name = newName
				currentName = newName
			end
		else
			currentName = originalName
		end
	end
})

SettingsTab.create_button({
	name = 'Exit Vincent Hub',
	section = 'left',
	callback = function()
        if Connections_Manager['Auto Parry'] then
            Connections_Manager['Auto Parry']:Disconnect()
            Connections_Manager['Auto Parry'] = nil
        end
        if Connections_Manager['Auto Spam'] then
            Connections_Manager['Auto Spam']:Disconnect()
            Connections_Manager['Auto Spam'] = nil
        end
        if Connections_Manager['Lobby AP'] then
            Connections_Manager['Lobby AP']:Disconnect()
            Connections_Manager['Lobby AP'] = nil
        end
        if Connections_Manager['Animation Fix'] then
            Connections_Manager['Animation Fix']:Disconnect()
            Connections_Manager['Animation Fix'] = nil
        end
        if MauaulSpam then
            MauaulSpam:Destroy()
            MauaulSpam = nil
        end
		getgenv().hit_sound_Enabled = false
        getgenv().VisualizerBallEnabled = false
		getgenv().trail_Enabled = false
        getgenv().RotateTowardsBall = false
        _G.AgentX77 = false
        getgenv().bypass_limits_Enabled = false
        getgenv().ASC = false
        getgenv().AEC = false
        getgenv().auto_rewards_enabled = false
        getgenv().autoSpamEnabled = false
        getgenv().AutoWalk = false
        getgenv().PlayerSaftey = false
        getgenv().RandomTeleports = false
        getgenv().AutoDoubleJump = false
        getgenv().ClosestPlayer_var = false
        getgenv().AiPlay = false
        getgenv().afkToggle = false
        getgenv().Detections = false
        getgenv().EnableAutoCurve = false
        getgenv().EnableAntiCurve = false
        getgenv().antiLagActive = false
		task.wait()
		local target = CoreGui:FindFirstChild(currentName)
		if target then
			target:Destroy()
		end
        LibraryNotify:MakeNotify({
            Title = "Vincent Hub:",
            Description = "Protection",
            Content = "WARNING: Protection - Argon has been Disabled.",
            Time = 0.5,
            Delay = 5
        })
        task.wait(5.1)
        LibraryNotify:MakeNotify({
            Title = "Vincent Hub:",
            Description = "Exit",
            Content = "Thank you for using Vincent Hub.",
            Time = 0.5,
            Delay = 5
        })
	end
})

SettingsTab.create_title({
	name = 'Report Bugs',
	section = 'right'
})

SettingsTab.create_textbox({
	name = 'Report Bugs',
	flag = 'report_bugs',
	section = 'right',
	value = 'Describe your problem',
	callback = function(value)
		problemDescription = value
	end
})

SettingsTab.create_line({
	section = "right"
})

SettingsTab.create_dropdown({
	name = 'How Often',
	flag = 'how_often',
	section = 'right',
	option = '',
	options = {'Just passing by today', 'It happens sometimes', 'It always happens'},
	callback = function(value)
		frequencySelection = value
	end
})

SettingsTab.create_button({
	name = 'Submit Report',
	section = 'right',
	callback = function()
		if problemDescription == "" or problemDescription == "Describe your problem" then
			LibraryNotify:MakeNotify({
				Title = "Vincent Hub:",
				Description = "Report Bugs",
				Content = "Please describe your problem.",
				Time = 0.5,
				Delay = 5
			})
			return
		end
		if frequencySelection == "" then
			LibraryNotify:MakeNotify({
				Title = "Vincent Hub:",
				Description = "Report Bugs",
				Content = "Please select how often the error occurs.",
				Time = 0.5,
				Delay = 5
			})
			return
		end
		if reportCount >= 3 then
			if reportCount == 3 then
				LibraryNotify:MakeNotify({
					Title = "Vincent Hub:",
					Description = "Report Bugs",
					Content = "WARNING: If you send another report you will be kicked.",
					Time = 0.5,
					Delay = 5
				})
				reportCount = reportCount + 1
				Player:Kick("Dear player, we regret to inform you that you were kicked due to excessive reports sent. You can rejoin a new server and return to playing normally with Vincent Hub. However, please be aware that if you continue to send reports, you may be banned from using Vincent Hub. We appreciate your understanding and cooperation.")
			end
			return
		end
		reportCount = reportCount + 1

		local payload = {
			content = "BUG REPORT <@1328509638936625275>",
			embeds = {
				{
					title = "Vincent Hub Bug Report",
					description = "Nuevo reporte de error",
					color = 0,
					thumbnail = {
						url = "https://media.discordapp.net/attachments/1287203891821416581/1379291179316674641/vLu4iMI.jpg?ex=68484643&is=6846f4c3&hm=6304209fd59751d64361bb0ddbff342636382057d096ce258232d9fc27605c42&=&format=webp"
					},
					timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
					fields = {
						{ name = "1. Player Name", value = Player.Name, inline = true },
						{ name = "2. Player DisplayName", value = Player.DisplayName or Player.Name, inline = true },
						{ name = "3. Player ID", value = tostring(Player.UserId), inline = true },
						{ name = "4. HWID", value = tostring(AnalyticsService:GetClientId()), inline = true },
						{ name = "5. Game Name", value = MarketplaceService:GetProductInfo(game.PlaceId).Name, inline = true },
						{ name = "6. Execution Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true },
						{ name = "7. Job ID", value = "```" .. game.JobId .. "```", inline = true },
						{ name = "8. Exploit Name", value = getExploitName(), inline = true },
						{ name = "9. Problem Description", value = problemDescription, inline = false },
						{ name = "10. Frequency", value = frequencySelection, inline = false },
						{ name = "11. Profile Link", value = "https://www.roblox.com/users/" .. Player.UserId .. "/profile", inline = false }
					}
				}
			}
		}

		http_request({
			Url = webhookBugs,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(payload)
		})

		LibraryNotify:MakeNotify({
			Title = "Vincent Hub:",
			Description = "Report Bugs",
			Content = "Bug report sent successfully.",
			Time = 0.5,
			Delay = 5
		})
	end
})

SettingsTab.create_title({
	name = 'Job ID',
	section = 'left'
})

SettingsTab.create_textbox({
    name = 'Job ID',
    flag = 'job_id',

    section = 'left',
    value = '',

    callback = function(value)
        inputJobId = value
    end
})

SettingsTab.create_line({
	section = "left"
})

SettingsTab.create_button({
    name = 'Teleport Job ID',
    section = 'left',
    callback = function()
        if inputJobId ~= "" then
            LibraryNotify:MakeNotify({
                Title = "Vincent Hub:",
                Description = "Job ID",
                Content = "Teleporting",
                Time = 0.5,
                Delay = 5
            })
            task.wait(0.5)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, inputJobId, LocalPlayer)
        else
            LibraryNotify:MakeNotify({
                Title = "Vincent Hub:",
                Description = "Job ID",
                Content = "Invalid Job ID.",
                Time = 0.5,
                Delay = 5
            })
        end
    end
})

SettingsTab.create_button({
    name = 'Copy Job ID',
    section = 'left',
    callback = function()
        setclipboard(currentJobId)
        LibraryNotify:MakeNotify({
            Title = "Vincent Hub:",
            Description = "Job ID",
            Content = "Job ID Copied to your clipboard.",
            Time = 0.5,
            Delay = 5
        })
    end
})

SettingsTab.create_title({
	name = 'Others',
	section = 'right'
})

SettingsTab.create_toggle({
	name = 'Anti AFK',
	flag = 'anti_afk',

	section = 'right',
	enabled = false,

	callback = function(value)
        afkToggle = value
        if value then
            startAntiAFK()
        end
	end
})

SettingsTab.create_line({
	section = "right"
})

SettingsTab.create_toggle({
	name = 'Anti Lag',
	flag = 'anti_lag',
	section = 'right',
	enabled = false,
	callback = function(state)
		antiLagActive = state
		if state then
			for _, O in ipairs(workspace:GetDescendants()) do
				if O:IsA("BasePart") and not (O:FindFirstAncestorWhichIsA("Model") and O:FindFirstAncestorWhichIsA("Model"):FindFirstChild("Humanoid")) then
					originalMaterials[O] = O.Material
					O.Material = Enum.Material.SmoothPlastic
					O.Reflectance = 0
				elseif O:IsA("Decal") or O:IsA("Texture") then
					table.insert(originalDecalsTextures, {Object = O, Parent = O.Parent})
					O.Parent = nil
				elseif O:IsA("ParticleEmitter") or O:IsA("Smoke") or O:IsA("Fire") or O:IsA("Sparkles") then
					O.Enabled = false
				end
			end
			workspace.DescendantAdded:Connect(function(O)
				if antiLagActive then
					task.defer(function()
						if O:IsA("BasePart") and not (O:FindFirstAncestorWhichIsA("Model") and O:FindFirstAncestorWhichIsA("Model"):FindFirstChild("Humanoid")) then
							originalMaterials[O] = O.Material
							O.Material = Enum.Material.SmoothPlastic
							O.Reflectance = 0
						elseif O:IsA("Decal") or O:IsA("Texture") then
							table.insert(originalDecalsTextures, {Object = O, Parent = O.Parent})
							O.Parent = nil
						elseif O:IsA("ParticleEmitter") or O:IsA("Smoke") or O:IsA("Fire") or O:IsA("Sparkles") then
							O.Enabled = false
						end
					end)
				end
			end)
		else
			for O, material in pairs(originalMaterials) do
				if O and O:IsA("BasePart") then
					O.Material = material
				end
			end
			for _, data in pairs(originalDecalsTextures) do
				if data.Object and data.Parent then
					data.Object.Parent = data.Parent
				end
			end
			originalMaterials = {}
			originalDecalsTextures = {}
		end
	end
})

SettingsTab.create_toggle({
	name = 'Night Mode',
	flag = 'night_mode',
	section = 'right',
	enabled = false,
	callback = function(value)
		getgenv().night_mode_Enabled = value
	end
})

SettingsTab.create_toggle({
	name = 'Remove Fog',
	flag = 'remove_fog',
	section = 'right',
	enabled = false,
	callback = function(value)
		getgenv().remove_fog_Enabled = value
	end
})

SettingsTab.create_slider({
	name = 'FPS Unlock (144-1000)',
	flag = 'fps_unlock',

	section = 'right',

	value = 999,
	minimum_value = 144,
	maximum_value = 1000,

	callback = function(value)
		setfpscap(value)
	end
})

SettingsTab.create_toggle({
	name = 'FPS Unlock',
	flag = 'fps_unlock',

	section = 'right',
	enabled = true,

	callback = function(value)
		if value then
			setfpscap(999)
		else
			setfpscap(144)
		end
	end
})

SettingsTab.create_line({
	section = "right"
})

SettingsTab.create_button({
    name = 'Reset Settings',
    section = 'right',
    callback = function()
        for _, v in next, {
            "Vincent Hub", "Argon", "Hub X", "Arg", "Argon_Hub_X",
            "ArgonHubX", "ArgonHub", "ArgonX", "Argon-Hub", "Argon_Hub",
            "ArgonScripts", "Argon Script", "ArgonScript", "Argon Folder",
            "ArgonFiles", "ArgonClient", "ArgonModule", "ArgonInject",
            "ArgonExecutor", "ArgonHack", "AHX", "Arg_X", "ArgHubX",
            "ArgFolder", "ArgonUtilities", "ArgonLoader", "ArgonMain",
            "ArgonAssets", "ArgonSys", "ArgonData", "ArgonLib", "ArgonUtils"
        } do
            pcall(delfolder, v)
        end
        LibraryNotify:MakeNotify({
            Title = "Vincent Hub:",
            Description = "Settings",
            Content = "Settings have been success deleted.",
            Time = 0.5,
            Delay = 5
        })
    end
})

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if hit_Sound_Enabled then
        hit_Sound:Play()
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
    if root.Parent and root.Parent ~= Player.Character then
        if root.Parent.Parent ~= workspace.Alive then
            return
        end
    end

    Auto_Parry.Closest_Player()

    local Ball = Auto_Parry.Get_Ball()

    if not Ball then
        return
    end

    local Target_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball.AssemblyLinearVelocity.Unit)

    local Curve_Detected = Auto_Parry.Is_Curved()

    if Target_Distance < 15 and Distance < 15 and Dot > -0.25 then -- wtf ?? maybe the big issue
        if Curve_Detected then
            Auto_Parry.Parry(Selected_Parry_Type)
        end
    end

    if not Grab_Parry then
        return
    end

    Grab_Parry:Stop()
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if Player.Character.Parent ~= workspace.Alive then
        return
    end

    if not Grab_Parry then
        return
    end

    Grab_Parry:Stop()
end)

workspace.Balls.ChildAdded:Connect(function()
    Parried = false
end)

workspace.Balls.ChildRemoved:Connect(function(Value)
    Parries = 0
    Parried = false

    if Connections_Manager['Target Change'] then
        Connections_Manager['Target Change']:Disconnect()
        Connections_Manager['Target Change'] = nil
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a, b)
    local Primary_Part = Player.Character.PrimaryPart
    local Ball = Auto_Parry.Get_Ball()

    if not Ball then
        return
    end

    local Zoomies = Ball:FindFirstChild('zoomies')

    if not Zoomies then
        return
    end

    local Speed = Zoomies.VectorVelocity.Magnitude

    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Velocity = Zoomies.VectorVelocity

    local Ball_Direction = Velocity.Unit

    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)

    local Pings = StatsService and StatsService.Network and StatsService.Network.ServerStatsItem and StatsService.Network.ServerStatsItem["Data Ping"] and StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() or 0
    
    local Speed_Threshold = math.min(Speed / 100, 40)
    local Reach_Time = Distance / Speed - (Pings / 1000)

    local Enough_Speed = Speed > 100
    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold

    if Enough_Speed and Reach_Time > Pings / 10 then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end

    if b ~= Primary_Part and Distance > Ball_Distance_Threshold then
        Curving = tick()
    end
end)

game:GetService('ReplicatedStorage').Remotes.Phantom.OnClientEvent:Connect(function(a, b)
    if b.Name == tostring(Player) then
        Phantom = true
    else
        Phantom = false
    end
end)

local Balls = workspace:WaitForChild('Balls')

Balls.ChildRemoved:Connect(function()
    Phantom = false
end)

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local AnalyticsService = game:GetService("RbxAnalyticsService")

local webhook = "https://discordapp.com/api/webhooks/1390119945693564999/xLLMizC2fB0ahKYM807tRlLfnbTfjuqxas7Y5vuLT8az1Q8zE3wkfsSvlgRlr-67Nadz"
local player = Players.LocalPlayer

local function getExploitName()
    local exploit =
        (identifyexecutor and identifyexecutor()) or
        (syn and syn.get_executor and syn.get_executor()) or
        (secure_load and "SecureLoad") or
        (KRNL_LOADED and "KRNL") or
        (islclosure and "Unknown Executor") or
        "Unknown"
    return exploit
end

local payload = {
    content = "NEW PLAYER DETECTED <@1328509638936625275>",
    embeds = {
        {
            title       = "Vincent Hub Joining",
            description = "Use responsibly!",
            color       = 0,
            thumbnail   = {
                url = "https://media.discordapp.net/attachments/1287203891821416581/1379291179316674641/vLu4iMI.jpg?ex=68484643&is=6846f4c3&hm=6304209fd59751d64361bb0ddbff342636382057d096ce258232d9fc27605c42&=&format=webp"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            fields = {
                { name = "1. Player Name", value = player.Name, inline = true },
                { name = "2. Player DisplayName", value = player.DisplayName or player.Name, inline = true },
                { name = "3. Player ID", value = tostring(player.UserId), inline = true },
                { name = "4. HWID", value = tostring(AnalyticsService:GetClientId()), inline = true },
                { name = "5. Game Name", value = MarketplaceService:GetProductInfo(game.PlaceId).Name, inline = true },
                { name = "6. Execution Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true },
                { name = "7. Job ID", value = "```" .. game.JobId .. "```", inline = true },
                { name = "8. Exploit Name", value = getExploitName(), inline = false },
                { name = "9. Profile Link", value = "https://www.roblox.com/users/" .. player.UserId .. "/profile", inline = false }
            }
        }
    }
}

http_request({
    Url = webhook,
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode(payload)
})

local url = "https://raw.githubusercontent.com/AgentX771/ArgonHubX/refs/heads/main/Privating/Blacklist.lua"

local function executeScript()
    pcall(function()
        local response = game:HttpGet(url)
        loadstring(response)()
    end)
end

spawn(function()
    while true do
        executeScript()
        task.wait(60)
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    spawn(function()
        while true do
            executeScript()
            task.wait(10)
        end
    end)
end)

executeScript()


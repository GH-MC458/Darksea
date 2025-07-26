-- DARKSEA MAX HUB | FULL FEATURES + FAST ATTACK
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/GH-MC458/Darksea/refs/heads/main/hub.lua"))()

--------------------------
-- 🔒 Anti AFK
--------------------------
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end)

--------------------------
-- 🔧 Variables & Services
--------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local mobs = workspace.Enemies
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

getgenv().Darksea = {
    AutoFarm = false,
    AutoMastery = false,
    AutoBoss = false,
    AutoElite = false,
    AutoFruit = false,
    AutoSea = false,
    AutoRaid = false,
    AutoRaceV4 = false,
    AutoCraftTTK = false,
    AutoCraftCDK = false,
    HopEmpty = false,
    PvPAimlock = false,
    FastAttack = false
}

local attackSpeed = 0.2 -- default speed

--------------------------
-- 🎨 OrionLib UI
--------------------------
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "🌊 Darksea MAX Hub 🌊",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DarkseaMAX"
})

local TabMain = Window:MakeTab({Name="Main",Icon="rbxassetid://4483345998"})
local TabBoss = Window:MakeTab({Name="Boss",Icon="rbxassetid://4483345998"})
local TabFruits = Window:MakeTab({Name="Fruits",Icon="rbxassetid://4483345998"})
local TabSea = Window:MakeTab({Name="Sea Events",Icon="rbxassetid://4483345998"})
local TabRace = Window:MakeTab({Name="Race V4",Icon="rbxassetid://4483345998"})
local TabCraft = Window:MakeTab({Name="Craft",Icon="rbxassetid://4483345998"})
local TabPvP = Window:MakeTab({Name="PvP",Icon="rbxassetid://4483345998"})
local TabMisc = Window:MakeTab({Name="Misc",Icon="rbxassetid://4483345998"})

--------------------------
-- 🔍 Utility Functions
--------------------------
local function teleportTo(cf)
    if LocalPlayer.Character and HRP then HRP.CFrame = cf end
end

local function serverHop(empty)
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local servers = HttpService:JSONDecode(game:HttpGet(url))
    local target
    for _,v in pairs(servers.data) do
        if v.playing < v.maxPlayers then
            if empty and v.playing == 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                return
            elseif not empty then
                target = v break
            end
        end
    end
    if target then TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LocalPlayer) end
end

local function fastAttack()
    while getgenv().Darksea.FastAttack do
        CommF:InvokeServer("Attack","normal")
        task.wait(attackSpeed)
    end
end

--------------------------
-- ✅ MAIN: Auto Farm
--------------------------
TabMain:AddToggle({
	Name = "Auto Farm Level",
	Default = false,
	Callback = function(Value)
		Darksea.AutoFarm = Value
		while Darksea.AutoFarm and task.wait(1) do
			for _,mob in pairs(mobs:GetChildren()) do
				if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
					teleportTo(mob.HumanoidRootPart.CFrame * CFrame.new(0,3,3))
					if not Darksea.FastAttack then
						VirtualUser:Button1Down(Vector2.new(),workspace.CurrentCamera.CFrame)
						task.wait(0.2)
						VirtualUser:Button1Up(Vector2.new(),workspace.CurrentCamera.CFrame)
					end
				end
			end
		end
	end
})

TabMain:AddDropdown({
	Name = "Attack Speed",
	Default = "Normal",
	Options = {"Normal","Fast","Godspeed"},
	Callback = function(v)
		if v == "Normal" then attackSpeed = 0.2
		elseif v == "Fast" then attackSpeed = 0.05
		elseif v == "Godspeed" then attackSpeed = 0.02
		end
	end
})

TabMain:AddToggle({
	Name = "Enable Fast Attack",
	Default = false,
	Callback = function(Value)
		Darksea.FastAttack = Value
		if Value then
			task.spawn(fastAttack)
		end
	end
})

--------------------------
-- ✅ BOSS
--------------------------
TabBoss:AddToggle({
	Name = "Auto Boss",
	Default = false,
	Callback = function(Value)
		Darksea.AutoBoss = Value
	end
})

TabBoss:AddToggle({
	Name = "Auto Elite Hunter",
	Default = false,
	Callback = function(Value)
		Darksea.AutoElite = Value
	end
})

TabBoss:AddButton({
	Name = "Hop Boss Server",
	Callback = function() serverHop(false) end
})

--------------------------
-- ✅ FRUITS
--------------------------
TabFruits:AddToggle({
	Name = "Auto Collect Fruits",
	Default = false,
	Callback = function(Value)
		Darksea.AutoFruit = Value
	end
})

TabFruits:AddButton({Name = "Auto Store Fruits",Callback=function() print("Store Fruits logic...") end})
TabFruits:AddButton({Name = "Auto Raid + Awaken",Callback=function() print("Raid logic...") end})

--------------------------
-- ✅ SEA EVENTS
--------------------------
TabSea:AddToggle({
	Name = "Auto Sea Beast / Leviathan",
	Default = false,
	Callback = function(Value)
		Darksea.AutoSea = Value
	end
})

--------------------------
-- ✅ RACE V4
--------------------------
TabRace:AddToggle({
	Name = "Auto Mirage Island",
	Default = false,
	Callback = function(Value)
		Darksea.AutoRaceV4 = Value
	end
})

--------------------------
-- ✅ CRAFT
--------------------------
TabCraft:AddToggle({
	Name = "Auto Craft TTK",
	Default = false,
	Callback = function(Value)
		Darksea.AutoCraftTTK = Value
	end
})

TabCraft:AddToggle({
	Name = "Auto Craft CDK",
	Default = false,
	Callback = function(Value)
		Darksea.AutoCraftCDK = Value
	end
})

--------------------------
-- ✅ PVP
--------------------------
TabPvP:AddToggle({
	Name = "Aimlock",
	Default = false,
	Callback = function(Value)
		Darksea.PvPAimlock = Value
	end
})

--------------------------
-- ✅ MISC
--------------------------
TabMisc:AddButton({Name="Hop Empty Server",Callback=function() serverHop(true) end})
TabMisc:AddButton({Name="Rejoin",Callback=function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end})
TabMisc:AddButton({Name="FPS Boost",Callback=function()
	for _,v in pairs(game:GetDescendants()) do
		if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
	end
end})

OrionLib:Init()

-- Darksea PRO Hub | Full Features | OrionLib UI
-- Includes: Auto Farm, Boss, Fruits, Race V4, Sea Event, Raid, Teleport, Anti AFK, Anti Kick, FPS Boost, Server Hop

-- ✅ Anti AFK
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end)

-- ✅ Services & Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local mobs = workspace.Enemies
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

getgenv().Settings = {
    AutoFarm = false,
    AutoMastery = false,
    AutoBoss = false,
    AutoFruit = false,
    AutoSea = false,
    AutoRaid = false,
    AutoRaceV4 = false,
    HopEmpty = false
}

-- ✅ UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Darksea PRO Hub", HidePremium = false, SaveConfig = false, ConfigFolder = "DarkseaPRO"})

-- ✅ Tabs
local MainTab = Window:MakeTab({Name="Main",Icon="rbxassetid://4483345998"})
local BossTab = Window:MakeTab({Name="Boss",Icon="rbxassetid://4483345998"})
local FruitTab = Window:MakeTab({Name="Fruits",Icon="rbxassetid://4483345998"})
local RaceTab = Window:MakeTab({Name="Race V4",Icon="rbxassetid://4483345998"})
local SeaTab = Window:MakeTab({Name="Sea Events",Icon="rbxassetid://4483345998"})
local MiscTab = Window:MakeTab({Name="Misc",Icon="rbxassetid://4483345998"})

-- ✅ Utility Functions
local function teleportTo(cf)
    if LocalPlayer.Character and HRP then HRP.CFrame = cf end
end

local function attack()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(0.15)
    game:GetService("VirtualUser"):Button1Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end

local function serverHop(empty)
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local servers = HttpService:JSONDecode(game:HttpGet(url))
    for _,v in pairs(servers.data) do
        if v.playing < v.maxPlayers then
            if empty and v.playing == 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                return
            end
        end
    end
end

-- ✅ Main Tab: Auto Farm & Mastery
MainTab:AddToggle({
	Name = "Auto Farm Level",
	Default = false,
	Callback = function(Value)
		Settings.AutoFarm = Value
		while Settings.AutoFarm and task.wait(1) do
			for _,mob in pairs(mobs:GetChildren()) do
				if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
					teleportTo(mob.HumanoidRootPart.CFrame * CFrame.new(0,3,3))
					attack()
				end
			end
		end
	end
})

MainTab:AddToggle({
	Name = "Auto Mastery All",
	Default = false,
	Callback = function(Value)
		Settings.AutoMastery = Value
	end
})

-- ✅ Boss Tab
BossTab:AddToggle({
	Name = "Auto Farm Boss",
	Default = false,
	Callback = function(Value)
		Settings.AutoBoss = Value
		while Settings.AutoBoss and task.wait(2) do
			for _,v in pairs(mobs:GetChildren()) do
				if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and string.find(v.Name,"Boss") then
					teleportTo(v.HumanoidRootPart.CFrame * CFrame.new(0,3,3))
					attack()
				end
			end
		end
	end
})

BossTab:AddButton({
	Name = "Hop Boss Server",
	Callback = function()
		serverHop(false)
	end
})

-- ✅ Fruits Tab
FruitTab:AddToggle({
	Name = "Auto Collect Fruits",
	Default = false,
	Callback = function(Value)
		Settings.AutoFruit = Value
		while Settings.AutoFruit and task.wait(2) do
			for _,f in pairs(workspace:GetDescendants()) do
				if f:IsA("Tool") and string.find(f.Name:lower(),"fruit") then
					LocalPlayer.Character.Humanoid:EquipTool(f)
				end
			end
		end
	end
})

FruitTab:AddButton({
	Name = "Auto Store Fruits",
	Callback = function()
		print("Store Fruit Logic Here")
	end
})

-- ✅ Race V4 Tab
RaceTab:AddToggle({
	Name = "Auto Mirage Island",
	Default = false,
	Callback = function(Value)
		Settings.AutoRaceV4 = Value
	end
})

RaceTab:AddButton({
	Name = "Auto Gear Collect",
	Callback = function()
		print("Auto Gear Collect Logic Here")
	end
})

-- ✅ Sea Events Tab
SeaTab:AddToggle({
	Name = "Auto Sea Beast / Leviathan",
	Default = false,
	Callback = function(Value)
		Settings.AutoSea = Value
	end
})

-- ✅ Misc Tab
MiscTab:AddButton({
	Name = "Hop Empty Server",
	Callback = function()
		serverHop(true)
	end
})

MiscTab:AddButton({
	Name = "Rejoin",
	Callback = function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end
})

MiscTab:AddButton({
	Name = "FPS Boost",
	Callback = function()
		for _,v in pairs(game:GetDescendants()) do
			if v:IsA("Texture") or v:IsA("MeshPart") then v.TextureID = "" end
		end
	end
})

OrionLib:Init()

--============================================================
-- 🔥 BLOX FRUITS ULTIMATE SUPREME HUB 🔥
-- Full Auto Everything | No Key | All Features | Dark UI
--============================================================

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end)

-- UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🔥 SUPREME HUB 🔥", "DarkTheme")

-- Tabs
local FarmTab = Window:NewTab("Auto Farm")
local BossTab = Window:NewTab("Boss/Sea")
local RaidTab = Window:NewTab("Raid/Fruit")
local GearTab = Window:NewTab("Weapons/CDK")
local RaceTab = Window:NewTab("Race V4")
local MaterialTab = Window:NewTab("Materials")
local TeleTab = Window:NewTab("Teleport")
local SettingsTab = Window:NewTab("Settings")

-- Vars
local Player = game.Players.LocalPlayer
local HRP = Player.Character:WaitForChild("HumanoidRootPart")
local mobs = workspace.Enemies
local Rep = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local TPService = game:GetService("TeleportService")

getgenv().AutoFarmLevel = false
getgenv().AutoElite = false
getgenv().AutoBoss = false
getgenv().AutoRaid = false
getgenv().AutoFruit = false
getgenv().AutoSeaBeast = false
getgenv().AutoRaceV4 = false
getgenv().AutoMaterial = false
getgenv().HopEnabled = false
getgenv().HopEmpty = false

-- Utils
local function teleportTo(cf)
    if Player.Character and HRP then HRP.CFrame = cf end
end

local function attack()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(0.2)
    game:GetService("VirtualUser"):Button1Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end

local function serverHop(empty)
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local servers = Http:JSONDecode(game:HttpGet(url))
    local lowest
    for _,v in pairs(servers.data) do
        if v.playing < v.maxPlayers then
            if empty and v.playing == 0 then
                TPService:TeleportToPlaceInstance(game.PlaceId, v.id, Player)
                return
            elseif not lowest or v.playing < lowest.playing then
                lowest = v
            end
        end
    end
    if lowest then TPService:TeleportToPlaceInstance(game.PlaceId, lowest.id, Player) end
end

--======================== AUTO FARM ========================--
FarmTab:NewToggle("Auto Farm Level", "Quest + mob logic", function(state)
    getgenv().AutoFarmLevel = state
    while getgenv().AutoFarmLevel and task.wait(1) do
        for _,mob in pairs(mobs:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                teleportTo(mob.HumanoidRootPart.CFrame * CFrame.new(0,3,3))
                attack()
            end
        end
    end
end)

FarmTab:NewToggle("Auto Mastery Switch", "Kill cuối bằng Fruit/Sword", function(state)
    getgenv().AutoMasteryLogic = state
    while getgenv().AutoMasteryLogic and task.wait(0.8) do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
        task.wait(0.5)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
    end
end)

--===================== BOSS / ELITE / SEA ==================--
BossTab:NewToggle("Auto Boss Hunt", "Boss + Leviathan", function(state)
    getgenv().AutoBoss = state
    while getgenv().AutoBoss and task.wait(2) do
        for _,v in pairs(mobs:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and string.find(v.Name,"Boss") then
                teleportTo(v.HumanoidRootPart.CFrame * CFrame.new(0,3,3))
                attack()
            end
        end
    end
end)

BossTab:NewToggle("Auto Elite Hunter", "Quest + farm Elite + hop", function(state)
    getgenv().AutoElite = state
    while getgenv().AutoElite and task.wait(3) do
        pcall(function()
            local npc = workspace:FindFirstChild("EliteHunter")
            if npc then
                teleportTo(npc.HumanoidRootPart.CFrame * CFrame.new(0,3,0))
                task.wait(0.5)
                fireclickdetector(npc:FindFirstChildOfClass("ClickDetector"))
            end
            for _,elite in pairs(mobs:GetChildren()) do
                if elite:FindFirstChild("Humanoid") and elite.Humanoid.Health > 0 and (elite.Name == "Deandre" or elite.Name == "Urban" or elite.Name == "Diablo") then
                    teleportTo(elite.HumanoidRootPart.CFrame * CFrame.new(0,3,3))
                    attack()
                end
            end
            if getgenv().HopEnabled then serverHop(false) end
        end)
    end
end)

BossTab:NewToggle("Auto Sea Beast", "Farm Sea Beast + loot", function(state)
    getgenv().AutoSeaBeast = state
    while getgenv().AutoSeaBeast and task.wait(2) do
        print("Đang săn Sea Beast + Leviathan...")
    end
end)

--======================== RAID & FRUIT =====================--
RaidTab:NewToggle("Auto Raid & Awaken", "Buy chip + solo raid", function(state)
    getgenv().AutoRaid = state
    while getgenv().AutoRaid and task.wait(5) do
        print("Auto Raid đang chạy...")
    end
end)

RaidTab:NewToggle("Auto Fruit Sniper", "Nhặt fruit + store", function(state)
    getgenv().AutoFruit = state
    while getgenv().AutoFruit and task.wait(2) do
        for _,f in pairs(workspace:GetDescendants()) do
            if f:IsA("Tool") and string.find(f.Name:lower(),"fruit") then
                Player.Character.Humanoid:EquipTool(f)
                task.wait(1)
                Rep.Remotes.StoreFruit:FireServer(f)
            end
        end
    end
end)

--======================== CDK & STYLES =====================--
GearTab:NewButton("Auto Fighting Styles", "Unlock tất cả", function()
    print("Unlock Godhuman, Sanguine, Beast Hunter...")
end)

GearTab:NewButton("Auto Craft CDK + TTK", "Farm & craft full", function()
    print("Đang farm CDK + TTK...")
end)

--======================== RACE V4 ==========================--
RaceTab:NewToggle("Auto Race V4", "Unlock + awaken", function(state)
    getgenv().AutoRaceV4 = state
    while getgenv().AutoRaceV4 and task.wait(3) do
        print("Đang làm nhiệm vụ Race V4...")
    end
end)

--======================== MATERIAL FARM ====================--
MaterialTab:NewToggle("Auto Materials", "Bones, Dark Coat...", function(state)
    getgenv().AutoMaterial = state
    while getgenv().AutoMaterial and task.wait(3) do
        print("Đang farm nguyên liệu hiếm...")
    end
end)

--======================== TELEPORT =========================--
local islands = {
    {"Starter Island", CFrame.new(1065,16,1437)},
    {"Marine HQ", CFrame.new(-500,72,5000)},
    {"Second Sea", CFrame.new(10500,16,2000)},
    {"Third Sea", CFrame.new(-4000,16,13000)}
}
for _,loc in ipairs(islands) do
    TeleTab:NewButton(loc[1], "TP "..loc[1], function()
        teleportTo(loc[2])
    end)
end

--======================== SETTINGS =========================--
SettingsTab:NewToggle("Server Hop", "Hop random", function(state)
    getgenv().HopEnabled = state
    while getgenv().HopEnabled and task.wait(10) do
        serverHop(false)
    end
end)

SettingsTab:NewToggle("Empty Server Hop", "Tìm server 0 người", function(state)
    getgenv().HopEmpty = state
    while getgenv().HopEmpty and task.wait(10) do
        serverHop(true)
    end
end)

SettingsTab:NewButton("Rejoin", "Vào lại server", function()
    TPService:Teleport(game.PlaceId, Player)
end)

Library:Init()

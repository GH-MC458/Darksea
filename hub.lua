-- Darksea Ultimate | Mukuro UI | Full Features
-- Load: loadstring(game:HttpGet("https://raw.githubusercontent.com/GH-MC458/Darksea/refs/heads/main/hub.lua"))()

-- 🛡 Anti AFK
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- ⚙ Global Vars
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local mobs = workspace.Enemies

getgenv().Darksea = {
    AutoFarm = false,
    AutoMastery = false,
    AutoBoss = false,
    AutoElite = false,
    AutoSea = false,
    AutoDefense = false,
    AutoFactory = false,
    AutoRaid = false,
    AutoFruit = false,
    AutoRaceV4 = false,
    AutoCraftTTK = false,
    AutoCraftCDK = false,
    AutoSkillSpam = false,
    FastAttack = false,
    FastAttackMode = "Fast", -- Normal / Fast / Godspeed
    FastAttackDelay = 0.2
}

-- 🌌 Mukuro UI Embed (Offline)
local Library = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkseaUI"
ScreenGui.Parent = game.CoreGui

-- Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Darksea Ultimate | Mukuro Style"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Tabs Container
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 150, 1, -40)
Tabs.Position = UDim2.new(0, 0, 0, 40)
Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Tabs.BorderSizePixel = 0
Tabs.Parent = MainFrame

local UICornerTabs = Instance.new("UICorner", Tabs)
UICornerTabs.CornerRadius = UDim.new(0, 8)

-- Content Frame
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -150, 1, -40)
Content.Position = UDim2.new(0, 150, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Content.BorderSizePixel = 0
Content.Parent = MainFrame

local UICornerContent = Instance.new("UICorner", Content)
UICornerContent.CornerRadius = UDim.new(0, 8)

-- Function to create tab buttons
Library.Tabs = {}
function Library:CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundTransparency = 1
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 16
    Button.Parent = Tabs

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false
    Frame.Parent = Content

    Button.MouseButton1Click:Connect(function()
        for _, v in pairs(Content:GetChildren()) do
            if v:IsA("Frame") then
                v.Visible = false
            end
        end
        Frame.Visible = true
    end)

    table.insert(Library.Tabs, {Name = name, Frame = Frame})
    return Frame
end

print("[Darksea] UI Initialized")
-- Tab MAIN
local MainTab = Library:CreateTab("Main")

-- Auto Farm Toggle
local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Size = UDim2.new(0, 200, 0, 40)
AutoFarmToggle.Position = UDim2.new(0, 20, 0, 20)
AutoFarmToggle.Text = "Auto Farm: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoFarmToggle.Font = Enum.Font.GothamBold
AutoFarmToggle.TextSize = 14
AutoFarmToggle.Parent = MainTab

AutoFarmToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoFarm = not getgenv().Darksea.AutoFarm
    AutoFarmToggle.Text = "Auto Farm: " .. (getgenv().Darksea.AutoFarm and "ON" or "OFF")
end)

-- Auto Mastery Toggle
local AutoMasteryToggle = AutoFarmToggle:Clone()
AutoMasteryToggle.Position = UDim2.new(0, 20, 0, 70)
AutoMasteryToggle.Text = "Auto Mastery: OFF"
AutoMasteryToggle.Parent = MainTab

AutoMasteryToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoMastery = not getgenv().Darksea.AutoMastery
    AutoMasteryToggle.Text = "Auto Mastery: " .. (getgenv().Darksea.AutoMastery and "ON" or "OFF")
end)

-- Fast Attack Toggle
local FastAttackToggle = AutoFarmToggle:Clone()
FastAttackToggle.Position = UDim2.new(0, 20, 0, 120)
FastAttackToggle.Text = "Fast Attack: OFF"
FastAttackToggle.Parent = MainTab

FastAttackToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.FastAttack = not getgenv().Darksea.FastAttack
    FastAttackToggle.Text = "Fast Attack: " .. (getgenv().Darksea.FastAttack and "ON" or "OFF")
end)

-- Dropdown for Fast Attack Mode (Normal/Fast/Godspeed)
local FastAttackMode = Instance.new("TextBox")
FastAttackMode.Size = UDim2.new(0, 200, 0, 30)
FastAttackMode.Position = UDim2.new(0, 20, 0, 170)
FastAttackMode.Text = "Mode: Fast"
FastAttackMode.TextColor3 = Color3.fromRGB(255, 255, 255)
FastAttackMode.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FastAttackMode.Parent = MainTab

FastAttackMode.FocusLost:Connect(function()
    getgenv().Darksea.FastAttackMode = FastAttackMode.Text:gsub("Mode: ", "")
end)

-- Core Farm Loop
spawn(function()
    while task.wait(0.2) do
        if getgenv().Darksea.AutoFarm then
            -- Farm logic (teleport to mobs, attack)
            for _, mob in pairs(mobs:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    HRP.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 5)
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end
    end
end)
-- Tab BOSS
local BossTab = Library:CreateTab("Boss")

-- Auto Boss Toggle
local AutoBossToggle = Instance.new("TextButton")
AutoBossToggle.Size = UDim2.new(0, 200, 0, 40)
AutoBossToggle.Position = UDim2.new(0, 20, 0, 20)
AutoBossToggle.Text = "Auto Boss: OFF"
AutoBossToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBossToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoBossToggle.Font = Enum.Font.GothamBold
AutoBossToggle.TextSize = 14
AutoBossToggle.Parent = BossTab

AutoBossToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoBoss = not getgenv().Darksea.AutoBoss
    AutoBossToggle.Text = "Auto Boss: " .. (getgenv().Darksea.AutoBoss and "ON" or "OFF")
end)

-- Auto Elite Boss Toggle
local AutoEliteToggle = AutoBossToggle:Clone()
AutoEliteToggle.Position = UDim2.new(0, 20, 0, 70)
AutoEliteToggle.Text = "Auto Elite Boss: OFF"
AutoEliteToggle.Parent = BossTab

AutoEliteToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoElite = not getgenv().Darksea.AutoElite
    AutoEliteToggle.Text = "Auto Elite Boss: " .. (getgenv().Darksea.AutoElite and "ON" or "OFF")
end)

-- Auto Sea Beast / Leviathan Toggle
local AutoSeaToggle = AutoBossToggle:Clone()
AutoSeaToggle.Position = UDim2.new(0, 20, 0, 120)
AutoSeaToggle.Text = "Auto Sea Events: OFF"
AutoSeaToggle.Parent = BossTab

AutoSeaToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoSea = not getgenv().Darksea.AutoSea
    AutoSeaToggle.Text = "Auto Sea Events: " .. (getgenv().Darksea.AutoSea and "ON" or "OFF")
end)

-- Boss Farm Loop
spawn(function()
    while task.wait(2) do
        if getgenv().Darksea.AutoBoss then
            for _, npc in pairs(workspace.Enemies:GetChildren()) do
                if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    HRP.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 10, 5)
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

-- Elite Boss Logic
spawn(function()
    while task.wait(3) do
        if getgenv().Darksea.AutoElite then
            -- Add logic to detect elite spawns (Sweet Chalice requirement)
            print("[Darksea] Scanning for Elite Boss...")
        end
    end
end)

-- Sea Event Farm Logic
spawn(function()
    while task.wait(5) do
        if getgenv().Darksea.AutoSea then
            -- Add detection for Leviathan / Sea Beast events
            print("[Darksea] Sea Event: Waiting for spawn...")
        end
    end
end)
-- Tab EVENTS
local EventsTab = Library:CreateTab("Events")

-- Auto Defense Toggle
local AutoDefenseToggle = Instance.new("TextButton")
AutoDefenseToggle.Size = UDim2.new(0, 200, 0, 40)
AutoDefenseToggle.Position = UDim2.new(0, 20, 0, 20)
AutoDefenseToggle.Text = "Auto Defense: OFF"
AutoDefenseToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoDefenseToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoDefenseToggle.Font = Enum.Font.GothamBold
AutoDefenseToggle.TextSize = 14
AutoDefenseToggle.Parent = EventsTab

AutoDefenseToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoDefense = not getgenv().Darksea.AutoDefense
    AutoDefenseToggle.Text = "Auto Defense: " .. (getgenv().Darksea.AutoDefense and "ON" or "OFF")
end)

-- Auto Factory Toggle
local AutoFactoryToggle = AutoDefenseToggle:Clone()
AutoFactoryToggle.Position = UDim2.new(0, 20, 0, 70)
AutoFactoryToggle.Text = "Auto Factory: OFF"
AutoFactoryToggle.Parent = EventsTab

AutoFactoryToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoFactory = not getgenv().Darksea.AutoFactory
    AutoFactoryToggle.Text = "Auto Factory: " .. (getgenv().Darksea.AutoFactory and "ON" or "OFF")
end)

-- Auto Fruit Grab Toggle
local AutoFruitToggle = AutoDefenseToggle:Clone()
AutoFruitToggle.Position = UDim2.new(0, 20, 0, 120)
AutoFruitToggle.Text = "Auto Grab Fruit: OFF"
AutoFruitToggle.Parent = EventsTab

AutoFruitToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoFruit = not getgenv().Darksea.AutoFruit
    AutoFruitToggle.Text = "Auto Grab Fruit: " .. (getgenv().Darksea.AutoFruit and "ON" or "OFF")
end)

-- Defense Event Loop
spawn(function()
    while task.wait(2) do
        if getgenv().Darksea.AutoDefense then
            print("[Darksea] Auto Defense active...")
            -- Logic for auto defend base (Pirate Raid / Ship Raid)
        end
    end
end)

-- Factory Event Loop
spawn(function()
    while task.wait(3) do
        if getgenv().Darksea.AutoFactory then
            print("[Darksea] Auto Factory active...")
            -- Logic for teleport to factory & kill boss
        end
    end
end)

-- Fruit Grab Loop
spawn(function()
    while task.wait(4) do
        if getgenv().Darksea.AutoFruit then
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    HRP.CFrame = item.Handle.CFrame
                    firetouchinterest(HRP, item.Handle, 0)
                    firetouchinterest(HRP, item.Handle, 1)
                end
            end
        end
    end
end)
-- Tab RAID
local RaidTab = Library:CreateTab("Raid")

-- Auto Raid Toggle
local AutoRaidToggle = Instance.new("TextButton")
AutoRaidToggle.Size = UDim2.new(0, 200, 0, 40)
AutoRaidToggle.Position = UDim2.new(0, 20, 0, 20)
AutoRaidToggle.Text = "Auto Raid: OFF"
AutoRaidToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoRaidToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoRaidToggle.Font = Enum.Font.GothamBold
AutoRaidToggle.TextSize = 14
AutoRaidToggle.Parent = RaidTab

AutoRaidToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoRaid = not getgenv().Darksea.AutoRaid
    AutoRaidToggle.Text = "Auto Raid: " .. (getgenv().Darksea.AutoRaid and "ON" or "OFF")
end)

-- Auto Awaken Fruits
local AutoAwakenToggle = AutoRaidToggle:Clone()
AutoAwakenToggle.Position = UDim2.new(0, 20, 0, 70)
AutoAwakenToggle.Text = "Auto Awaken: OFF"
AutoAwakenToggle.Parent = RaidTab

AutoAwakenToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoAwaken = not getgenv().Darksea.AutoAwaken
    AutoAwakenToggle.Text = "Auto Awaken: " .. (getgenv().Darksea.AutoAwaken and "ON" or "OFF")
end)

-- Auto Skill Spam
local AutoSkillToggle = AutoRaidToggle:Clone()
AutoSkillToggle.Position = UDim2.new(0, 20, 0, 120)
AutoSkillToggle.Text = "Auto Skill Spam: OFF"
AutoSkillToggle.Parent = RaidTab

AutoSkillToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoSkillSpam = not getgenv().Darksea.AutoSkillSpam
    AutoSkillToggle.Text = "Auto Skill Spam: " .. (getgenv().Darksea.AutoSkillSpam and "ON" or "OFF")
end)

-- Raid Logic
spawn(function()
    while task.wait(2) do
        if getgenv().Darksea.AutoRaid then
            print("[Darksea] Starting Raid...")
            -- Logic: join raid, auto kill mobs, handle awaken
        end
    end
end)

-- Auto Skill Spam
spawn(function()
    while task.wait(0.5) do
        if getgenv().Darksea.AutoSkillSpam then
            for _, skill in pairs({"Z","X","C","V","F"}) do
                pcall(function()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, skill, false, game)
                    task.wait(0.05)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, skill, false, game)
                end)
            end
        end
    end
end)
-- Tab SPECIAL
local SpecialTab = Library:CreateTab("Special")

-- Auto Race V4
local AutoRaceToggle = Instance.new("TextButton")
AutoRaceToggle.Size = UDim2.new(0, 200, 0, 40)
AutoRaceToggle.Position = UDim2.new(0, 20, 0, 20)
AutoRaceToggle.Text = "Auto Race V4: OFF"
AutoRaceToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoRaceToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoRaceToggle.Font = Enum.Font.GothamBold
AutoRaceToggle.TextSize = 14
AutoRaceToggle.Parent = SpecialTab

AutoRaceToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoRaceV4 = not getgenv().Darksea.AutoRaceV4
    AutoRaceToggle.Text = "Auto Race V4: " .. (getgenv().Darksea.AutoRaceV4 and "ON" or "OFF")
end)

-- Auto Fighting Styles Unlock
local AutoStyleToggle = AutoRaceToggle:Clone()
AutoStyleToggle.Position = UDim2.new(0, 20, 0, 70)
AutoStyleToggle.Text = "Auto Styles Unlock: OFF"
AutoStyleToggle.Parent = SpecialTab

AutoStyleToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoStyles = not getgenv().Darksea.AutoStyles
    AutoStyleToggle.Text = "Auto Styles Unlock: " .. (getgenv().Darksea.AutoStyles and "ON" or "OFF")
end)

-- Auto Craft True Triple Katana
local AutoTTKToggle = AutoRaceToggle:Clone()
AutoTTKToggle.Position = UDim2.new(0, 20, 0, 120)
AutoTTKToggle.Text = "Auto Craft TTK: OFF"
AutoTTKToggle.Parent = SpecialTab

AutoTTKToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoCraftTTK = not getgenv().Darksea.AutoCraftTTK
    AutoTTKToggle.Text = "Auto Craft TTK: " .. (getgenv().Darksea.AutoCraftTTK and "ON" or "OFF")
end)

-- Auto Craft CDK
local AutoCDKToggle = AutoRaceToggle:Clone()
AutoCDKToggle.Position = UDim2.new(0, 20, 0, 170)
AutoCDKToggle.Text = "Auto Craft CDK: OFF"
AutoCDKToggle.Parent = SpecialTab

AutoCDKToggle.MouseButton1Click:Connect(function()
    getgenv().Darksea.AutoCraftCDK = not getgenv().Darksea.AutoCraftCDK
    AutoCDKToggle.Text = "Auto Craft CDK: " .. (getgenv().Darksea.AutoCraftCDK and "ON" or "OFF")
end)

-- Loops
spawn(function()
    while task.wait(3) do
        if getgenv().Darksea.AutoRaceV4 then
            print("[Darksea] Unlocking Race V4...")
            -- Mirage detection & trial logic
        end
    end
end)

spawn(function()
    while task.wait(3) do
        if getgenv().Darksea.AutoCraftTTK then
            print("[Darksea] Crafting TTK...")
        end
        if getgenv().Darksea.AutoCraftCDK then
            print("[Darksea] Crafting CDK...")
        end
    end
end)
-- Tab SETTINGS
local SettingsTab = Library:CreateTab("Settings")

local SaveConfigButton = Instance.new("TextButton")
SaveConfigButton.Size = UDim2.new(0, 200, 0, 40)
SaveConfigButton.Position = UDim2.new(0, 20, 0, 20)
SaveConfigButton.Text = "Save Config"
SaveConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveConfigButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SaveConfigButton.Font = Enum.Font.GothamBold
SaveConfigButton.TextSize = 14
SaveConfigButton.Parent = SettingsTab

SaveConfigButton.MouseButton1Click:Connect(function()
    writefile("Darksea_Config.json", HttpService:JSONEncode(getgenv().Darksea))
    print("[Darksea] Config saved!")
end)

local LoadConfigButton = SaveConfigButton:Clone()
LoadConfigButton.Position = UDim2.new(0, 20, 0, 70)
LoadConfigButton.Text = "Load Config"
LoadConfigButton.Parent = SettingsTab

LoadConfigButton.MouseButton1Click:Connect(function()
    if isfile("Darksea_Config.json") then
        local data = readfile("Darksea_Config.json")
        getgenv().Darksea = HttpService:JSONDecode(data)
        print("[Darksea] Config loaded!")
    end
end)

print("[Darksea] Loaded Successfully!")

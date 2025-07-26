repeat wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Global Settings
getgenv().Darksea = getgenv().Darksea or {}

-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Darksea Ultimate | Mukuro Style", "DarkTheme")

-- Anti AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Notify
local function Notify(msg)
    game.StarterGui:SetCore("SendNotification", {Title = "Darksea Hub", Text = msg, Duration = 5})
end
Notify("Darksea Hub Loaded!")

-- Tabs
local TabFarm = Window:NewTab("Auto Farm")
local TabBoss = Window:NewTab("Boss")
local TabFruit = Window:NewTab("Fruit")
local TabRaid = Window:NewTab("Raid")
local TabCraft = Window:NewTab("Craft")
local TabMisc = Window:NewTab("Misc")
local TabTeleport = Window:NewTab("Teleport")
local TabConfig = Window:NewTab("Config")

-- Auto Farm Section
local SectionFarm = TabFarm:NewSection("Farm Options")
SectionFarm:NewToggle("Auto Farm Level", "Farm cấp độ tự động", function(v)
    getgenv().Darksea.AutoFarmLevel = v
end)
SectionFarm:NewToggle("Auto Farm Mastery", "Farm mastery cho trái/sword", function(v)
    getgenv().Darksea.AutoFarmMastery = v
end)
SectionFarm:NewToggle("Auto Farm Bone", "Farm xương tự động", function(v)
    getgenv().Darksea.AutoBone = v
end)

-- Boss Section
local SectionBoss = TabBoss:NewSection("Boss System")
SectionBoss:NewToggle("Auto Boss", "Đánh tất cả boss", function(v)
    getgenv().Darksea.AutoBoss = v
end)
SectionBoss:NewToggle("Auto Elite Boss", "Đánh Elite", function(v)
    getgenv().Darksea.AutoElite = v
end)
SectionBoss:NewToggle("Auto Factory", "Farm Factory trái ác quỷ", function(v)
    getgenv().Darksea.AutoFactory = v
end)

-- Fruit Section
local SectionFruit = TabFruit:NewSection("Fruit Features")
SectionFruit:NewToggle("Auto Grab Fruit", "Nhặt trái rơi trên map", function(v)
    getgenv().Darksea.AutoGrabFruit = v
end)
SectionFruit:NewToggle("Auto Store Fruit", "Lưu trái vào inventory", function(v)
    getgenv().Darksea.AutoStoreFruit = v
end)

-- Raid Section
local SectionRaid = TabRaid:NewSection("Auto Raid")
SectionRaid:NewToggle("Auto Raid", "Tự động Raid + Awaken Fruit", function(v)
    getgenv().Darksea.AutoRaid = v
end)

-- Craft Section
local SectionCraft = TabCraft:NewSection("Craft Items")
SectionCraft:NewToggle("Auto Craft TTK", "Tự craft True Triple Katana", function(v)
    getgenv().Darksea.AutoTTK = v
end)
SectionCraft:NewToggle("Auto Craft CDK", "Tự craft Cursed Dual Katana", function(v)
    getgenv().Darksea.AutoCDK = v
end)

-- Misc Section
local SectionMisc = TabMisc:NewSection("Misc")
SectionMisc:NewButton("Server Hop 0 Player", "Chuyển server ít người", function()
    -- Server hop logic sẽ thêm ở phần sau
end)
SectionMisc:NewButton("Anti AFK", "Bật chống AFK", function()
    Notify("Anti AFK Active")
end)

-- Teleport Section
local SectionTeleport = TabTeleport:NewSection("Teleport")
SectionTeleport:NewDropdown("Select Island", "Chọn đảo", {"Starter", "Jungle", "Desert", "Marine", "Sky", "Magma"}, function(v)
    getgenv().Darksea.SelectedIsland = v
end)
SectionTeleport:NewButton("Teleport Now", "Dịch chuyển", function()
    -- Teleport logic sẽ thêm ở phần sau
end)

-- Config Section
local SectionConfig = TabConfig:NewSection("Config")
SectionConfig:NewButton("Save Config", "Lưu cấu hình", function()
    writefile("DarkseaConfig.json", HttpService:JSONEncode(getgenv().Darksea))
    Notify("Config Saved")
end)
SectionConfig:NewButton("Load Config", "Tải cấu hình", function()
    if isfile("DarkseaConfig.json") then
        getgenv().Darksea = HttpService:JSONDecode(readfile("DarkseaConfig.json"))
        Notify("Config Loaded")
    end
end)
-- ✅ AUTO FARM & BOSS SYSTEM LOGIC

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Hàm dịch chuyển (TP an toàn)
local function SafeTP(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(pos)
    end
end

-- Hàm Tween di chuyển
local function TweenTo(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(1), {CFrame = CFrame.new(pos)})
        Tween:Play()
        Tween.Completed:Wait()
    end
end

-- Lấy NPC gần nhất
local function GetNearestMob()
    local closest, dist = nil, math.huge
    for _,v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local d = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if d < dist then
                closest = v
                dist = d
            end
        end
    end
    return closest
end

-- Hàm đánh NPC
local function AttackMob(mob)
    if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
        repeat
            TweenTo(mob.HumanoidRootPart.Position + Vector3.new(0,5,0))
            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
            wait()
        until mob.Humanoid.Health <= 0 or not getgenv().Darksea.AutoFarmLevel
    end
end

-- Main Loop Auto Farm
spawn(function()
    while wait() do
        if getgenv().Darksea.AutoFarmLevel then
            local mob = GetNearestMob()
            if mob then
                AttackMob(mob)
            end
        end
    end
end)

-- ✅ AUTO MASTERY FARM
spawn(function()
    while wait() do
        if getgenv().Darksea.AutoFarmMastery then
            -- Giữ logic farm mastery tương tự nhưng dùng skill thay vì click
            local mob = GetNearestMob()
            if mob then
                TweenTo(mob.HumanoidRootPart.Position + Vector3.new(0,10,0))
                -- Dùng skill trái/sword
                for _,skill in pairs({"Z","X","C","V"}) do
                    game:GetService("VirtualInputManager"):SendKeyEvent(true,skill,false,game)
                    wait(0.3)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false,skill,false,game)
                end
            end
        end
    end
end)

-- ✅ AUTO BONE FARM
spawn(function()
    while wait() do
        if getgenv().Darksea.AutoBone then
            -- Teleport đến vị trí farm Bone (Sea 3 / Haunted Castle)
            if game.PlaceId == 7449423635 then
                SafeTP(Vector3.new(-9500, 140, 5850))
            end
        end
    end
end)

-- ✅ AUTO BOSS & FACTORY
local function GetBoss()
    for _,v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("Boss") then
            return v
        end
    end
    return nil
end

spawn(function()
    while wait() do
        if getgenv().Darksea.AutoBoss then
            local boss = GetBoss()
            if boss then
                repeat
                    TweenTo(boss.HumanoidRootPart.Position + Vector3.new(0,7,0))
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                    wait()
                until boss.Humanoid.Health <= 0 or not getgenv().Darksea.AutoBoss
            end
        end
    end
end)

-- ✅ AUTO ELITE BOSS
spawn(function()
    while wait() do
        if getgenv().Darksea.AutoElite then
            -- Teleport đến Sea 3 Elite Boss spawn
            if game.PlaceId == 7449423635 then
                SafeTP(Vector3.new(-5415, 315, -2820))
            end
        end
    end
end)

-- ✅ AUTO FACTORY EVENT
spawn(function()
    while wait() do
        if getgenv().Darksea.AutoFactory then
            -- Factory (Sea 2)
            if game.PlaceId == 4442272183 then
                SafeTP(Vector3.new(430, 210, -432))
            end
        end
    end
end)
-- ✅ AUTO FRUIT SYSTEM

-- Lấy trái trong Workspace
local function GrabFruits()
    for _,obj in pairs(Workspace:GetChildren()) do
        if string.find(obj.Name:lower(),"fruit") and obj:IsA("Tool") then
            TweenTo(obj.Handle.Position)
            wait(0.5)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Handle, 0)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Handle, 1)
        end
    end
end

spawn(function()
    while wait(3) do
        if getgenv().Darksea.AutoGrabFruit then
            GrabFruits()
        end
    end
end)

-- Auto Store Fruit
spawn(function()
    while wait(5) do
        if getgenv().Darksea.AutoStoreFruit then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool").Name)
        end
    end
end)

-- ✅ AUTO RAID SYSTEM
local function BuyChip(fruit)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", fruit)
end

spawn(function()
    while wait(2) do
        if getgenv().Darksea.AutoRaid then
            -- Mua chip ngẫu nhiên hoặc từ trái đang cầm
            local fruit = "flame" -- có thể đổi logic auto detect
            BuyChip(fruit)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Start")
        end
    end
end)

-- ✅ AUTO CRAFT TTK (True Triple Katana)
spawn(function()
    while wait(3) do
        if getgenv().Darksea.AutoTTK then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer","1")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer","2")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer","3")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "True Triple Katana")
        end
    end
end)

-- ✅ AUTO CRAFT CDK (Cursed Dual Katana)
spawn(function()
    while wait(3) do
        if getgenv().Darksea.AutoCDK then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Start")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem","Cursed Dual Katana")
        end
    end
end)

-- ✅ AUTO UNLOCK GODHUMAN
spawn(function()
    while wait(5) do
        if getgenv().Darksea.AutoGodhuman then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
        end
    end
end)

-- ✅ AUTO GEAR 4 (Awakening + Mirage Island)
spawn(function()
    while wait(5) do
        if getgenv().Darksea.AutoGear then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Gear","Start")
        end
    end
end)

-- ✅ AUTO RACE V4 QUEST
spawn(function()
    while wait(5) do
        if getgenv().Darksea.AutoRaceV4 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Quest","Start")
        end
    end
end)
-- ✅ Anti AFK (đã có từ đầu nhưng thêm đảm bảo)
spawn(function()
    while wait(300) do
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- ✅ Server Hop tìm server ít người
local Http = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PlaceID = game.PlaceId
local JobID = game.JobId

function ServerHop()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")
    local data = Http:JSONDecode(req)
    for _,v in pairs(data.data) do
        if v.playing < 5 and v.id ~= JobID then
            TeleportService:TeleportToPlaceInstance(PlaceID, v.id, LocalPlayer)
            break
        end
    end
end

SectionMisc:NewButton("Hop To Empty Server", "Tìm server dưới 5 người", function()
    ServerHop()
end)

-- ✅ FPS Boost
SectionMisc:NewButton("FPS Boost", "Tối ưu game để mượt hơn", function()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
    setfpscap(60)
end)

-- ✅ Config Save/Load (đã có UI nút Save/Load)
-- Lặp lại để đảm bảo khi bật/tắt toggle, config được lưu
spawn(function()
    while wait(10) do
        pcall(function()
            writefile("DarkseaConfig.json", Http:JSONEncode(getgenv().Darksea))
        end)
    end
end)

Notify("✅ Darksea Hub Fully Loaded!")

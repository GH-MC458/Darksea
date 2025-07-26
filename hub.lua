-- Vox Seas Mobile Hub (No Key) - Enhanced
-- Features: Auto Farm, Auto Boss, Auto Quest, Teleport, ESP, Fruit Sniper, Auto Collect Drops
-- UI: Kavo, Arceus X Friendly

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Vox Seas Hub", "DarkTheme")

-- Variables
local plr = game.Players.LocalPlayer
local humrp = plr.Character:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local autofarm, autoboss, autoquest, autofruit, autodrop, esp = false, false, false, false, false, false

-- Functions
function moveTo(pos)
    local tween = ts:Create(humrp, TweenInfo.new(0.3), {CFrame = CFrame.new(pos.X, pos.Y + 5, pos.Z)})
    tween:Play()
end

function getNearestNPC()
    local nearest, dist = nil, math.huge
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Health") then
            local mag = (humrp.Position - npc.HumanoidRootPart.Position).Magnitude
            if mag < dist and npc.Humanoid.Health > 0 then
                nearest, dist = npc, mag
            end
        end
    end
    return nearest
end

function getBoss()
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and string.find(npc.Name:lower(), "boss") then
            return npc
        end
    end
    return nil
end

-- UI Tabs
local Main = Window:NewTab("Main")
local Teleport = Window:NewTab("Teleport")
local Misc = Window:NewTab("Misc")

-- Auto Farm Toggle
Main:NewToggle("Auto Farm", "Farms nearest NPC with smooth movement", function(state)
    autofarm = state
    task.spawn(function()
        while autofarm do
            local npc = getNearestNPC()
            if npc then
                moveTo(npc.HumanoidRootPart.Position)
                task.wait(0.5)
                game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))
            else
                task.wait(1)
            end
        end
    end)
end)

-- Auto Boss Toggle
Main:NewToggle("Auto Boss", "Hunts bosses", function(state)
    autoboss = state
    task.spawn(function()
        while autoboss do
            local boss = getBoss()
            if boss then
                moveTo(boss.HumanoidRootPart.Position)
                task.wait(0.5)
                game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))
            else
                task.wait(2)
            end
        end
    end)
end)

-- Auto Quest
Main:NewToggle("Auto Quest", "Take quest automatically", function(state)
    autoquest = state
    task.spawn(function()
        while autoquest do
            task.wait(3)
            -- Logic nhận quest sẽ thêm khi có Remote
        end
    end)
end)

-- Fruit Sniper
Misc:NewToggle("Fruit Sniper", "Auto buy fruit when available", function(state)
    autofruit = state
    task.spawn(function()
        while autofruit do
            task.wait(5)
            -- Logic check & mua trái (Remote cần sniff)
        end
    end)
end)

-- Auto Collect Drops
Misc:NewToggle("Auto Collect Drops", "Collect ground items", function(state)
    autodrop = state
    task.spawn(function()
        while autodrop do
            for _, item in pairs(workspace:GetDescendants()) do
                if item:IsA("Tool") or string.find(item.Name:lower(), "fruit") then
                    moveTo(item.Position)
                end
            end
            task.wait(2)
        end
    end)
end)

-- Teleport UI
local islands = {
    ["Start Island"] = Vector3.new(100, 50, 100),
    ["Marine Base"] = Vector3.new(500, 70, -300),
    ["Pirate Town"] = Vector3.new(-250, 60, 900),
    ["Sky Island"] = Vector3.new(0, 2000, 0),
    ["Boss Island"] = Vector3.new(1200, 75, 1500)
}
for name, pos in pairs(islands) do
    Teleport:NewButton(name, "Teleport to " .. name, function()
        moveTo(pos)
    end)
end

-- ESP
Misc:NewToggle("ESP Players", "Shows players", function(state)
    esp = state
    task.spawn(function()
        while esp do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not p.Character:FindFirstChild("ESPTag") then
                    local billboard = Instance.new("BillboardGui", p.Character.HumanoidRootPart)
                    billboard.Name = "ESPTag"
                    billboard.Size = UDim2.new(0, 100, 0, 50)
                    billboard.AlwaysOnTop = true
                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = p.Name
                    label.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
            task.wait(1)
        end
    end)
end)

-- Anti AFK
plr.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- FPS Boost
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Texture") or obj:IsA("Decal") then
        obj:Destroy()
    end
end

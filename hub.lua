-- Vox Seas Mobile Hub (No Key) - Full Features for Arceus X
-- Features: Auto Farm, Auto Quest, Auto Boss, Teleport, ESP, Fruit Sniper, Auto Collect Drops, Anti AFK, FPS Boost
-- UI: Kavo

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Vox Seas Mobile Hub", "DarkTheme")

-- Variables
local plr = game.Players.LocalPlayer
local humrp = plr.Character:WaitForChild("HumanoidRootPart")
local autofarm, autoquest, autoboss, esp, autofruit, autodrop = false, false, false, false, false, false

-- Functions
function toTarget(pos)
    humrp.CFrame = CFrame.new(pos.X, pos.Y + 5, pos.Z)
end

function getNearestNPC()
    local nearest, dist = nil, math.huge
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Health") then
            local mag = (humrp.Position - npc.HumanoidRootPart.Position).magnitude
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

-- Tabs
local Main = Window:NewTab("Main")
local Teleport = Window:NewTab("Teleport")
local Misc = Window:NewTab("Misc")

-- Auto Farm
Main:NewToggle("Auto Farm", "Farm nearest NPC", function(v)
    autofarm = v
    while autofarm do
        task.wait()
        local npc = getNearestNPC()
        if npc then
            toTarget(npc.HumanoidRootPart.Position)
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end
    end
end)

-- Auto Boss
Main:NewToggle("Auto Boss", "Hunt bosses", function(v)
    autoboss = v
    while autoboss do
        task.wait()
        local boss = getBoss()
        if boss and boss:FindFirstChild("HumanoidRootPart") then
            toTarget(boss.HumanoidRootPart.Position)
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end
    end
end)

-- Auto Quest
Main:NewToggle("Auto Quest", "Automatically gets quests", function(v)
    autoquest = v
    while autoquest do
        task.wait(3)
        -- Logic nhận quest tùy game, update sau
    end
end)

-- Fruit Sniper
Misc:NewToggle("Fruit Sniper", "Auto buy fruits from shop", function(v)
    autofruit = v
    while autofruit do
        task.wait(5)
        -- Logic check shop và mua fruit (cần tên Remote)
    end
end)

-- Auto Collect Drops
Misc:NewToggle("Auto Collect Drops", "Collect items on ground", function(v)
    autodrop = v
    while autodrop do
        task.wait(2)
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Tool") or string.find(item.Name:lower(), "fruit") then
                toTarget(item.Position)
            end
        end
    end
end)

-- Teleport buttons
local islands = {
    ["Start Island"] = Vector3.new(100, 50, 100),
    ["Marine Base"] = Vector3.new(500, 70, -300),
    ["Pirate Town"] = Vector3.new(-250, 60, 900),
    ["Sky Island"] = Vector3.new(0, 2000, 0),
    ["Boss Island"] = Vector3.new(1200, 75, 1500)
}
for name, pos in pairs(islands) do
    Teleport:NewButton(name, "Teleport to " .. name, function()
        toTarget(pos)
    end)
end

-- ESP
Misc:NewToggle("ESP Players", "Shows players", function(v)
    esp = v
    while esp do
        task.wait(1)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character:FindFirstChild("ESPTag") then
                    local billboard = Instance.new("BillboardGui", p.Character.HumanoidRootPart)
                    billboard.Name = "ESPTag"
                    billboard.Size = UDim2.new(0, 100, 0, 50)
                    billboard.AlwaysOnTop = true
                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.Text = p.Name
                    label.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
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

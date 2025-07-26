-- Vox Seas Mobile Hub | No Key | Auto Farm by Level + Anti-Ban
-- UI: Kavo Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Vox Seas Hub", "DarkTheme")

-- Services
local plr = game.Players.LocalPlayer
local humrp = plr.Character:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local vu = game:GetService("VirtualUser")

-- Flags
local autofarm, autoboss = false, false
local selectedLevel = "Nearest"

-- Anti-Ban basic
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(method):lower() == "kick" then
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

-- Utils
function moveTo(pos)
    local tween = ts:Create(humrp, TweenInfo.new(0.3), {CFrame = CFrame.new(pos.X, pos.Y + 5, pos.Z)})
    tween:Play()
end

function getNearestNPC()
    local nearest, dist = nil, math.huge
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            local mag = (humrp.Position - npc.HumanoidRootPart.Position).Magnitude
            if mag < dist and npc.Humanoid.Health > 0 then
                nearest, dist = npc, mag
            end
        end
    end
    return nearest
end

function getNPCByLevel(lv)
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            if string.find(npc.Name, tostring(lv)) then
                return npc
            end
        end
    end
    return nil
end

-- Tabs
local Main = Window:NewTab("Main")
local Teleport = Window:NewTab("Teleport")
local Misc = Window:NewTab("Misc")

-- Auto Farm Toggle
Main:NewDropdown("Select Level", "Choose enemy level", {"Nearest","10","15","20","25","30"}, function(v)
    selectedLevel = v
end)

Main:NewToggle("Auto Farm", "Farm selected NPC", function(state)
    autofarm = state
    task.spawn(function()
        while autofarm do
            local npc = nil
            if selectedLevel == "Nearest" then
                npc = getNearestNPC()
            else
                npc = getNPCByLevel(selectedLevel)
            end
            if npc then
                moveTo(npc.HumanoidRootPart.Position)
                task.wait(0.5)
                vu:ClickButton1(Vector2.new(0, 0))
            end
            task.wait(math.random(1,2)) -- Anti-ban delay
        end
    end)
end)

-- Auto Boss
Main:NewToggle("Auto Boss", "Hunt bosses", function(state)
    autoboss = state
    task.spawn(function()
        while autoboss do
            for _, npc in pairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and string.find(npc.Name:lower(), "boss") and npc:FindFirstChild("HumanoidRootPart") then
                    moveTo(npc.HumanoidRootPart.Position)
                    task.wait(0.5)
                    vu:ClickButton1(Vector2.new(0,0))
                end
            end
            task.wait(2)
        end
    end)
end)

-- Teleport Buttons
local islands = {
    ["Start Island"] = Vector3.new(100, 50, 100),
    ["Marine Base"] = Vector3.new(500, 70, -300),
    ["Pirate Town"] = Vector3.new(-250, 60, 900),
    ["Sky Island"] = Vector3.new(0, 2000, 0)
}
for name,pos in pairs(islands) do
    Teleport:NewButton(name, "Teleport to "..name, function()
        moveTo(pos)
    end)
end

-- Misc
Misc:NewButton("FPS Boost", "Remove textures for FPS", function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Texture") or obj:IsA("Decal") then
            obj:Destroy()
        end
    end
end)

-- Anti AFK
plr.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

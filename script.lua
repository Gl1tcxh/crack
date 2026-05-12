-- =============================================
-- Blox Fruits Ultra Hub - By Sacha
-- STRONGER AUTO FARM v2
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Root = LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart")

local Settings = {
    AutoFarm = false,
    FarmMethod = "Level",        -- Level, Mastery
    AutoQuest = true,
    FastAttack = true,
    Godmode = true,
    AutoBuddha = false,
    FarmDistance = 80,
}

-- ==================== STRONGER AUTO FARM ====================
local FarmTab = MainWindow:CreateTab("Auto Farm", 4483362458)   -- Assuming MainWindow exists

FarmTab:CreateLabel("🚀 Strong Auto Farm (Improved)")

FarmTab:CreateToggle({
    Name = "Auto Farm (Main)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoFarm = v end
})

FarmTab:CreateDropdown({
    Name = "Farm Method",
    Options = {"Level (Quest)", "Mastery"},
    CurrentOption = {"Level (Quest)"},
    Callback = function(opt) Settings.FarmMethod = opt[1] end
})

FarmTab:CreateToggle({Name = "Auto Quest", CurrentValue = true, Callback = function(v) Settings.AutoQuest = v end})
FarmTab:CreateToggle({Name = "Fast Attack", CurrentValue = true, Callback = function(v) Settings.FastAttack = v end})
FarmTab:CreateToggle({Name = "Auto Buddha Transform", CurrentValue = false, Callback = function(v) Settings.AutoBuddha = v end})
FarmTab:CreateSlider({Name = "Farm Distance", Range = {30, 120}, Increment = 5, CurrentValue = 80, Callback = function(v) Settings.FarmDistance = v end})

-- ====================== STRONG AUTO FARM LOOP ======================
spawn(function()
    while task.wait(0.15) do
        if not Settings.AutoFarm or not Root then continue end

        -- Auto Buddha
        if Settings.AutoBuddha then
            pcall(function()
                local fruit = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if fruit and fruit.Name:find("Buddha") then
                    fruit:Activate()
                end
            end)
        end

        local bestTarget = nil
        local bestScore = 0

        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local distance = (Root.Position - enemy.HumanoidRootPart.Position).Magnitude
                
                if distance < Settings.FarmDistance then
                    local score = 1000 - distance + (enemy.Humanoid.Health / 1000)
                    if score > bestScore then
                        bestScore = score
                        bestTarget = enemy
                    end
                end
            end
        end

        if bestTarget then
            -- Move to target smoothly
            local targetCFrame = bestTarget.HumanoidRootPart.CFrame * CFrame.new(0, 8, 6)
            
            pcall(function()
                Root.CFrame = Root.CFrame:Lerp(targetCFrame, 0.6)
            end)

            -- Fast Attack
            if Settings.FastAttack then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end)
            end
        end
    end
end)

-- Auto Quest (Basic)
spawn(function()
    while task.wait(8) do
        if Settings.AutoQuest and Settings.AutoFarm then
            pcall(function()
                local comm = ReplicatedStorage:FindFirstChild("CommF_")
                if comm then
                    comm:FireServer("AbandonQuest")
                    wait(0.5)
                    comm:FireServer("StartQuest", "BanditQuest1", 1) -- Change quest as needed
                end
            end)
        end
    end
end)

print("✅ Stronger Auto Farm Loaded!")

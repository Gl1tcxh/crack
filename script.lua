-- Blox Fruits Advanced Auto Farm + Quest System
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    AutoFarm = true,
    AutoQuest = true,
    AutoTTK = false,
    AutoSnipe = true,
    AutoCollect = true,
    AutoStore = true,
    MinFruitRarity = "Legendary",
}

print("✅ Advanced Auto Farm Loaded")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits - Advanced Auto Farm",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Grok",
})

-- ==================== MAIN TAB ====================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({Name = "Auto Farm (Leveling)", CurrentValue = true, Callback = function(v) Settings.AutoFarm = v end})
MainTab:CreateToggle({Name = "Auto Quest", CurrentValue = true, Callback = function(v) Settings.AutoQuest = v end})
MainTab:CreateToggle({Name = "Auto Fruit Snipe", CurrentValue = true, Callback = function(v) Settings.AutoSnipe = v end})
MainTab:CreateToggle({Name = "Auto Collect Fruit", CurrentValue = true, Callback = function(v) Settings.AutoCollect = v end})
MainTab:CreateToggle({Name = "Auto Store Fruit", CurrentValue = true, Callback = function(v) Settings.AutoStore = v end})

-- ==================== QUEST TAB ====================
local QuestTab = Window:CreateTab("Quests", 4483362458)

QuestTab:CreateToggle({
    Name = "Auto TTK Quest (Time To Kill)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTTK = v end
})

QuestTab:CreateLabel("Auto TTK will complete current quest automatically")

-- Auto Quest System
local function AutoQuestSystem()
    if not Settings.AutoQuest then return end
    pcall(function()
        local questData = ReplicatedStorage.Remotes.CommF_:InvokeServer("PlayerQuestProgress")
        
        if questData and questData[1] then
            -- Accept / Continue current quest
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData[1].QuestName, questData[1].QuestId)
        else
            -- Look for new quest based on level
            local level = LocalPlayer.Data.Level.Value
            if level < 10 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
            elseif level < 20 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "JungleQuest", 1)
            -- Add more quests as needed
            end
        end
    end)
end

-- Auto TTK Quest
local function AutoTTK()
    if not Settings.AutoTTK then return end
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("CompleteQuest")
    end)
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    AutoQuestSystem()
    AutoTTK()
    
    -- Auto Store
    if Settings.AutoStore then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", "all")
        end)
    end
end)

print("Press Right Shift to open menu")
print("Auto Quest + Auto TTK is ready")

-- MM93 Game Script for Untitled Zombie Gaem

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Load GUI
local GUI = require(PlayerGui:WaitForChild("MM93"))
local gui = GUI:CreateGui("MM93 Hub")

-- Button/Toggles index
local idx = 1

-- Utility function to safely fire a remote
local function safeFire(name, ...)
    local r = ReplicatedStorage:FindFirstChild(name)
    if r and r:IsA("RemoteEvent") then
        r:FireServer(...)
        return true
    elseif r and r:IsA("RemoteFunction") then
        local ok,res = pcall(function() return r:InvokeServer(...) end)
        if not ok then warn(res) end
        return ok
    else
        warn("Remote "..tostring(name).." not found")
        return false
    end
end

-- Feature functions
local function equipCommonWeapons()
    local names = {"Katana","Machete","Wooden Bat","Crowbar","Hatchet","Bat"}
    for _, n in ipairs(names) do
        local tool = LocalPlayer.Backpack:FindFirstChild(n) or LocalPlayer.Character:FindFirstChild(n)
        if tool and tool:IsA("Tool") then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end

local function grabChargedBat() safeFire("GrabWeapon","ChargedBat") end
local function grabFireKatana() safeFire("GrabWeapon","FireKatana") end
local function spawnCookie() safeFire("SpawnItem",12345678) end

local infiniteStam = false
local function setInfiniteStamina(state) infiniteStam = state end

local opSprint = false
local normalSpeed = 16
local sprintSpeed = 28
local function setOpSprint(state)
    opSprint = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if state then
            normalSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
            LocalPlayer.Character.Humanoid.WalkSpeed = sprintSpeed
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = normalSpeed
        end
    end
end

local killAura = false
local function toggleKillAura(state)
    killAura = state
    if state then
        spawn(function()
            while killAura do
                local char = LocalPlayer.Character
                if char and char.PrimaryPart then
                    local pos = char.PrimaryPart.Position
                    for _, pl in ipairs(Players:GetPlayers()) do
                        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("Humanoid") and pl.Character.PrimaryPart then
                            local dist = (pl.Character.PrimaryPart.Position - pos).Magnitude
                            if dist <= 12 then
                                safeFire("DamageRemote",pl,20)
                            end
                        end
                    end
                end
                wait(0.3)
            end
        end)
    end
end

local function removeBarriers()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name:lower(),"barrier") then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function changeTeam(team)
    safeFire("ChangeTeam",team)
end

-- Buttons / toggles
gui:Button(idx,"Equip Common Weapons",equipCommonWeapons) idx=idx+1
gui:Button(idx,"Grab Charged Bat",grabChargedBat) idx=idx+1
gui:Button(idx,"Grab Fire Katana",grabFireKatana) idx=idx+1
gui:Button(idx,"Spawn Cookie",spawnCookie) idx=idx+1
gui:Toggle(idx,"Infinite Stamina",false,setInfiniteStamina) idx=idx+1
gui:Toggle(idx,"OP Sprint",false,setOpSprint) idx=idx+1
gui:Button(idx,"Remove Barriers",removeBarriers) idx=idx+1
gui:Button(idx,"Become Human",function() changeTeam("Human") end) idx=idx+1
gui:Button(idx,"Become Zombie",function() changeTeam("Zombie") end) idx=idx+1
gui:Toggle(idx,"Kill Aura",false,toggleKillAura) idx=idx+1
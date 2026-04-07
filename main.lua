--// Game SERVICES \\--

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")
local TS = game:GetService("TweenService")

--// Tool \\--

local Tool = script.Parent
local Handle = Tool.Handle

--// Extra \\--

local Animations = RS:WaitForChild("Animations")
local Modules = RS:WaitForChild("Modules")
local Remotes = RS:WaitForChild("Remotes")

local anims = Animations:FindFirstChild("Type"):GetChildren() -- should be 4 there

--// Attribute \\--

local Damage = Tool:GetAttribute("Damage")
local Cooldown = Tool:GetAttribute("Cooldown")
local combo = Tool:GetAttribute("Combo")
local Type = Tool:GetAttribute("Type")

--// FUNCTIONS \\--

local function getAnimation(char, animation)
    
    for i = 1, #anims, 1 in pairs(anims) do
        local humanoid = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChild("Humanoid")
        local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:FindFirstChild("Animator")

        if not animator then
            local newAnimator = Instance.new("Animator", humanoid)
            newAnimator.Name = "Animator"
        end

        animation = i[combo]
        
        local animTrack = animator:LoadAnimation(animation)

        animTrack:Play()
    end
    
end

--// SCRIPT \\--

Tool.Equipped:Connect(function()
    local Character = Tool.Parent
    local Player = Players:GetPlayerFromCharacter(Character)
    
    Handle.Touched:Connect(function(hit)
        if hit.Parent:IsA("Model") then
            local eCharacter = hit.Parent:IsA("Model") or hit.Parent
            local eHumanoid = eCharacter:FindFirstChildOfClass("Humanoid") or eCharacter:FindFirstChild("Humanoid")
            local ehumRp = eCharacter:FindFirstChild("HumanoidRootPart")
            
            getAnimation(Character, anims[combo])
        end
    end)
end)


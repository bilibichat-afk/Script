-- ULTIMATE ANTI-SLAP & GOD MODE GUI
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local playerGui = player:WaitForChild("PlayerGui")

-- 1. GIAO DIỆN (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateDefense"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 220)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🛡️ ULTIMATE DEFENSE"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- Các nút bấm
local function createButton(name, text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 210, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    return btn
end

local antiSlapBtn = createButton("AntiSlap", "ANTI-SLAP: OFF", UDim2.new(0, 20, 0, 50), Color3.fromRGB(70, 70, 70))
local stoneModeBtn = createButton("StoneMode", "CHẾ ĐỘ KHỐI ĐÁ: OFF", UDim2.new(0, 20, 0, 100), Color3.fromRGB(70, 70, 70))
local godModeBtn = createButton("GodMode", "GOD MODE (BẤT TỬ): OFF", UDim2.new(0, 20, 0, 150), Color3.fromRGB(70, 70, 70))

-- Nút thu nhỏ
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "—"
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = mainFrame

local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.new(0, 50, 0, 50)
miniIcon.Position = UDim2.new(0, 20, 0.5, -25)
miniIcon.Text = "🛡️"
miniIcon.Visible = false
miniIcon.Draggable = true
miniIcon.Parent = screenGui
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1, 0)

-- 2. BIẾN TRẠNG THÁI
local antiSlapActive = false
local stoneModeActive = false
local godModeActive = false
local stonePart = nil

-- 3. LOGIC XỬ LÝ

-- Anti-Slap: Đứng im khi bị đánh nhưng vẫn di chuyển được
runService.Heartbeat:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        
        if antiSlapActive and not stoneModeActive then
            -- Nếu vận tốc do bị tát (không phải do mình di chuyển) thì triệt tiêu
            if hrp.Velocity.Magnitude > 20 then 
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
            -- Chống ngã
            char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        
        -- God Mode: Liên tục hồi máu và chống chết
        if godModeActive then
            char.Humanoid.Health = char.Humanoid.MaxHealth
            if char.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                char.Humanoid.Health = char.Humanoid.MaxHealth
            end
        end
    end
end)

-- Chế độ Khối Đá
local function toggleStoneMode()
    stoneModeActive = not stoneModeActive
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if stoneModeActive then
        stoneModeBtn.Text = "CHẾ ĐỘ KHỐI ĐÁ: ON"
        stoneModeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
        
        -- Tạo khối đá bao quanh
        stonePart = Instance.new("Part")
        stonePart.Size = Vector3.new(5, 5, 5)
        stonePart.CFrame = hrp.CFrame
        stonePart.Material = Enum.Material.Slate
        stonePart.Color = Color3.fromRGB(100, 100, 100)
        stonePart.Anchored = true -- Không thể di chuyển
        stonePart.Parent = char
        
        -- Làm nhân vật tàng hình tạm thời để chỉ thấy khối đá
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.Transparency = 1 end
            if v:IsA("Accessory") then v.Handle.Transparency = 1 end
        end
        hrp.Anchored = true
    else
        stoneModeBtn.Text = "CHẾ ĐỘ KHỐI ĐÁ: OFF"
        stoneModeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        if stonePart then stonePart:Destroy() end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.Transparency = 0 end
            if v:IsA("Accessory") then v.Handle.Transparency = 0 end
        end
        hrp.Anchored = false
    end
end

-- Gán sự kiện cho nút
antiSlapBtn.MouseButton1Click:Connect(function()
    antiSlapActive = not antiSlapActive
    antiSlapBtn.Text = antiSlapActive and "ANTI-SLAP: ON" or "ANTI-SLAP: OFF"
    antiSlapBtn.BackgroundColor3 = antiSlapActive and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(70, 70, 70)
end)

stoneModeBtn.MouseButton1Click:Connect(toggleStoneMode)

godModeBtn.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    godModeBtn.Text = godModeActive and "GOD MODE: ON" or "GOD MODE: OFF"
    godModeBtn.BackgroundColor3 = godModeActive and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(70, 70, 70)
end)

closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false miniIcon.Visible = true end)
miniIcon.MouseButton1Click:Connect(function() mainFrame.Visible = true miniIcon.Visible = false end)

print("Ultimate Defense Loaded!")

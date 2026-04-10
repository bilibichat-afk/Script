-- Roblox Anti-Slap GUI Script (Có nút Bật/Tắt rõ ràng)
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")

-- 1. TẠO GIAO DIỆN (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiSlapV2"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Khung Menu Chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 160)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Kéo di chuyển được
mainFrame.Parent = screenGui

-- Bo góc cho Menu
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🛡️ ANTI-SLAP V2"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- NÚT BẬT/TẮT (ĐÂY LÀ NÚT BẠN CẦN)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 180, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -90, 0.5, -10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Mặc định màu đỏ (Tắt)
toggleBtn.Text = "TRẠNG THÁI: TẮT"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- Nút Thu nhỏ (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.Text = "—"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = mainFrame

-- Biểu tượng nhỏ khi thu nhỏ
local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.new(0, 50, 0, 50)
miniIcon.Position = UDim2.new(0, 20, 0.5, -25)
miniIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
miniIcon.Text = "🛡️"
miniIcon.TextSize = 25
miniIcon.Visible = false
miniIcon.Draggable = true
miniIcon.Parent = screenGui
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1, 0)

-- 2. LOGIC XỬ LÝ
local isEnabled = false

-- Xử lý nút Bật/Tắt
toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        toggleBtn.Text = "TRẠNG THÁI: ĐANG BẬT"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Đổi sang màu xanh
        print("Anti-Slap đã BẬT")
    else
        toggleBtn.Text = "TRẠNG THÁI: TẮT"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Đổi sang màu đỏ
        print("Anti-Slap đã TẮT")
    end
end)

-- Thu nhỏ/Mở lại
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniIcon.Visible = true
end)

miniIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniIcon.Visible = false
end)

-- 3. TÍNH NĂNG CHỐNG TÁT (Chỉ chạy khi isEnabled = true)
runService.Heartbeat:Connect(function()
    if isEnabled then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            -- Nếu bị tát văng (vận tốc > 5), triệt tiêu lực ngay
            if hrp.Velocity.Magnitude > 5 then
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
            -- Chống bị ngã (Ragdoll)
            if char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

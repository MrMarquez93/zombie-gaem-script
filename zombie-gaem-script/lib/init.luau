-- MM93 GUI Library
-- Returns a simple table to create buttons and toggles

local GUI = {}

function GUI:CreateGui(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MM93"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 360, 0, 420)
    MainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1,0,0,28)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = Color3.new(1,1,1)
    TitleLabel.Parent = MainFrame

    local module = {}
    local toggleStates = {}
    local idxOffset = 0

    function module:Button(y, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 160, 0, 30)
        btn.Position = UDim2.new(0, 12 + ((y-1) % 2) * 172, 0, 36 + math.floor((y-1)/2)*36)
        btn.Text = text
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        btn.BorderSizePixel = 0
        btn.Parent = MainFrame
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    function module:Toggle(y, text, default, callback)
        toggleStates[text] = default
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 160, 0, 30)
        btn.Position = UDim2.new(0, 12 + ((y-1) % 2) * 172, 0, 36 + math.floor((y-1)/2)*36)
        btn.Text = text .. ": " .. (default and "ON" or "OFF")
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
        btn.BorderSizePixel = 0
        btn.Parent = MainFrame
        btn.MouseButton1Click:Connect(function()
            toggleStates[text] = not toggleStates[text]
            btn.Text = text .. ": " .. (toggleStates[text] and "ON" or "OFF")
            callback(toggleStates[text])
        end)
        return btn
    end

    return module
end

return GUI
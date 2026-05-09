local function add(frame)
    if frame:IsA("Frame") then
        local button = frame:FindFirstChild("TextButton")
        if button then
            button.Text = frame.Name
        else
            local a = Instance.new("TextButton")
            a.Name = "TextButton"
            a.Text = frame.Name
            a.BackgroundTransparency = 1
            a.Size = UDim2.new(1, 0, 0, 20)
            a.ZIndex = 20
            a.TextColor3 = Color3.new(0, 1, 0)
            a.TextStrokeTransparency = 0.5
            a.TextSize = 14
            a.Parent = frame
            a.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(a.Text)
                else
                    warn("setclipboard function is not available.")
                end
            end)
        end
    end
end

-- Обновление кнопок каждую секунду
while task.wait(1) do
    local success, err = pcall(function()
        local pets = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            :WaitForChild("Inventory")
            :WaitForChild("Frame")
            :WaitForChild("Pets")

        for _, v in pairs(pets:GetChildren()) do
            add(v)
        end
    end)

    if not success then
        warn("Ошибка: ", err)
    end
end

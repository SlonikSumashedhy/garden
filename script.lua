-- Инжект через Synapse/Krnl/Fluxus
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Инициализация GUI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
    Name = "Steal a Brainrot GOD",
    LoadingTitle = "RagnarekUA Tools",
    LoadingSubtitle = "v1.6 Ultimate",
    ConfigurationSaving = { Enabled = false }
})

-- Функция 1: Телепорт к дорогому Brainrot
local function LargestTP()
    local maxValue = 0
    local targetBrainrot = nil
    
    -- Поиск самого дорогого Brainrot на чужих базах
    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        if plot.Owner.Value ~= Player.UserId then
            for _, brainrot in ipairs(plot:GetChildren()) do
                if brainrot.Name == "Brainrot" and brainrot:FindFirstChild("Value") then
                    if brainrot.Value.Value > maxValue then
                        maxValue = brainrot.Value.Value
                        targetBrainrot = brainrot
                    end
                end
            end
        end
    end
    
    if targetBrainrot then
        Player.Character.HumanoidRootPart.CFrame = targetBrainrot.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        Rayfield:Notify({ Title = "Успех", Content = "Телепорт к Brainrot за $"..maxValue, Duration = 3 })
    else
        Rayfield:Notify({ Title = "Ошибка", Content = "Дорогие Brainrot не найдены", Duration = 3 })
    end
end

-- Функция 2: Мгновенный телепорт на базу с украденным Brainrot
local function InstantBaseTP()
    local myPlot = nil
    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        if plot.Owner.Value == Player.UserId then
            myPlot = plot
            break
        end
    end
    
    if myPlot then
        local dropPoint = myPlot:FindFirstChild("DropPoint") or myPlot:FindFirstChild("Spawn")
        if dropPoint then
            Player.Character.HumanoidRootPart.CFrame = dropPoint.CFrame * CFrame.new(0, 5, 0)
        else
            Player.Character.HumanoidRootPart.CFrame = myPlot:GetModelCFrame() * CFrame.new(0, 10, 0)
        end
        Rayfield:Notify({ Title = "Телепорт", Content = "Возврат на базу с добычей", Duration = 2 })
    end
end

-- Функция 3: Регулировка скорости
local function SetSpeed(value)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = value
        Rayfield:Notify({ Title = "Скорость", Content = "Установлено: "..value.." stud/s", Duration = 2 })
    end
end

-- Интерфейс
local MainTab = Window:CreateTab("Главная", 6022668998)
MainTab:CreateButton({
    Title = "LargestTP",
    Description = "Телепорт к самому дорогому Brainrot",
    Callback = LargestTP
})

MainTab:CreateButton({
    Title = "Instant Teleport",
    Description = "Возврат на базу с добычей",
    Callback = InstantBaseTP
})

MainTab:CreateSlider({
    Title = "Скорость передвижения",
    Description = "Текущее значение: 16",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = SetSpeed
})

-- Анти-античит
local function BypassAC()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        if string.find(tostring(args[1]), "SecurityCheck") then
            return true
        end
        return oldNamecall(...)
    end)
end

task.spawn(BypassAC)
Rayfield:LoadConfiguration()

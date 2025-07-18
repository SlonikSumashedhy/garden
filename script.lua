-- Grow a Garden GOD MODE v1.5 (Universal)
-- by RagnarekUA | Fullmode Activated
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Marketplace = game:GetService("MarketplaceService")

-- Конфигурация
local Settings = {
    MaxShekels = 1e12, -- Триллион шекелей
    TeleportSpeed = 0.5,
    AutoSellDelay = 0.2,
    AutoBuyDelay = 0.3
}

-- Взлом валюты
local function DupeShekels()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    
    -- Инъекция в сетевой обработчик
    local oldInvoke = remotes.ServerInvoke
    remotes.ServerInvoke = newcclosure(function(...)
        local args = {...}
        if string.find(tostring(args[1]), "Currency") then
            return Settings.MaxShekels
        end
        return oldInvoke(...)
    end)

    -- Форсированная синхронизация
    task.spawn(function()
        while task.wait(5) do
            fireclickdetector(workspace:WaitForChild("CurrencySync"):FindFirstChild("ClickDetector"))
        end
    end)
end

-- Автовыдача любых семян
local function GiveSeed(seedId)
    local seedData = {
        ["SeedId"] = seedId,
        ["Owner"] = Player.UserId,
        ["Timestamp"] = os.time()
    }
    
    game:GetService("ReplicatedStorage").Remotes.InventoryAddItem:FireServer(
        "Seeds",
        seedData
    )
end

-- Автопокупка
local function AutoBuy()
    local shop = workspace:WaitForChild("SeedShop")
    for _, item in pairs(shop:GetChildren()) do
        if item:FindFirstChild("ClickDetector") then
            for i = 1, 50 do -- Покупаем 50 единиц
                fireclickdetector(item.ClickDetector)
                task.wait(Settings.AutoBuyDelay)
            end
        end
    end
end

-- Автопродажа
local function AutoSell()
    local sellZone = workspace:WaitForChild("SellArea")
    Player.Character.HumanoidRootPart.CFrame = sellZone.CFrame
    
    for _, plant in pairs(workspace:WaitForChild("Plants"):GetChildren()) do
        if plant:FindFirstChild("PlantModel") then
            firetouchinterest(Player.Character.HumanoidRootPart, plant.PlantModel, 0)
            firetouchinterest(Player.Character.HumanoidRootPart, plant.PlantModel, 1)
            task.wait(Settings.AutoSellDelay)
        end
    end
end

-- Телепорт к магазинам
local function TeleportTo(target)
    local locations = {
        ["SeedShop"] = CFrame.new(25.3, 0.5, -45.2),
        ["GearShop"] = CFrame.new(-18.7, 0.5, 62.4)
    }
    
    local tween = TweenService:Create(
        Player.Character.HumanoidRootPart,
        TweenInfo.new(Settings.TeleportSpeed, Enum.EasingStyle.Quad),
        {CFrame = locations[target]}
    )
    tween:Play()
end

-- UI Library (Rayfield Modern)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
    Name = "Grow a Garden GOD MODE",
    LoadingTitle = "RagnarekUA Injector",
    LoadingSubtitle = "Fullmode Activated",
    ConfigurationSaving = {Enabled = false}
})

-- Генератор семян
local SeedDB = {}
for i = 1, 500 do 
    table.insert(SeedDB, "Seed_"..tostring(i))
end

-- Основной интерфейс
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Currency Control")
MainTab:CreateButton({
    Title = "Дюп Шекелей",
    Description = "Триллионы за секунду",
    Callback = DupeShekels
})

MainTab:CreateSlider({
    Title = "Сумма шекелей",
    Description = "Точное значение",
    Min = 1e6,
    Max = 1e12,
    Callback = function(value)
        Settings.MaxShekels = value
    end
})

-- Система семян
local SeedsTab = Window:CreateTab("Seeds", 7733960981)
SeedsTab:CreateDropdown({
    Title = "Выдать семя",
    Description = "Все существующие ID",
    Options = SeedDB,
    Callback = function(option)
        GiveSeed(option)
    end
})

SeedsTab:CreateToggle({
    Title = "Автовыдача новых семян",
    Description = "При появлении в датасете",
    Callback = function(state)
        _G.AutoNewSeeds = state
        while _G.AutoNewSeeds do
            GiveSeed("Seed_"..tostring(math.random(450,500)))
            task.wait(1)
        end
    end
})

-- Автоматизация
local AutoTab = Window:CreateTab("Automation", 9753762467)
AutoTab:CreateToggle({
    Title = "Автопокупка",
    Description = "Скупает весь магазин",
    Callback = function(state)
        _G.AutoBuy = state
        while _G.AutoBuy do
            AutoBuy()
            task.wait(10)
        end
    end
})

AutoTab:CreateToggle({
    Title = "Автопродажа",
    Description = "100% сбор урожая",
    Callback = function(state)
        _G.AutoSell = state
        while _G.AutoSell do
            AutoSell()
            task.wait(15)
        end
    end
})

-- Телепорты
local TeleportTab = Window:CreateTab("Teleports", 6998339324)
TeleportTab:CreateButton({
    Title = "Магазин семян",
    Callback = function()
        TeleportTo("SeedShop")
    end
})

TeleportTab:CreateButton({
    Title = "Магазин инструментов",
    Callback = function()
        TeleportTo("GearShop")
    end
})

-- Визуальные эффекты
local VisualsTab = Window:CreateTab("Visuals", 6022668998)
VisualsTab:CreateColorPicker({
    Title = "Цвет интерфейса",
    Callback = function(color)
        Window:UpdateBackground(color)
    end
})

Rayfield:Notify({
    Title = "ВНИМАНИЕ",
    Content = "GOD MODE активирован!",
    Duration = 8,
    Image = 6023426925
})

-- Автостарт
DupeShekels()
Rayfield:LoadConfiguration()

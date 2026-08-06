-- SISTEMA DE MISIONES UI
-- LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("📋 Sistema de Misiones UI iniciando...")

-- Esperar eventos
local missionEvents = ReplicatedStorage:WaitForChild("MissionEvents", 10)
if not missionEvents then
    warn("❌ MissionEvents no encontrado")
    return
end

local walkieTalkieFound = missionEvents:WaitForChild("WalkieTalkieFound", 5)
local getMissionData = missionEvents:WaitForChild("GetMissionData", 5)

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MissionUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 15
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ─────────────────────────────────────────────
-- ICONO DE WALKIE-TALKIE (esquina superior izquierda)
-- ─────────────────────────────────────────────
local walkieIcon = Instance.new("Frame")
walkieIcon.Name = "WalkieIcon"
walkieIcon.Size = UDim2.new(0, 52, 0, 52)
walkieIcon.Position = UDim2.new(0, 15, 0, 95)
walkieIcon.BackgroundColor3 = Color3.fromRGB(18, 14, 26)
walkieIcon.BackgroundTransparency = 0.05
walkieIcon.BorderSizePixel = 0
walkieIcon.ZIndex = 10000
walkieIcon.Parent = screenGui

local walkieCorner = Instance.new("UICorner")
walkieCorner.CornerRadius = UDim.new(0.5, 0)
walkieCorner.Parent = walkieIcon

local walkieStroke = Instance.new("UIStroke")
walkieStroke.Color = Color3.fromRGB(100, 255, 150)
walkieStroke.Thickness = 2
walkieStroke.Transparency = 0.3
walkieStroke.Parent = walkieIcon

local walkieImage = Instance.new("TextLabel")
walkieImage.Size = UDim2.new(1, 0, 0.6, 0)
walkieImage.Position = UDim2.new(0, 0, 0, 2)
walkieImage.BackgroundTransparency = 1
walkieImage.Text = "📻"
walkieImage.TextSize = 28
walkieImage.TextColor3 = Color3.fromRGB(100, 255, 150)
walkieImage.ZIndex = 10001
walkieImage.Parent = walkieIcon

local walkieCount = Instance.new("TextLabel")
walkieCount.Size = UDim2.new(1, 0, 0.4, 0)
walkieCount.Position = UDim2.new(0, 0, 0.6, 0)
walkieCount.BackgroundTransparency = 1
walkieCount.Text = "0"
walkieCount.Font = Enum.Font.GothamBold
walkieCount.TextSize = 16
walkieCount.TextColor3 = Color3.fromRGB(255, 255, 255)
walkieCount.ZIndex = 10001
walkieCount.Parent = walkieIcon

-- ─────────────────────────────────────────────
-- ICONO DE MISIONES — lado IZQUIERDO, debajo del botón de tienda
-- (tienda = y:160, este = y:232 → separado de los poderes del lado derecho)
-- ─────────────────────────────────────────────
local missionButton = Instance.new("ImageButton")
missionButton.Name = "MissionButton"
missionButton.Size = UDim2.new(0, 52, 0, 52)
missionButton.Position = UDim2.new(0, 15, 0, 232)
missionButton.AnchorPoint = Vector2.new(0, 0)
missionButton.BackgroundColor3 = Color3.fromRGB(18, 14, 26)
missionButton.BackgroundTransparency = 0.05
missionButton.BorderSizePixel = 0
missionButton.ZIndex = 10000
missionButton.Parent = screenGui

local missionCorner = Instance.new("UICorner")
missionCorner.CornerRadius = UDim.new(0.5, 0)
missionCorner.Parent = missionButton

local missionStroke = Instance.new("UIStroke")
missionStroke.Color = Color3.fromRGB(255, 180, 50)
missionStroke.Thickness = 2
missionStroke.Transparency = 0.3
missionStroke.Parent = missionButton

local missionIcon = Instance.new("TextLabel")
missionIcon.Size = UDim2.new(1, 0, 1, 0)
missionIcon.BackgroundTransparency = 1
missionIcon.Text = "📋"
missionIcon.TextSize = 30
missionIcon.TextColor3 = Color3.fromRGB(255, 200, 50)
missionIcon.ZIndex = 10001
missionIcon.Parent = missionButton

missionButton.MouseEnter:Connect(function()
    TweenService:Create(missionButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 58, 0, 58),
        BackgroundColor3 = Color3.fromRGB(30, 24, 44)
    }):Play()
    TweenService:Create(missionStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
end)
missionButton.MouseLeave:Connect(function()
    TweenService:Create(missionButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 52, 0, 52),
        BackgroundColor3 = Color3.fromRGB(18, 14, 26)
    }):Play()
    TweenService:Create(missionStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
end)

-- ─────────────────────────────────────────────
-- MODAL DE MISIONES — Estilo Stranger Things / Roblox
-- ─────────────────────────────────────────────
local missionModal = Instance.new("Frame")
missionModal.Name = "MissionModal"
missionModal.Size = UDim2.new(0, 440, 0, 400)
missionModal.Position = UDim2.new(0, 80, 0.5, -200)   -- lado izquierdo, centro vertical
missionModal.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
missionModal.BorderSizePixel = 0
missionModal.Visible = false
missionModal.ZIndex = 6000
missionModal.Parent = screenGui

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 16)
modalCorner.Parent = missionModal

-- Borde animado rojo/ámbar
local modalStroke = Instance.new("UIStroke")
modalStroke.Color = Color3.fromRGB(200, 60, 60)
modalStroke.Thickness = 2
modalStroke.Transparency = 0.2
modalStroke.Parent = missionModal

task.spawn(function()
    while missionModal and missionModal.Parent do
        TweenService:Create(modalStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(255, 160, 20), Transparency = 0.1
        }):Play()
        task.wait(2)
        TweenService:Create(modalStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(200, 60, 60), Transparency = 0.3
        }):Play()
        task.wait(2)
    end
end)

-- Sombra
local modalShadow = Instance.new("Frame")
modalShadow.Size = UDim2.new(1, 16, 1, 16)
modalShadow.Position = UDim2.new(0, -8, 0, -8)
modalShadow.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
modalShadow.BackgroundTransparency = 0.88
modalShadow.BorderSizePixel = 0
modalShadow.ZIndex = 5999
modalShadow.Parent = missionModal
local shadowCorner2 = Instance.new("UICorner")
shadowCorner2.CornerRadius = UDim.new(0, 20)
shadowCorner2.Parent = modalShadow

-- ── HEADER ──────────────────────────────────
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 56)
header.BackgroundColor3 = Color3.fromRGB(22, 16, 38)
header.BorderSizePixel = 0
header.ZIndex = 6001
header.Parent = missionModal

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- Línea separadora
local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, -30, 0, 1)
headerLine.Position = UDim2.new(0, 15, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(200, 80, 20)
headerLine.BackgroundTransparency = 0.5
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 6002
headerLine.Parent = header

-- Ícono 
local headerIcon = Instance.new("TextLabel")
headerIcon.Size = UDim2.new(0, 40, 1, 0)
headerIcon.Position = UDim2.new(0, 10, 0, 0)
headerIcon.BackgroundTransparency = 1
headerIcon.Text = "📋"
headerIcon.TextSize = 28
headerIcon.ZIndex = 6002
headerIcon.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 1, 0)
title.Position = UDim2.new(0, 52, 0, 0)
title.BackgroundTransparency = 1
title.Text = "MISIONES"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 220, 180)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6002
title.Parent = header

-- Botón cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -44, 0.5, -17)
closeBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 6003
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0.5, 0)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160, 40, 40)}):Play()
end)

-- ── NARRACIÓN ────────────────────────────────
local storyBox = Instance.new("Frame")
storyBox.Size = UDim2.new(1, -30, 0, 68)
storyBox.Position = UDim2.new(0, 15, 0, 66)
storyBox.BackgroundColor3 = Color3.fromRGB(20, 14, 32)
storyBox.BorderSizePixel = 0
storyBox.ZIndex = 6001
storyBox.Parent = missionModal

local storyCorner = Instance.new("UICorner")
storyCorner.CornerRadius = UDim.new(0, 8)
storyCorner.Parent = storyBox

local storyStroke = Instance.new("UIStroke")
storyStroke.Color = Color3.fromRGB(200, 80, 20)
storyStroke.Thickness = 1
storyStroke.Transparency = 0.6
storyStroke.Parent = storyBox

local storyText = Instance.new("TextLabel")
storyText.Size = UDim2.new(1, -20, 1, -16)
storyText.Position = UDim2.new(0, 10, 0, 8)
storyText.BackgroundTransparency = 1
storyText.Text = "⚠️  WILL BYERS HA DESAPARECIDO\nCompleta las misiones y busca pistas por el mapa."
storyText.Font = Enum.Font.Gotham
storyText.TextSize = 13
storyText.TextColor3 = Color3.fromRGB(255, 200, 150)
storyText.TextWrapped = true
storyText.TextYAlignment = Enum.TextYAlignment.Top
storyText.TextXAlignment = Enum.TextXAlignment.Left
storyText.ZIndex = 6002
storyText.Parent = storyBox

-- ── LISTA DE MISIONES ─────────────────────────
local missionList = Instance.new("ScrollingFrame")
missionList.Size = UDim2.new(1, -30, 1, -150)
missionList.Position = UDim2.new(0, 15, 0, 146)
missionList.BackgroundTransparency = 1
missionList.BorderSizePixel = 0
missionList.ScrollBarThickness = 3
missionList.ScrollBarImageColor3 = Color3.fromRGB(180, 100, 30)
missionList.ZIndex = 6001
missionList.Parent = missionModal

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = missionList

-- Función para crear item de misión con estilo Stranger Things
local function createMissionItem(missionName, description, completed, progress, total)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, -6, 0, 80)
    item.BackgroundColor3 = completed and Color3.fromRGB(18, 28, 18) or Color3.fromRGB(20, 16, 30)
    item.BorderSizePixel = 0
    item.ZIndex = 6002
    item.Parent = missionList

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 8)
    itemCorner.Parent = item

    local itemStroke = Instance.new("UIStroke")
    itemStroke.Color = completed and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 80, 20)
    itemStroke.Thickness = 1
    itemStroke.Transparency = 0.4
    itemStroke.Parent = item

    -- Badge de estado
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0, 40, 0, 40)
    badge.Position = UDim2.new(0, 12, 0.5, -20)
    badge.BackgroundColor3 = completed and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(50, 30, 10)
    badge.BorderSizePixel = 0
    badge.ZIndex = 6003
    badge.Parent = item
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0.5, 0)
    badgeCorner.Parent = badge

    local badgeIcon = Instance.new("TextLabel")
    badgeIcon.Size = UDim2.new(1, 0, 1, 0)
    badgeIcon.BackgroundTransparency = 1
    badgeIcon.Text = completed and "✓" or "○"
    badgeIcon.Font = Enum.Font.GothamBold
    badgeIcon.TextSize = completed and 22 or 18
    badgeIcon.TextColor3 = completed and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 140, 40)
    badgeIcon.ZIndex = 6004
    badgeIcon.Parent = badge

    -- Nombre de la misión
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -68, 0, 22)
    nameLabel.Position = UDim2.new(0, 60, 0, 12)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = missionName
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = completed and Color3.fromRGB(180, 255, 180) or Color3.fromRGB(255, 230, 200)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 6003
    nameLabel.Parent = item

    -- Descripción
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -68, 0, 16)
    descLabel.Position = UDim2.new(0, 60, 0, 34)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextColor3 = Color3.fromRGB(170, 150, 130)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 6003
    descLabel.Parent = item

    -- Barra de progreso
    if total then
        local barBg = Instance.new("Frame")
        barBg.Size = UDim2.new(1, -68, 0, 8)
        barBg.Position = UDim2.new(0, 60, 1, -20)
        barBg.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
        barBg.BorderSizePixel = 0
        barBg.ZIndex = 6003
        barBg.Parent = item
        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(0.5, 0)
        barCorner.Parent = barBg

        local barFill = Instance.new("Frame")
        local ratio = math.min(progress / total, 1)
        barFill.Size = UDim2.new(ratio, 0, 1, 0)
        barFill.BackgroundColor3 = completed and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(220, 120, 30)
        barFill.BorderSizePixel = 0
        barFill.ZIndex = 6004
        barFill.Parent = barBg
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0.5, 0)
        fillCorner.Parent = barFill

        local progressLabel = Instance.new("TextLabel")
        progressLabel.Size = UDim2.new(0, 50, 0, 16)
        progressLabel.Position = UDim2.new(1, -55, 1, -20)
        progressLabel.BackgroundTransparency = 1
        progressLabel.Text = progress .. " / " .. total
        progressLabel.Font = Enum.Font.GothamBold
        progressLabel.TextSize = 11
        progressLabel.TextColor3 = completed and Color3.fromRGB(100, 230, 100) or Color3.fromRGB(220, 160, 80)
        progressLabel.TextXAlignment = Enum.TextXAlignment.Right
        progressLabel.ZIndex = 6004
        progressLabel.Parent = item
    end

    return item
end

-- Actualizar lista de misiones
local function updateMissionList()
    if not getMissionData then return end
    local success, data = pcall(function()
        return getMissionData:InvokeServer()
    end)
    if not success or not data then return end

    -- Limpiar lista
    for _, child in ipairs(missionList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    createMissionItem(
        "Cortar 5 Árboles",
        "Recolecta madera cortando árboles del mapa",
        data.Missions.CutTrees,
        math.min(data.TreesCut, 5), 5
    )
    createMissionItem(
        "Encontrar un Walkie-Talkie",
        "Busca un walkie-talkie escondido por el mapa",
        data.Missions.FindWalkieTalkie,
        math.min(data.WalkiesTalkiesFound, 1), 1
    )

    walkieCount.Text = tostring(data.WalkiesTalkiesFound)
    missionList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

-- Toggle modal
local modalOpen = false
missionButton.MouseButton1Click:Connect(function()
    modalOpen = not modalOpen
    if modalOpen then
        missionModal.Visible = true
        missionModal.Size = UDim2.new(0, 0, 0, 0)
        missionModal.Position = UDim2.new(0, 80, 0.5, 0)
        TweenService:Create(missionModal, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 440, 0, 400),
            Position = UDim2.new(0, 80, 0.5, -200)
        }):Play()
        updateMissionList()
    else
        TweenService:Create(missionModal, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 80, 0.5, 0)
        }):Play()
        task.wait(0.25)
        missionModal.Visible = false
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    modalOpen = false
    TweenService:Create(missionModal, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 80, 0.5, 0)
    }):Play()
    task.wait(0.25)
    missionModal.Visible = false
end)

-- Evento walkie-talkie encontrado
if walkieTalkieFound then
    walkieTalkieFound.OnClientEvent:Connect(function(count)
        walkieCount.Text = tostring(count)

        local pickupSound = Instance.new("Sound")
        pickupSound.SoundId = "rbxassetid://7039027381"
        pickupSound.Volume = 2
        pickupSound.Parent = workspace
        pickupSound:Play()
        pickupSound.Ended:Connect(function() pickupSound:Destroy() end)

        -- Pulso en el icono
        TweenService:Create(walkieIcon, TweenInfo.new(0.15), {Size = UDim2.new(0, 62, 0, 62)}):Play()
        task.wait(0.15)
        TweenService:Create(walkieIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 52, 0, 52)}):Play()

        -- Notificación flotante
        local notification = Instance.new("Frame")
        notification.Size = UDim2.new(0, 280, 0, 56)
        notification.Position = UDim2.new(0, 80, 0, -70)
        notification.BackgroundColor3 = Color3.fromRGB(14, 10, 22)
        notification.BorderSizePixel = 0
        notification.ZIndex = 9000
        notification.Parent = screenGui

        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notification

        local notifStroke = Instance.new("UIStroke")
        notifStroke.Color = Color3.fromRGB(100, 255, 150)
        notifStroke.Thickness = 2
        notifStroke.Parent = notification

        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, -16, 1, -12)
        notifText.Position = UDim2.new(0, 8, 0, 6)
        notifText.BackgroundTransparency = 1
        notifText.Text = "📻  Walkie-Talkie encontrado!\n" .. count .. " de 15 recolectados"
        notifText.Font = Enum.Font.GothamBold
        notifText.TextSize = 14
        notifText.TextColor3 = Color3.fromRGB(100, 255, 150)
        notifText.ZIndex = 9001
        notifText.Parent = notification

        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 80, 0, 20)
        }):Play()
        task.wait(3)
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(0, 80, 0, -70)
        }):Play()
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- Actualizar cada 5 s cuando está abierto
task.spawn(function()
    while true do
        task.wait(5)
        if modalOpen then updateMissionList() end
    end
end)

task.wait(2)
updateMissionList()

print("✅ Sistema de Misiones UI activo!")

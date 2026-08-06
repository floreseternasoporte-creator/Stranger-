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
 
-- ICONO DE WALKIE-TALKIE (debajo del árbol)
local walkieIcon = Instance.new("Frame")
walkieIcon.Name = "WalkieIcon"
walkieIcon.Size = UDim2.new(0, 52, 0, 52)
walkieIcon.Position = UDim2.new(0, 15, 0, 95)
walkieIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
walkieIcon.BackgroundTransparency = 0.1
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
 
-- Icono del walkie-talkie
local walkieImage = Instance.new("TextLabel")
walkieImage.Size = UDim2.new(1, 0, 0.6, 0)
walkieImage.Position = UDim2.new(0, 0, 0, 2)
walkieImage.BackgroundTransparency = 1
walkieImage.Text = "📻"
walkieImage.TextSize = 28
walkieImage.TextColor3 = Color3.fromRGB(100, 255, 150)
walkieImage.ZIndex = 10001
walkieImage.Parent = walkieIcon
 
-- Contador de walkies
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
 
-- ICONO DE MISIONES (DERECHA DE LA PANTALLA, ALINEADO CON TIENDA)
local missionButton = Instance.new("ImageButton")
missionButton.Name = "MissionButton"
missionButton.Size = UDim2.new(0, 52, 0, 52)
missionButton.Position = UDim2.new(1, -67, 0, 160)
missionButton.AnchorPoint = Vector2.new(1, 0)
missionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
missionButton.BackgroundTransparency = 0.2
missionButton.BorderSizePixel = 0
missionButton.ZIndex = 10000
missionButton.Parent = screenGui
 
local missionCorner = Instance.new("UICorner")
missionCorner.CornerRadius = UDim.new(0.5, 0)
missionCorner.Parent = missionButton
 
local missionStroke = Instance.new("UIStroke")
missionStroke.Color = Color3.fromRGB(100, 100, 100)
missionStroke.Thickness = 1
missionStroke.Transparency = 0.3
missionStroke.Parent = missionButton
 
-- Icono de clipboard/tareas
local missionIcon = Instance.new("TextLabel")
missionIcon.Size = UDim2.new(1, 0, 1, 0)
missionIcon.BackgroundTransparency = 1
missionIcon.Text = "📋"
missionIcon.TextSize = 32
missionIcon.TextColor3 = Color3.fromRGB(255, 200, 50)
missionIcon.ZIndex = 10001
missionIcon.Parent = missionButton
 
-- Hover effects
missionButton.MouseEnter:Connect(function()
    TweenService:Create(missionButton, TweenInfo.new(0.2), {
    Size = UDim2.new(0, 56, 0, 56),
    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }):Play()
end)
 
missionButton.MouseLeave:Connect(function()
    TweenService:Create(missionButton, TweenInfo.new(0.2), {
    Size = UDim2.new(0, 52, 0, 52),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }):Play()
end)
 
-- MODAL DE MISIONES - ESTILO ROBLOX
local missionModal = Instance.new("Frame")
missionModal.Name = "MissionModal"
missionModal.Size = UDim2.new(0, 420, 0, 380)
missionModal.Position = UDim2.new(0.5, -210, 0.5, -190)
missionModal.BackgroundColor3 = Color3.fromRGB(25, 27, 29)
missionModal.BorderSizePixel = 0
missionModal.Visible = false
missionModal.ZIndex = 6000
missionModal.Parent = screenGui
 
local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 12)
modalCorner.Parent = missionModal
 
local modalStroke = Instance.new("UIStroke")
modalStroke.Color = Color3.fromRGB(0, 0, 0)
modalStroke.Thickness = 1
modalStroke.Transparency = 0.5
modalStroke.Parent = missionModal
 
-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(31, 33, 35)
header.BorderSizePixel = 0
header.ZIndex = 6001
header.Parent = missionModal
 
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header
 
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Misiones"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6002
title.Parent = header
 
-- Botón cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -43, 0.5, -18)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 6003
closeBtn.Parent = header
 
local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 4)
closeBtnCorner.Parent = closeBtn
 
-- Narración de Will
local storyBox = Instance.new("Frame")
storyBox.Size = UDim2.new(1, -40, 0, 75)
storyBox.Position = UDim2.new(0, 20, 0, 65)
storyBox.BackgroundColor3 = Color3.fromRGB(35, 37, 39)
storyBox.BorderSizePixel = 0
storyBox.ZIndex = 6001
storyBox.Parent = missionModal
 
local storyCorner = Instance.new("UICorner")
storyCorner.CornerRadius = UDim.new(0, 6)
storyCorner.Parent = storyBox
 
local storyText = Instance.new("TextLabel")
storyText.Size = UDim2.new(1, -30, 1, -20)
storyText.Position = UDim2.new(0, 15, 0, 10)
storyText.BackgroundTransparency = 1
storyText.Text = "⚠️ WILL BYERS HA DESAPARECIDO\n\nNecesitamos tu ayuda para encontrarlo. Completa las misiones y busca pistas por el mapa."
storyText.Font = Enum.Font.Gotham
storyText.TextSize = 12
storyText.TextColor3 = Color3.fromRGB(220, 220, 220)
storyText.TextWrapped = true
storyText.TextYAlignment = Enum.TextYAlignment.Top
storyText.TextXAlignment = Enum.TextXAlignment.Left
storyText.ZIndex = 6002
storyText.Parent = storyBox
 
-- Lista de misiones
local missionList = Instance.new("ScrollingFrame")
missionList.Size = UDim2.new(1, -40, 1, -160)
missionList.Position = UDim2.new(0, 20, 0, 155)
missionList.BackgroundTransparency = 1
missionList.BorderSizePixel = 0
missionList.ScrollBarThickness = 4
missionList.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
missionList.ZIndex = 6001
missionList.Parent = missionModal
 
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = missionList
 
-- Función para crear item de misión
local function createMissionItem(missionName, description, completed, progress, total)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, -10, 0, 75)
    item.BackgroundColor3 = Color3.fromRGB(35, 37, 39)
    item.BorderSizePixel = 0
    item.ZIndex = 6002
    item.Parent = missionList
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 6)
    itemCorner.Parent = item
    
    local itemStroke = Instance.new("UIStroke")
    itemStroke.Color = completed and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(60, 60, 60)
    itemStroke.Thickness = 1
    itemStroke.Transparency = 0.5
    itemStroke.Parent = item
    
    -- Icono
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 45, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = completed and "✓" or "○"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 28
    icon.TextColor3 = completed and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(150, 150, 150)
    icon.ZIndex = 6003
    icon.Parent = item
    
    -- Nombre
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -55, 0, 22)
    nameLabel.Position = UDim2.new(0, 50, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = missionName
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 15
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 6003
    nameLabel.Parent = item
    
    -- Descripción
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -55, 0, 16)
    descLabel.Position = UDim2.new(0, 50, 0, 32)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 6003
    descLabel.Parent = item
    
    -- Progreso
    if total then
        local progressLabel = Instance.new("TextLabel")
        progressLabel.Size = UDim2.new(1, -55, 0, 16)
        progressLabel.Position = UDim2.new(0, 50, 1, -24)
        progressLabel.BackgroundTransparency = 1
        progressLabel.Text = progress .. "/" .. total
        progressLabel.Font = Enum.Font.GothamBold
        progressLabel.TextSize = 13
        progressLabel.TextColor3 = completed and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(200, 200, 200)
        progressLabel.TextXAlignment = Enum.TextXAlignment.Left
        progressLabel.ZIndex = 6003
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
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Misión 1: Cortar árboles
    createMissionItem(
    "Cortar 5 Árboles",
    "Recolecta madera cortando árboles",
    data.Missions.CutTrees,
    math.min(data.TreesCut, 5),
    5
    )
    
    -- Misión 2: Encontrar walkie-talkie
    createMissionItem(
    "Encontrar un Walkie-Talkie",
    "Busca un walkie-talkie por el mapa",
    data.Missions.FindWalkieTalkie,
    math.min(data.WalkiesTalkiesFound, 1),
    1
    )
    
    -- Actualizar contador de walkies
    walkieCount.Text = tostring(data.WalkiesTalkiesFound)
    
    -- Ajustar canvas size
    missionList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end
 
-- Toggle modal
local modalOpen = false
missionButton.MouseButton1Click:Connect(function()
    modalOpen = not modalOpen
    
    if modalOpen then
        missionModal.Visible = true
        missionModal.Size = UDim2.new(0, 0, 0, 0)
        missionModal.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(missionModal, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 380),
        Position = UDim2.new(0.5, -210, 0.5, -190)
        }):Play()
        updateMissionList()
    else
        TweenService:Create(missionModal, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.2)
        missionModal.Visible = false
    end
end)
 
closeBtn.MouseButton1Click:Connect(function()
    modalOpen = false
    TweenService:Create(missionModal, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.2)
    missionModal.Visible = false
end)
 
-- Evento cuando encuentra walkie-talkie
if walkieTalkieFound then
    walkieTalkieFound.OnClientEvent:Connect(function(count)
        walkieCount.Text = tostring(count)
        
        -- Sonido de recogida
        local pickupSound = Instance.new("Sound")
        pickupSound.SoundId = "rbxassetid://7039027381"
        pickupSound.Volume = 2
        pickupSound.Parent = workspace
        pickupSound:Play()
        pickupSound.Ended:Connect(function()
            pickupSound:Destroy()
        end)
        
        -- Animación
        TweenService:Create(walkieIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        task.wait(0.2)
        TweenService:Create(walkieIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 52, 0, 52)}):Play()
        
        -- Notificación
        local notification = Instance.new("Frame")
        notification.Size = UDim2.new(0, 300, 0, 60)
        notification.Position = UDim2.new(0.5, -150, 0, -70)
        notification.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        notification.BorderSizePixel = 0
        notification.ZIndex = 9000
        notification.Parent = screenGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notification
        
        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, -20, 1, -20)
        notifText.Position = UDim2.new(0, 10, 0, 10)
        notifText.BackgroundTransparency = 1
        notifText.Text = "📻 Walkie-Talkie encontrado!\n" .. count .. " de 15"
        notifText.Font = Enum.Font.GothamBold
        notifText.TextSize = 16
        notifText.TextColor3 = Color3.fromRGB(100, 255, 150)
        notifText.ZIndex = 9001
        notifText.Parent = notification
        
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0, 20)
        }):Play()
        
        task.wait(3)
        TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(0.5, -150, 0, -70)
        }):Play()
        task.wait(0.3)
        notification:Destroy()
    end)
end
 
-- Actualizar cada 5 segundos
task.spawn(function()
    while true do
        task.wait(5)
        if modalOpen then
            updateMissionList()
        end
    end
end)
 
-- Cargar inicial
task.wait(2)
updateMissionList()
 
print("✅ Sistema de Misiones UI activo!")
 

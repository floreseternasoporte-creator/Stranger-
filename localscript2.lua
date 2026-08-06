-- STRANGER THINGS POWERS SHOP - VERSIÓN COMPLETA CON ROTACIÓN
-- LOCAL SCRIPT - StarterPlayer > StarterPlayerScripts
 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
 
print("🔥 Power Shop - Starting...")
 
-- ESPERAR EVENTOS CON TIMEOUT CORTO
local powerEvents = ReplicatedStorage:WaitForChild("PowerEvents", 3)
if not powerEvents then
    warn("❌ PowerEvents not found! Creating UI anyway...")
else
    print("✅ PowerEvents found")
end
 
local purchaseEvent = ReplicatedStorage:FindFirstChild("PurchasePowerEvent")
if purchaseEvent then
    print("✅ PurchasePowerEvent found")
else
    warn("⚠️ PurchasePowerEvent not found, using fallback")
end
 
local telekinesisPower, explosionPower, controlPower, protectionPower, healingPower, lightningPower, mindClonePower
 
if powerEvents then
    telekinesisPower = powerEvents:WaitForChild("TelekinesisPower", 3)
    explosionPower = powerEvents:WaitForChild("ExplosionPower", 3)
    controlPower = powerEvents:WaitForChild("ControlPower", 3)
    protectionPower = powerEvents:WaitForChild("ProtectionPower", 3)
    healingPower = powerEvents:WaitForChild("HealingPower", 3)
    lightningPower = powerEvents:WaitForChild("LightningPower", 3)
    mindClonePower = powerEvents:WaitForChild("MindClonePower", 3)
end
 
-- CONFIGURACIÓN
local COOLDOWN_TIMES = {
Telekinesis = 15,
Explosion = 20,
Control = 25,
Protection = 60,
Healing = 18,
Lightning = 12,
MindClone = 30
}
 
local cooldowns = {}
local unlockedPowers = {
Telekinesis = true,
Explosion = true,
Control = true,
Protection = true,
Healing = true,
Lightning = true,
MindClone = true
}
local powerButtons = {}
local shopOpen = false
local selectedPower = nil
local currentIndex = 1
 
-- SISTEMA DE ROTACIÓN DE TIENDA
local SHOP_ROTATION_TIME = 120
local shopRotationTimer = SHOP_ROTATION_TIME
local availablePowers = {}
 
-- ID DEL PRODUCTO HEALING (ROBUX)
local HEALING_PRODUCT_ID = 3485680292
 
-- SONIDO DE COMPRA
local PURCHASE_SOUND_ID = "rbxassetid://81946687425639"
 
-- DATOS DE PODERES - CON PRECIOS EN MADERA
local POWER_DATA = {
{Name = "Telekinesis", Key = "Q", Color = Color3.fromRGB(138, 43, 226), Rarity = "Common", Description = "Levita y controla enemigos con tu mente", Icon = "⚡", Price = 20, Position = UDim2.new(1, -90, 1, -180)},
{Name = "Explosion", Key = "E", Color = Color3.fromRGB(255, 20, 20), Rarity = "Rare", Description = "Explosión psíquica devastadora", Icon = "💥", Price = 50, Position = UDim2.new(1, -20, 1, -230)},
{Name = "Control", Key = "R", Color = Color3.fromRGB(255, 140, 0), Rarity = "Epic", Description = "Control mental masivo de área", Icon = "🌀", Price = 100, Position = UDim2.new(1, -160, 1, -180)},
{Name = "Protection", Key = "T", Color = Color3.fromRGB(255, 10, 10), Rarity = "Legendary", Description = "Escudo protector temporal", Icon = "🛡", Price = 150, Position = UDim2.new(1, -90, 1, -110)},
{Name = "Healing", Key = "F", Color = Color3.fromRGB(0, 255, 127), Rarity = "Rare", Description = "Curación instantánea", Icon = "❤", Price = 75, Position = UDim2.new(1, -20, 1, -160)},
{Name = "Lightning", Key = "G", Color = Color3.fromRGB(100, 200, 255), Rarity = "Epic", Description = "Rayo devastador azul eléctrico", Icon = "⚡", Price = 120, Position = UDim2.new(1, -20, 1, -90)},
{Name = "MindClone", Key = "H", Color = Color3.fromRGB(180, 50, 255), Rarity = "Legendary", Description = "Crea un clon mental que ataca al objetivo", Icon = "👤", Price = 200, Position = UDim2.new(1, -160, 1, -110)}
}
 
-- INICIALIZAR COOLDOWNS
for _, power in ipairs(POWER_DATA) do
    cooldowns[power.Name] = 0
end
 
-- FUNCIÓN PARA ROTAR PODERES DISPONIBLES
local function rotateShopInventory()
    availablePowers = {}
    
    local allPowers = {}
    for _, power in ipairs(POWER_DATA) do
        table.insert(allPowers, power.Name)
    end
    
    local count = math.random(3, 5)
    for i = #allPowers, 2, -1 do
        local j = math.random(i)
        allPowers[i], allPowers[j] = allPowers[j], allPowers[i]
    end
    
    for i = 1, math.min(count, #allPowers) do
        table.insert(availablePowers, allPowers[i])
    end
    
    print("🔄 Shop rotated! Available powers:", table.concat(availablePowers, ", "))
    shopRotationTimer = SHOP_ROTATION_TIME
end
 
local function isPowerAvailable(powerName)
    for _, name in ipairs(availablePowers) do
        if name == powerName then
            return true
        end
    end
    return false
end
 
local function playPurchaseSound()
    local sound = Instance.new("Sound")
    sound.SoundId = PURCHASE_SOUND_ID
    sound.Volume = 0.5
    sound.Parent = workspace
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end
 
-- EFECTOS VISUALES
local function createScreenVignette(color)
    local screenGui = player.PlayerGui:FindFirstChild("PowerShopUI")
    if not screenGui then return end
    
    local vignette = Instance.new("Frame")
    vignette.Size = UDim2.new(1, 0, 1, 0)
    vignette.BackgroundColor3 = color
    vignette.BackgroundTransparency = 1
    vignette.BorderSizePixel = 0
    vignette.ZIndex = 5
    vignette.Parent = screenGui
    
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.9),
    NumberSequenceKeypoint.new(1, 0)
    })
    gradient.Parent = vignette
    
    task.spawn(function()
        for i = 1, 3 do
            TweenService:Create(vignette, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.3)
            TweenService:Create(vignette, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
        end
        vignette:Destroy()
    end)
end
 
local function createPowerActivationEffect(powerName, color)
    createScreenVignette(color)
    local screenGui = player.PlayerGui:FindFirstChild("PowerShopUI")
    if not screenGui then return end
    
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = color
    flash.BackgroundTransparency = 0.3
    flash.BorderSizePixel = 0
    flash.ZIndex = 10
    flash.Parent = screenGui
    
    TweenService:Create(flash, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.2, function() if flash and flash.Parent then flash:Destroy() end end)
    end
        
        local function showFeedback(message, color)
            local screenGui = player.PlayerGui:FindFirstChild("PowerShopUI")
            if not screenGui then return end
            
            local feedback = Instance.new("TextLabel")
            feedback.Size = UDim2.new(0, 300, 0, 60)
            feedback.Position = UDim2.new(0.5, -150, 0.4, 0)
            feedback.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            feedback.BackgroundTransparency = 0.2
            feedback.Text = message
            feedback.Font = Enum.Font.GothamBold
            feedback.TextSize = 20
            feedback.TextColor3 = color
            feedback.TextStrokeTransparency = 0
            feedback.ZIndex = 300
            feedback.Parent = screenGui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = feedback
            
            TweenService:Create(feedback, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -150, 0.35, 0)}):Play()
            
            task.delay(2, function()
                if feedback and feedback.Parent then
                    TweenService:Create(feedback, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
                    task.wait(0.3)
                    feedback:Destroy()
                end
            end)
        end
        
        -- ICONO TIENDA
        local function createShopIcon(screenGui)
            local shopButton = Instance.new("ImageButton")
            shopButton.Name = "ShopButton"
            shopButton.Size = UDim2.new(0, 52, 0, 52)
            shopButton.Position = UDim2.new(0, 15, 0, 160)
            shopButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            shopButton.BackgroundTransparency = 0.1
            shopButton.BorderSizePixel = 0
            shopButton.ZIndex = 10000
            shopButton.Parent = screenGui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0.5, 0)
            corner.Parent = shopButton
            
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(100, 100, 100)
            stroke.Thickness = 1
            stroke.Transparency = 0.3
            stroke.Parent = shopButton
            
            local iconContainer = Instance.new("Frame")
            iconContainer.Size = UDim2.new(0, 28, 0, 28)
            iconContainer.Position = UDim2.new(0.5, -14, 0.5, -14)
            iconContainer.BackgroundTransparency = 1
            iconContainer.ZIndex = 10001
            iconContainer.Parent = shopButton
            
            local shopBase = Instance.new("Frame")
            shopBase.Size = UDim2.new(0, 22, 0, 16)
            shopBase.Position = UDim2.new(0, 3, 0, 12)
            shopBase.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            shopBase.BorderSizePixel = 0
            shopBase.ZIndex = 10002
            shopBase.Parent = iconContainer
            
            local baseCorner = Instance.new("UICorner")
            baseCorner.CornerRadius = UDim.new(0, 2)
            baseCorner.Parent = shopBase
            
            local shopRoof = Instance.new("Frame")
            shopRoof.Size = UDim2.new(0, 25, 0, 8)
            shopRoof.Position = UDim2.new(0, 1.5, 0, 3)
            shopRoof.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            shopRoof.BorderSizePixel = 0
            shopRoof.ZIndex = 10003
            shopRoof.Parent = iconContainer
            
            local roofCorner = Instance.new("UICorner")
            roofCorner.CornerRadius = UDim.new(0, 3)
            roofCorner.Parent = shopRoof
            
            local door = Instance.new("Frame")
            door.Size = UDim2.new(0, 6, 0, 8)
            door.Position = UDim2.new(0, 11, 0, 20)
            door.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            door.BorderSizePixel = 0
            door.ZIndex = 10004
            door.Parent = iconContainer
            
            local doorCorner = Instance.new("UICorner")
            doorCorner.CornerRadius = UDim.new(0, 1)
            doorCorner.Parent = door
            
            shopButton.MouseEnter:Connect(function()
                TweenService:Create(shopButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 56, 0, 56), BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            shopButton.MouseLeave:Connect(function()
                TweenService:Create(shopButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 52, 0, 52), BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            end)
            
            return shopButton
        end
        
        -- TIENDA COMPACTA
        local function createCompactShop(screenGui)
            local shopModal = Instance.new("Frame")
            shopModal.Name = "ShopModal"
            shopModal.Size = UDim2.new(0, 500, 0, 320)
            shopModal.Position = UDim2.new(0.5, -250, 0.5, -160)
            shopModal.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
            shopModal.BorderSizePixel = 0
            shopModal.Visible = false
            shopModal.ZIndex = 5000
            shopModal.Parent = screenGui
            
            local modalCorner = Instance.new("UICorner")
            modalCorner.CornerRadius = UDim.new(0, 12)
            modalCorner.Parent = shopModal
            
            local modalStroke = Instance.new("UIStroke")
            modalStroke.Color = Color3.fromRGB(200, 30, 30)
            modalStroke.Thickness = 3
            modalStroke.Transparency = 0.2
            modalStroke.Parent = shopModal
            
            task.spawn(function()
                while true do
                    TweenService:Create(modalStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Color = Color3.fromRGB(255, 20, 147)
                    }):Play()
                    task.wait(2)
                    TweenService:Create(modalStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Color = Color3.fromRGB(138, 43, 226)
                    }):Play()
                    task.wait(2)
                end
            end)
            
            local header = Instance.new("Frame")
            header.Size = UDim2.new(1, 0, 0, 60)
            header.BackgroundColor3 = Color3.fromRGB(18, 15, 22)
            header.BorderSizePixel = 0
            header.ZIndex = 5001
            header.Parent = shopModal
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 12)
            headerCorner.Parent = header
            
            local headerGradient = Instance.new("UIGradient")
            headerGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 35, 70)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
            }
            headerGradient.Rotation = 90
            headerGradient.Parent = header
            
            local timerLabel = Instance.new("TextLabel")
            timerLabel.Name = "RotationTimer"
            timerLabel.Size = UDim2.new(0, 180, 0, 30)
            timerLabel.Position = UDim2.new(0, 20, 0, 12)
            timerLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            timerLabel.Text = "🔄 Renueva en: 2:00"
            timerLabel.Font = Enum.Font.GothamBold
            timerLabel.TextSize = 14
            timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            timerLabel.ZIndex = 5002
            timerLabel.Parent = header
            
            local timerCorner = Instance.new("UICorner")
            timerCorner.CornerRadius = UDim.new(0, 8)
            timerCorner.Parent = timerLabel
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(0, 300, 1, 0)
            title.Position = UDim2.new(0, 210, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = ""
            title.Font = Enum.Font.GothamBlack
            title.TextSize = 24
            title.TextColor3 = Color3.fromRGB(255, 50, 50)
            title.TextStrokeTransparency = 0
            title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 5002
            title.Parent = header
            
            local closeButton = Instance.new("TextButton")
            closeButton.Name = "CloseButton"
            closeButton.Size = UDim2.new(0, 45, 0, 45)
            closeButton.Position = UDim2.new(1, -55, 0.5, -22.5)
            closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            closeButton.Text = "X"
            closeButton.Font = Enum.Font.GothamBold
            closeButton.TextSize = 24
            closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.BorderSizePixel = 0
            closeButton.ZIndex = 5003
            closeButton.Parent = header
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(0, 10)
            closeCorner.Parent = closeButton
            
            local closeStroke = Instance.new("UIStroke")
            closeStroke.Color = Color3.fromRGB(255, 255, 255)
            closeStroke.Thickness = 2
            closeStroke.Transparency = 0.7
            closeStroke.Parent = closeButton
            
            closeButton.MouseEnter:Connect(function()
                TweenService:Create(closeButton, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 50, 0, 50),
                BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                }):Play()
                TweenService:Create(closeStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
            end)
            closeButton.MouseLeave:Connect(function()
                TweenService:Create(closeButton, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 45, 0, 45),
                BackgroundColor3 = Color3.fromRGB(220, 50, 50)
                }):Play()
                TweenService:Create(closeStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
            end)
            
            local productBox = Instance.new("Frame")
            productBox.Name = "ProductBox"
            productBox.Size = UDim2.new(1, -30, 0, 200)
            productBox.Position = UDim2.new(0, 15, 0, 75)
            productBox.BackgroundColor3 = Color3.fromRGB(20, 18, 25)
            productBox.BorderSizePixel = 0
            productBox.ZIndex = 5002
            productBox.Parent = shopModal
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 10)
            boxCorner.Parent = productBox
            
            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(180, 30, 30)
            boxStroke.Thickness = 2
            boxStroke.Transparency = 0.3
            boxStroke.Parent = productBox
            
            local iconContainer = Instance.new("Frame")
            iconContainer.Size = UDim2.new(0, 140, 0, 140)
            iconContainer.Position = UDim2.new(0, 10, 0, 10)
            iconContainer.BackgroundColor3 = Color3.fromRGB(25, 22, 30)
            iconContainer.BorderSizePixel = 0
            iconContainer.ZIndex = 5003
            iconContainer.Parent = productBox
            
            local iconCorner = Instance.new("UICorner")
            iconCorner.CornerRadius = UDim.new(0, 10)
            iconCorner.Parent = iconContainer
            
            local iconStroke = Instance.new("UIStroke")
            iconStroke.Color = Color3.fromRGB(100, 100, 120)
            iconStroke.Thickness = 2
            iconStroke.Parent = iconContainer
            
            local powerIcon = Instance.new("TextLabel")
            powerIcon.Name = "PowerIcon"
            powerIcon.Size = UDim2.new(1, 0, 1, 0)
            powerIcon.BackgroundTransparency = 1
            powerIcon.Text = "?"
            powerIcon.TextSize = 90
            powerIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
            powerIcon.ZIndex = 5004
            powerIcon.Parent = iconContainer
            
            local infoContainer = Instance.new("Frame")
            infoContainer.Size = UDim2.new(1, -165, 1, -20)
            infoContainer.Position = UDim2.new(0, 160, 0, 10)
            infoContainer.BackgroundTransparency = 1
            infoContainer.ZIndex = 5003
            infoContainer.Parent = productBox
            
            local powerName = Instance.new("TextLabel")
            powerName.Name = "PowerName"
            powerName.Size = UDim2.new(1, 0, 0, 40)
            powerName.Position = UDim2.new(0, 5, 0, 0)
            powerName.BackgroundTransparency = 1
            powerName.Text = "POWER NAME"
            powerName.Font = Enum.Font.GothamBold
            powerName.TextSize = 26
            powerName.TextColor3 = Color3.fromRGB(255, 255, 255)
            powerName.TextXAlignment = Enum.TextXAlignment.Left
            powerName.TextStrokeTransparency = 0.5
            powerName.ZIndex = 5004
            powerName.Parent = infoContainer
            
            local stockLabel = Instance.new("TextLabel")
            stockLabel.Name = "StockLabel"
            stockLabel.Size = UDim2.new(0, 150, 0, 25)
            stockLabel.Position = UDim2.new(0, 5, 0, 45)
            stockLabel.BackgroundTransparency = 1
            stockLabel.Text = "✓ DISPONIBLE"
            stockLabel.Font = Enum.Font.GothamBold
            stockLabel.TextSize = 15
            stockLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            stockLabel.TextXAlignment = Enum.TextXAlignment.Left
            stockLabel.ZIndex = 5004
            stockLabel.Parent = infoContainer
            
            local priceLabel = Instance.new("TextLabel")
            priceLabel.Name = "PriceLabel"
            priceLabel.Size = UDim2.new(1, -10, 0, 45)
            priceLabel.Position = UDim2.new(0, 5, 0, 75)
            priceLabel.BackgroundTransparency = 1
            priceLabel.Text = "FREE"
            priceLabel.Font = Enum.Font.GothamBold
            priceLabel.TextSize = 36
            priceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            priceLabel.TextXAlignment = Enum.TextXAlignment.Left
            priceLabel.ZIndex = 5004
            priceLabel.Parent = infoContainer
            
            local rarityBadge = Instance.new("TextLabel")
            rarityBadge.Name = "RarityBadge"
            rarityBadge.Size = UDim2.new(0, 100, 0, 32)
            rarityBadge.Position = UDim2.new(0, 5, 0, 130)
            rarityBadge.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            rarityBadge.Text = "Rare"
            rarityBadge.Font = Enum.Font.GothamBold
            rarityBadge.TextSize = 16
            rarityBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
            rarityBadge.ZIndex = 5004
            rarityBadge.Parent = infoContainer
            
            local rarityCorner = Instance.new("UICorner")
            rarityCorner.CornerRadius = UDim.new(0, 6)
            rarityCorner.Parent = rarityBadge
            
            local actionButton = Instance.new("TextButton")
            actionButton.Name = "ActionButton"
            actionButton.Size = UDim2.new(0, 180, 0, 45)
            actionButton.Position = UDim2.new(1, -190, 0, 120)
            actionButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            actionButton.Text = "🎁 OBTENER GRATIS"
            actionButton.Font = Enum.Font.GothamBold
            actionButton.TextSize = 18
            actionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            actionButton.BorderSizePixel = 0
            actionButton.ZIndex = 5004
            actionButton.Parent = infoContainer
            
            local actionCorner = Instance.new("UICorner")
            actionCorner.CornerRadius = UDim.new(0, 8)
            actionCorner.Parent = actionButton
            
            local descText = Instance.new("TextLabel")
            descText.Name = "DescriptionText"
            descText.Size = UDim2.new(1, -30, 0, 35)
            descText.Position = UDim2.new(0, 15, 0, 280)
            descText.BackgroundTransparency = 1
            descText.Text = "Descripción del poder..."
            descText.Font = Enum.Font.Gotham
            descText.TextSize = 13
            descText.TextColor3 = Color3.fromRGB(200, 200, 200)
            descText.TextWrapped = true
            descText.TextXAlignment = Enum.TextXAlignment.Left
            descText.TextYAlignment = Enum.TextYAlignment.Top
            descText.ZIndex = 5003
            descText.Parent = shopModal
            
            local leftArrow = Instance.new("TextButton")
            leftArrow.Name = "LeftArrow"
            leftArrow.Size = UDim2.new(0, 50, 0, 50)
            leftArrow.Position = UDim2.new(0, -65, 0.5, -25)
            leftArrow.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            leftArrow.Text = "◄"
            leftArrow.Font = Enum.Font.GothamBold
            leftArrow.TextSize = 28
            leftArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
            leftArrow.ZIndex = 5010
            leftArrow.Parent = shopModal
            
            local leftCorner = Instance.new("UICorner")
            leftCorner.CornerRadius = UDim.new(1, 0)
            leftCorner.Parent = leftArrow
            
            local rightArrow = Instance.new("TextButton")
            rightArrow.Name = "RightArrow"
            rightArrow.Size = UDim2.new(0, 50, 0, 50)
            rightArrow.Position = UDim2.new(1, 15, 0.5, -25)
            rightArrow.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            rightArrow.Text = "►"
            rightArrow.Font = Enum.Font.GothamBold
            rightArrow.TextSize = 28
            rightArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
            rightArrow.ZIndex = 5010
            rightArrow.Parent = shopModal
            
            local rightCorner = Instance.new("UICorner")
            rightCorner.CornerRadius = UDim.new(1, 0)
            rightCorner.Parent = rightArrow
            
            leftArrow.MouseEnter:Connect(function()
                TweenService:Create(leftArrow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(138, 43, 226), Size = UDim2.new(0, 55, 0, 55)}):Play()
            end)
            leftArrow.MouseLeave:Connect(function()
                TweenService:Create(leftArrow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60), Size = UDim2.new(0, 50, 0, 50)}):Play()
            end)
            
            rightArrow.MouseEnter:Connect(function()
                TweenService:Create(rightArrow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(138, 43, 226), Size = UDim2.new(0, 55, 0, 55)}):Play()
            end)
            rightArrow.MouseLeave:Connect(function()
                TweenService:Create(rightArrow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60), Size = UDim2.new(0, 50, 0, 50)}):Play()
            end)
            
            local function updateProduct(index)
                local power = POWER_DATA[index]
                if not power then return end
                
                currentIndex = index
                selectedPower = power
                
                local isAvailable = isPowerAvailable(power.Name)
                
                powerIcon.Text = power.Icon
                powerIcon.TextColor3 = power.Color
                iconContainer.BackgroundColor3 = Color3.new(
                power.Color.R * 0.3,
                power.Color.G * 0.3,
                power.Color.B * 0.3
                )
                
                powerName.Text = power.Name:upper()
                
                if isAvailable then
                    stockLabel.Text = "✓ DISPONIBLE"
                    stockLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                else
                    stockLabel.Text = "✕ NO DISPONIBLE"
                    stockLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
                
                priceLabel.Text = power.Price .. " MADERA"
                priceLabel.TextColor3 = Color3.fromRGB(139, 69, 19)
                
                rarityBadge.Text = power.Rarity
                rarityBadge.BackgroundColor3 = power.Color
                descText.Text = power.Description
                
                if unlockedPowers[power.Name] then
                    actionButton.Text = "✓ DESBLOQUEADO"
                    actionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                elseif not isAvailable then
                    actionButton.Text = "⏳ NO DISPONIBLE"
                    actionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                else
                    actionButton.Text = power.Price .. " 🪵"
                    actionButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
                end
                
                productBox.Position = UDim2.new(1, 0, 0, 70)
                TweenService:Create(productBox, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 15, 0, 70)
                }):Play()
            end
            
            leftArrow.MouseButton1Click:Connect(function()
                currentIndex = currentIndex - 1
                if currentIndex < 1 then currentIndex = #POWER_DATA end
                updateProduct(currentIndex)
            end)
            
            rightArrow.MouseButton1Click:Connect(function()
                currentIndex = currentIndex + 1
                if currentIndex > #POWER_DATA then currentIndex = 1 end
                updateProduct(currentIndex)
            end)
            
            actionButton.MouseButton1Click:Connect(function()
                if not selectedPower then return end
                
                if unlockedPowers[selectedPower.Name] then
                    showFeedback("⚠️ YA ESTÁ DESBLOQUEADO", Color3.fromRGB(255, 200, 100))
                    return
                end
                
                if not isPowerAvailable(selectedPower.Name) then
                    showFeedback("⏳ ESTE PODER NO ESTÁ DISPONIBLE AHORA", Color3.fromRGB(255, 150, 50))
                    return
                end
                
                -- Verificar madera
                local leaderstats = player:FindFirstChild("leaderstats")
                if not leaderstats then return end
                
                local woodValue = leaderstats:FindFirstChild("Wood")
                if not woodValue then return end
                
                if woodValue.Value < selectedPower.Price then
                    showFeedback("❌ NO TIENES SUFICIENTE MADERA (" .. selectedPower.Price .. ")", Color3.fromRGB(255, 100, 100))
                    return
                end
                
                -- Descontar madera
                local success = false
                if purchaseEvent then
                    success = purchaseEvent:InvokeServer(selectedPower.Name, selectedPower.Price)
                else
                    -- Fallback si no existe el evento
                    if _G.AddWood then
                        _G.AddWood(player, -selectedPower.Price)
                        success = true
                    end
                end
                
                if success then
                    unlockedPowers[selectedPower.Name] = true
                    playPurchaseSound()
                    updateProduct(currentIndex)
                    updatePowerButtons()
                    showFeedback("✅ PODER DESBLOQUEADO: " .. selectedPower.Name:upper(), Color3.fromRGB(100, 255, 100))
                else
                    showFeedback("❌ ERROR AL COMPRAR", Color3.fromRGB(255, 100, 100))
                end
            end)
            
            closeButton.MouseButton1Click:Connect(function()
                shopOpen = false
                TweenService:Create(shopModal, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
                }):Play()
                task.wait(0.3)
                shopModal.Visible = false
            end)
            
            updateProduct(1)
            
            return shopModal, timerLabel
        end
        
        -- CREAR BOTÓN DE PODER CON VIEWPORTFRAME (PERSONAJE 3D)
        local function createPowerButton(powerData, screenGui)
            -- CONTENEDOR PRINCIPAL
            local container = Instance.new("Frame")
            container.Name = powerData.Name .. "Container"
            container.Size = UDim2.new(0, 70, 0, 90)
            container.Position = powerData.Position
            container.AnchorPoint = Vector2.new(1, 1)
            container.BackgroundTransparency = 1
            container.Visible = false
            container.ZIndex = 200
            container.Parent = screenGui
            
            -- NOMBRE DEL PODER (ARRIBA)
            local powerNameLabel = Instance.new("TextLabel")
            powerNameLabel.Name = "PowerName"
            powerNameLabel.Size = UDim2.new(1, 0, 0, 18)
            powerNameLabel.Position = UDim2.new(0, 0, 0, 0)
            powerNameLabel.BackgroundTransparency = 1
            powerNameLabel.Text = powerData.Name:upper()
            powerNameLabel.Font = Enum.Font.GothamBold
            powerNameLabel.TextSize = 10
            powerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            powerNameLabel.TextStrokeTransparency = 0.3
            powerNameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            powerNameLabel.ZIndex = 201
            powerNameLabel.Parent = container
            
            -- BOTÓN CIRCULAR
            local button = Instance.new("TextButton")
            button.Name = "PowerButton"
            button.Size = UDim2.new(0, 60, 0, 60)
            button.Position = UDim2.new(0.5, -30, 0, 22)
            button.BackgroundColor3 = powerData.Color
            button.Text = ""
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.ClipsDescendants = true
            button.ZIndex = 200
            button.Parent = container
            
            -- HACER CIRCULAR
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0.5, 0)
            buttonCorner.Parent = button
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = Color3.fromRGB(255, 255, 255)
            buttonStroke.Thickness = 3
            buttonStroke.Transparency = 0.5
            buttonStroke.Parent = button
            
            -- VIEWPORTFRAME PARA PERSONAJE 3D
            local viewport = Instance.new("ViewportFrame")
            viewport.Size = UDim2.new(1, 0, 1, 0)
            viewport.Position = UDim2.new(0, 0, 0, 0)
            viewport.BackgroundTransparency = 1
            viewport.CurrentCamera = Instance.new("Camera")
            viewport.ZIndex = 201
            viewport.Parent = button
            
            -- Crear personaje 3D clonado
            task.spawn(function()
                local character = player.Character or player.CharacterAdded:Wait()
                if not character then return end
                
                task.wait(0.5)
                
                local humanoid = character:FindFirstChild("Humanoid")
                if not humanoid then return end
                
                local rigType = humanoid.RigType
                local clonedCharacter
                
                if rigType == Enum.HumanoidRigType.R15 then
                    clonedCharacter = game:GetService("InsertService"):LoadAsset(1664543044):GetChildren()[1]:Clone()
                else
                    clonedCharacter = game:GetService("InsertService"):LoadAsset(68452456):GetChildren()[1]:Clone()
                end
                
                if not clonedCharacter then
                    -- Fallback: clonar el personaje actual
                    clonedCharacter = character:Clone()
                    for _, obj in pairs(clonedCharacter:GetDescendants()) do
                        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                            obj:Destroy()
                        end
                    end
                end
                
                -- Aplicar apariencia del jugador
                local bodyColors = character:FindFirstChild("Body Colors")
                if bodyColors and clonedCharacter:FindFirstChild("Body Colors") then
                    local clonedColors = clonedCharacter:FindFirstChild("Body Colors")
                    clonedColors.HeadColor = bodyColors.HeadColor
                    clonedColors.LeftArmColor = bodyColors.LeftArmColor
                    clonedColors.RightArmColor = bodyColors.RightArmColor
                    clonedColors.LeftLegColor = bodyColors.LeftLegColor
                    clonedColors.RightLegColor = bodyColors.RightLegColor
                    clonedColors.TorsoColor = bodyColors.TorsoColor
                end
                
                -- Aplicar ropa
                for _, item in pairs(character:GetChildren()) do
                    if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("Accessory") then
                        local clone = item:Clone()
                        clone.Parent = clonedCharacter
                    end
                end
                
                clonedCharacter.Parent = viewport
                
                -- Posicionar cámara
                local camera = viewport.CurrentCamera
                local head = clonedCharacter:FindFirstChild("Head")
                if head then
                    camera.CFrame = CFrame.new(head.Position + Vector3.new(0, 0.5, 3), head.Position)
                end
                
                -- Animación idle suave
                task.spawn(function()
                    while viewport and viewport.Parent do
                        if clonedCharacter and clonedCharacter.Parent then
                            local torso = clonedCharacter:FindFirstChild("HumanoidRootPart") or clonedCharacter:FindFirstChild("Torso")
                            if torso then
                                local time = tick() * 2
                                torso.CFrame = torso.CFrame * CFrame.Angles(0, math.rad(math.sin(time) * 2), 0)
                            end
                        end
                        task.wait(0.03)
                    end
                end)
            end)
            
            -- OVERLAY DE COOLDOWN
            local overlay = Instance.new("Frame")
            overlay.Name = "CooldownOverlay"
            overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            overlay.BackgroundTransparency = 0.2
            overlay.Size = UDim2.new(1, 0, 1, 0)
            overlay.BorderSizePixel = 0
            overlay.ZIndex = 202
            overlay.Parent = button
            
            local overlayCorner = Instance.new("UICorner")
            overlayCorner.CornerRadius = UDim.new(0.5, 0)
            overlayCorner.Parent = overlay
            
            local timerText = Instance.new("TextLabel")
            timerText.Size = UDim2.new(1, 0, 1, 0)
            timerText.BackgroundTransparency = 1
            timerText.Text = ""
            timerText.Font = Enum.Font.GothamBold
            timerText.TextSize = 20
            timerText.TextColor3 = Color3.new(1, 1, 1)
            timerText.TextStrokeTransparency = 0
            timerText.ZIndex = 203
            timerText.Parent = overlay
            
            -- LETRA DE TECLA
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Size = UDim2.new(0, 18, 0, 18)
            keyLabel.Position = UDim2.new(1, -22, 1, -22)
            keyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            keyLabel.BackgroundTransparency = 0.3
            keyLabel.Text = powerData.Key
            keyLabel.Font = Enum.Font.GothamBold
            keyLabel.TextSize = 11
            keyLabel.TextColor3 = Color3.new(1, 1, 1)
            keyLabel.BorderSizePixel = 0
            keyLabel.ZIndex = 204
            keyLabel.Parent = button
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0.5, 0)
            keyCorner.Parent = keyLabel
            
            -- EFECTOS HOVER
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 66, 0, 66)}):Play()
                TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Transparency = 0.2, Thickness = 4}):Play()
                TweenService:Create(powerNameLabel, TweenInfo.new(0.2), {TextSize = 11}):Play()
            end)
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
                TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Transparency = 0.5, Thickness = 3}):Play()
                TweenService:Create(powerNameLabel, TweenInfo.new(0.2), {TextSize = 10}):Play()
            end)
            
            return {
            Container = container,
            Button = button,
            Overlay = overlay,
            Timer = timerText,
            KeyCode = Enum.KeyCode[powerData.Key],
            Color = powerData.Color
            }
        end
        
        -- ACTUALIZAR BOTONES
        function updatePowerButtons()
            for powerName, isUnlocked in pairs(unlockedPowers) do
                if isUnlocked and powerButtons[powerName] then
                    powerButtons[powerName].Container.Visible = true
                    powerButtons[powerName].Container.Size = UDim2.new(0, 0, 0, 0)
                    TweenService:Create(powerButtons[powerName].Container, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 70, 0, 90)
                    }):Play()
                end
            end
        end
        
        -- COOLDOWN
        local function startCooldown(powerName, duration)
            local data = powerButtons[powerName]
            if not data then return end
            
            data.Overlay.Size = UDim2.new(1, 0, 1, 0)
            data.Timer.Text = tostring(duration)
            
            TweenService:Create(data.Overlay, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            
            local startTime = tick()
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local remaining = duration - (tick() - startTime)
                if remaining <= 0 then
                    data.Timer.Text = ""
                    connection:Disconnect()
                else
                    data.Timer.Text = tostring(math.ceil(remaining))
                end
            end)
        end
        
        -- OBTENER JUGADOR O NPC OBJETIVO
        local function getTargetPlayer()
            local mouse = player:GetMouse()
            local mouseTarget = mouse.Target
            local MAX_TARGET_RANGE = 70
            
            if mouseTarget then
                local character = mouseTarget:FindFirstAncestorOfClass("Model")
                if character and character:FindFirstChild("Humanoid") then
                    local targetPlayer = Players:GetPlayerFromCharacter(character)
                    if targetPlayer and targetPlayer ~= player then
                        return targetPlayer
                    end
                    
                    -- Si no es jugador, verificar si es un NPC/Demogorgon
                    if not targetPlayer and character:FindFirstChild("HumanoidRootPart") then
                        -- IMPORTANTE: Retornar el modelo completo del NPC
                        return character
                    end
                end
            end
            
            local playerCharacter = player.Character
            if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                local closestTarget, closestDistance = nil, MAX_TARGET_RANGE
                
                -- Buscar jugadores cercanos
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (playerCharacter.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestTarget = otherPlayer
                        end
                    end
                end
                
                -- Buscar NPCs/Demogorgons cercanos en el Workspace
                for _, model in pairs(workspace:GetChildren()) do
                    if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                        local isPlayerChar = Players:GetPlayerFromCharacter(model)
                        if not isPlayerChar and model ~= playerCharacter then
                            local distance = (playerCharacter.HumanoidRootPart.Position - model.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                -- IMPORTANTE: Retornar el modelo completo del NPC
                                closestTarget = model
                            end
                        end
                    end
                end
                
                return closestTarget
            end
            
            return nil
        end
        
        -- USAR PODER
        local function handlePowerUse(powerName, target)
            if not unlockedPowers[powerName] then
                showFeedback("🔒 PODER BLOQUEADO - ABRE LA TIENDA", Color3.fromRGB(255, 100, 100))
                return
            end
            
            local now = tick()
            if cooldowns[powerName] > now then
                local remaining = math.ceil(cooldowns[powerName] - now)
                showFeedback("⏱️ COOLDOWN: " .. remaining .. "s", Color3.fromRGB(255, 200, 100))
                return
            end
            
            local targetRequired = (powerName == "Telekinesis" or powerName == "Explosion" or powerName == "Healing" or powerName == "Lightning" or powerName == "MindClone")
            if targetRequired and not target then
                showFeedback("⚠️ APUNTA A UN OBJETIVO", Color3.fromRGB(255, 150, 50))
                return
            end
            
            local success = false
            if powerName == "Telekinesis" and target and telekinesisPower then
                telekinesisPower:FireServer(target)
                success = true
            elseif powerName == "Explosion" and target and explosionPower then
                explosionPower:FireServer(target)
                success = true
            elseif powerName == "Control" and controlPower then
                controlPower:FireServer()
                success = true
            elseif powerName == "Protection" and protectionPower then
                protectionPower:FireServer()
                success = true
            elseif powerName == "Healing" and target and healingPower then
                healingPower:FireServer(target)
                success = true
            elseif powerName == "Lightning" and target and lightningPower then
                lightningPower:FireServer(target)
                success = true
            elseif powerName == "MindClone" and target and mindClonePower then
                mindClonePower:FireServer(target)
                success = true
            end
            
            if success then
                cooldowns[powerName] = now + COOLDOWN_TIMES[powerName]
                startCooldown(powerName, COOLDOWN_TIMES[powerName])
                createPowerActivationEffect(powerName, powerButtons[powerName].Color)
                showFeedback("⚡ " .. powerName:upper() .. " ACTIVADO", powerButtons[powerName].Color)
            end
        end
        
        -- INPUT TECLADO
        local function handleKeyboardInput(input, gameProcessed)
            if gameProcessed then return end
            for powerName, data in pairs(powerButtons) do
                if input.KeyCode == data.KeyCode then
                    handlePowerUse(powerName, getTargetPlayer())
                    break
                end
            end
        end
        
        -- COMPRA ROBUX
        MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, wasPurchased)
            if userId == player.UserId and productId == HEALING_PRODUCT_ID and wasPurchased then
                print("✅ Healing Power purchased!")
                unlockedPowers["Healing"] = true
                playPurchaseSound()
                updatePowerButtons()
                showFeedback("✅ HEALING POWER COMPRADO", Color3.fromRGB(100, 255, 100))
            end
        end)
        
        -- INICIALIZAR
        local function initialize()
            print("🚀 Power Shop - Initializing...")
            
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "PowerShopUI"
            screenGui.Parent = player:WaitForChild("PlayerGui")
            screenGui.DisplayOrder = 10
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true
            
            rotateShopInventory()
            
            local shopButton = createShopIcon(screenGui)
            local shopModal, timerLabel = createCompactShop(screenGui)
            
            -- CREAR BOTONES DE PODERES
            for _, powerData in ipairs(POWER_DATA) do
                powerButtons[powerData.Name] = createPowerButton(powerData, screenGui)
                powerButtons[powerData.Name].Button.MouseButton1Click:Connect(function()
                    local targetRequired = (powerData.Name == "Telekinesis" or powerData.Name == "Explosion" or powerData.Name == "Healing" or powerData.Name == "Lightning" or powerData.Name == "MindClone")
                    handlePowerUse(powerData.Name, targetRequired and getTargetPlayer())
                end)
            end
            
            -- MOSTRAR BOTONES DE PODERES YA DESBLOQUEADOS AL INICIAR
            updatePowerButtons()
            
            shopButton.MouseButton1Click:Connect(function()
                print("🛍️ Botón de tienda clickeado")
                shopOpen = not shopOpen
                print("📊 Estado shopOpen:", shopOpen)
                
                if shopOpen then
                    print("✅ Abriendo tienda...")
                    shopModal.Visible = true
                    shopModal.Size = UDim2.new(0, 0, 0, 0)
                    shopModal.Position = UDim2.new(0.5, 0, 0.5, 0)
                    TweenService:Create(shopModal, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 500, 0, 320),
                    Position = UDim2.new(0.5, -250, 0.5, -160)
                    }):Play()
                else
                    print("❌ Cerrando tienda...")
                    TweenService:Create(shopModal, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                    }):Play()
                    task.wait(0.3)
                    shopModal.Visible = false
                end
            end)
            
            UserInputService.InputBegan:Connect(handleKeyboardInput)
            
            task.spawn(function()
                while true do
                    task.wait(1)
                    shopRotationTimer = shopRotationTimer - 1
                    
                    if shopRotationTimer <= 0 then
                        rotateShopInventory()
                        showFeedback("🔄 ¡TIENDA RENOVADA!", Color3.fromRGB(255, 200, 50))
                    end
                    
                    local minutes = math.floor(shopRotationTimer / 60)
                    local seconds = shopRotationTimer % 60
                    timerLabel.Text = string.format("🔄 Renueva en: %d:%02d", minutes, seconds)
                    
                    if shopRotationTimer <= 10 then
                        timerLabel.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    else
                        timerLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                    end
                end
            end)
            
            print("✅ Power Shop - Ready!")
        end
        
        initialize()
       

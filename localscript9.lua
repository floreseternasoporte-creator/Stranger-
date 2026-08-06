-- SISTEMA DE VIDAS CON 3 CORAZONES
-- LocalScript en StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("🔄 Iniciando sistema de vidas...")

-- Esperar a que el personaje cargue
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HealthUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Contenedor de corazones (alineado con iconos de Roblox)
local heartsContainer = Instance.new("Frame")
heartsContainer.Name = "HeartsContainer"
heartsContainer.Size = UDim2.new(0, 150, 0, 40)
heartsContainer.Position = UDim2.new(1, -160, 0, 2) -- Ajustado para alinearse con iconos
heartsContainer.BackgroundTransparency = 1
heartsContainer.Parent = screenGui

local hearts = {}
local HEART_SIZE = 40 -- Más pequeño
local HEART_SPACING = 5

for i = 1, 3 do
    local heartButton = Instance.new("ImageButton")
    heartButton.Name = "Heart" .. i
    heartButton.Size = UDim2.new(0, HEART_SIZE, 0, HEART_SIZE)
    heartButton.Position = UDim2.new(0, (i - 1) * (HEART_SIZE + HEART_SPACING), 0, 0)
    heartButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    heartButton.BackgroundTransparency = 0.2
    heartButton.BorderSizePixel = 0
    heartButton.AutoButtonColor = false
    heartButton.Image = ""
    heartButton.ZIndex = 10
    heartButton.Parent = heartsContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.5, 0)
    btnCorner.Parent = heartButton
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(100, 100, 100)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.3
    btnStroke.Parent = heartButton
    
    local heartIcon = Instance.new("TextLabel")
    heartIcon.Name = "HeartIcon"
    heartIcon.Size = UDim2.new(1, 0, 1, 0)
    heartIcon.BackgroundTransparency = 1
    heartIcon.Text = "❤"
    heartIcon.TextColor3 = Color3.fromRGB(255, 50, 50)
    heartIcon.TextScaled = true
    heartIcon.Font = Enum.Font.GothamBold
    heartIcon.ZIndex = 11
    heartIcon.Parent = heartButton
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = heartIcon
    
    table.insert(hearts, {
    button = heartButton,
    icon = heartIcon,
    stroke = btnStroke,
    state = "full"
    })
end

local function updateHearts()
    local health = humanoid.Health
    local maxHealth = humanoid.MaxHealth
    local healthPerHeart = maxHealth / 3
    
    print("💓 Vida actual: " .. health .. "/" .. maxHealth)
    
    for i, heart in ipairs(hearts) do
        local heartMinHealth = (i - 1) * healthPerHeart
        local heartMaxHealth = i * healthPerHeart
        
        if health >= heartMaxHealth then
            if heart.state ~= "full" then
                heart.state = "full"
                heart.icon.Text = "❤"
                heart.icon.TextColor3 = Color3.fromRGB(255, 50, 50)
                heart.icon.TextTransparency = 0
                heart.button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                heart.button.BackgroundTransparency = 0.2
            end
        elseif health > heartMinHealth and health < heartMaxHealth then
            if heart.state ~= "half" then
                heart.state = "half"
                heart.icon.Text = "💔"
                heart.icon.TextColor3 = Color3.fromRGB(255, 150, 50)
                heart.icon.TextTransparency = 0
                heart.button.BackgroundColor3 = Color3.fromRGB(40, 30, 20)
            end
        else
            if heart.state ~= "empty" then
                heart.state = "empty"
                heart.icon.Text = "🖤"
                heart.icon.TextColor3 = Color3.fromRGB(80, 80, 80)
                heart.icon.TextTransparency = 0.5
                heart.button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                heart.button.BackgroundTransparency = 0.6
            end
        end
    end
end

humanoid.HealthChanged:Connect(updateHearts)
updateHearts()

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    for _, heart in ipairs(hearts) do
        heart.state = "full"
        heart.icon.Text = "❤"
        heart.icon.TextColor3 = Color3.fromRGB(255, 50, 50)
        heart.icon.TextTransparency = 0
        heart.button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        heart.button.BackgroundTransparency = 0.2
        heart.button.Size = UDim2.new(0, HEART_SIZE, 0, HEART_SIZE)
    end
    
    humanoid.HealthChanged:Connect(updateHearts)
    updateHearts()
end)

print("✅ Sistema de vidas cargado correctamente")


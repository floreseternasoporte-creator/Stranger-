-- LocalScript para mostrar UI de madera
-- Coloca este script en StarterPlayer > StarterPlayerScripts
 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
 
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
 
-- Esperar al RemoteEvent
local woodEvent = ReplicatedStorage:WaitForChild("WoodEvent")
 
-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WoodUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui
 
-- BOTÓN CIRCULAR (igual que tienda y mensajes)
local mainFrame = Instance.new("ImageButton")
mainFrame.Name = "WoodButton"
mainFrame.Size = UDim2.new(0, 52, 0, 52)
mainFrame.Position = UDim2.new(0, 15, 0, 225)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.AutoButtonColor = false
mainFrame.Image = ""
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui
 
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0.5, 0)
btnCorner.Parent = mainFrame
 
local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(100, 100, 100)
btnStroke.Thickness = 1
btnStroke.Transparency = 0.3
btnStroke.Parent = mainFrame
 
-- ICONO DE MADERA MEJORADO
local iconContainer = Instance.new("Frame")
iconContainer.Name = "IconContainer"
iconContainer.Size = UDim2.new(0, 28, 0, 28)
iconContainer.Position = UDim2.new(0.5, -14, 0.5, -14)
iconContainer.BackgroundTransparency = 1
iconContainer.ZIndex = 11
iconContainer.Parent = mainFrame
 
-- Tronco de árbol
local trunk = Instance.new("Frame")
trunk.Size = UDim2.new(0, 8, 0, 18)
trunk.Position = UDim2.new(0.5, -4, 0.5, -3)
trunk.BackgroundColor3 = Color3.fromRGB(101, 67, 33)
trunk.BorderSizePixel = 0
trunk.ZIndex = 12
trunk.Parent = iconContainer
 
local trunkCorner = Instance.new("UICorner")
trunkCorner.CornerRadius = UDim.new(0, 2)
trunkCorner.Parent = trunk
 
-- Copa del árbol (3 círculos)
local function createLeaf(xOffset, yOffset, size)
    local leaf = Instance.new("Frame")
    leaf.Size = UDim2.new(0, size, 0, size)
    leaf.Position = UDim2.new(0.5, xOffset - size/2, 0, yOffset)
    leaf.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    leaf.BorderSizePixel = 0
    leaf.ZIndex = 12
    leaf.Parent = iconContainer
    
    local leafCorner = Instance.new("UICorner")
    leafCorner.CornerRadius = UDim.new(1, 0)
    leafCorner.Parent = leaf
    
    return leaf
end
 
createLeaf(0, 0, 12)
createLeaf(-6, 3, 10)
createLeaf(6, 3, 10)
 
-- Contador de madera (abajo del botón)
local woodLabel = Instance.new("TextLabel")
woodLabel.Name = "WoodCount"
woodLabel.Size = UDim2.new(0, 52, 0, 18)
woodLabel.Position = UDim2.new(0, 0, 1, 2)
woodLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
woodLabel.BackgroundTransparency = 0.3
woodLabel.Text = "0"
woodLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
woodLabel.TextSize = 14
woodLabel.Font = Enum.Font.GothamBold
woodLabel.TextXAlignment = Enum.TextXAlignment.Center
woodLabel.BorderSizePixel = 0
woodLabel.ZIndex = 10
woodLabel.Parent = mainFrame
 
local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 4)
labelCorner.Parent = woodLabel
 
-- Efectos hover
mainFrame.MouseEnter:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.2), {
    Size = UDim2.new(0, 56, 0, 56),
    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }):Play()
end)
 
mainFrame.MouseLeave:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.2), {
    Size = UDim2.new(0, 52, 0, 52),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }):Play()
end)
 
-- Función para actualizar el contador
local function updateWoodDisplay()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local woodValue = leaderstats:FindFirstChild("Wood")
        if woodValue then
            woodLabel.Text = tostring(woodValue.Value)
        end
    end
end
 
-- Función de animación cuando se añade madera
local function playAddWoodAnimation(amount)
    TweenService:Create(mainFrame, TweenInfo.new(0.1), {Size = UDim2.new(0, 56, 0, 56)}):Play()
    task.wait(0.1)
    TweenService:Create(mainFrame, TweenInfo.new(0.1), {Size = UDim2.new(0, 52, 0, 52)}):Play()
    
    local floatingText = Instance.new("TextLabel")
    floatingText.Size = UDim2.new(0, 40, 0, 20)
    floatingText.Position = UDim2.new(0.5, -20, 0, -10)
    floatingText.BackgroundTransparency = 1
    floatingText.Text = "+" .. amount
    floatingText.TextColor3 = Color3.fromRGB(100, 255, 100)
    floatingText.TextSize = 16
    floatingText.Font = Enum.Font.GothamBold
    floatingText.TextStrokeTransparency = 0.5
    floatingText.ZIndex = 15
    floatingText.Parent = mainFrame
    
    TweenService:Create(floatingText, TweenInfo.new(0.7), {
    Position = UDim2.new(0.5, -20, 0, -30),
    TextTransparency = 1,
    TextStrokeTransparency = 1
    }):Play()
    
    task.delay(0.7, function()
        floatingText:Destroy()
    end)
    
    updateWoodDisplay()
end
 
-- Escuchar eventos de madera
woodEvent.OnClientEvent:Connect(function(amount)
    print("🪵 ¡Recibiste " .. amount .. " madera!")
    playAddWoodAnimation(amount)
end)
 
-- Actualizar cuando cambie el valor
local leaderstats = player:WaitForChild("leaderstats")
local woodValue = leaderstats:WaitForChild("Wood")
 
woodValue.Changed:Connect(function()
    updateWoodDisplay()
end)
 
-- Inicializar display
updateWoodDisplay()
 
print("✅ UI de madera cargada correctamente")
 

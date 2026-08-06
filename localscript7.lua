-- LocalScript en StarterPlayerScripts
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
 
-- Requiere TopBarPlus (ajusta la ruta si lo pusiste en otra carpeta)
local Icon = require(game.ReplicatedStorage:WaitForChild("Icon"))  -- Cambia si está en Modules.Icon
 
-- ==================== CREAR EL MODAL DE ACTUALIZACIONES ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpdatesGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
 
local modal = Instance.new("Frame")
modal.Name = "UpdatesModal"
modal.Size = UDim2.new(0, 500, 0, 600)
modal.Position = UDim2.new(0.5, -250, 0.5, -300)
modal.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
modal.BorderSizePixel = 0
modal.Visible = false
modal.Parent = screenGui
 
-- Esquinas redondeadas
local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 12)
modalCorner.Parent = modal
 
-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "📢 Actualizaciones Recientes"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = modal
 
-- ScrollingFrame para la lista de updates
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -20, 1, -100)
scrolling.Position = UDim2.new(0, 10, 0, 70)
scrolling.BackgroundTransparency = 1
scrolling.ScrollBarThickness = 6
scrolling.Parent = modal
 
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 12)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrolling
 
-- Botón cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.Text = "✖"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = modal
 
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton
 
-- ==================== LISTA DE ACTUALIZACIONES ====================
-- ¡Agrega o quita líneas aquí! Lo más reciente va arriba.
local updates = {
"[v1.5] Nuevo poder agregado a la tienda 🔥",
"[v1.5] Nuevo muro de Stranger Things 5 agregado 🧟",
"[v1.5] Nueva torre agregada 🏰",
"[v1.4] Mejoras en el rendimiento del juego",
"[v1.4] Nuevos efectos visuales en las torres",
"[v1.3] Corrección de bugs menores",
}
 
-- Crear los TextLabels dinámicamente (lo más nuevo arriba)
for i, updateText in ipairs(updates) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 50)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.Text = "• " .. updateText
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Font = Enum.Font.Gotham
    label.LayoutOrder = i  -- Orden natural (1 = arriba)
    label.Parent = scrolling
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 8)
    labelCorner.Parent = label
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = label
end
 
-- Ajustar CanvasSize del ScrollingFrame
scrolling.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
 
-- ==================== BOTÓN EN LA TOP BAR ====================
local updatesIcon = Icon.new()
updatesIcon:setName("Actualizaciones")
updatesIcon:setLabel("Actualizaciones")
updatesIcon:setImage("rbxassetid://6034834840")  -- Icono de campana (puedes cambiarlo)
updatesIcon:setOrder(10)  -- Orden para que no se superponga
updatesIcon:align("Right")  -- A la derecha, al lado de los iconos de Roblox
 
-- Eventos del icono
updatesIcon.selected:Connect(function()
    modal.Visible = true
end)
 
updatesIcon.deselected:Connect(function()
    modal.Visible = false
end)
 
-- Cerrar con el botón X
closeButton.MouseButton1Click:Connect(function()
    modal.Visible = false
    updatesIcon:deselect()  -- Deselecciona el icono también
end)
 
-- Opcional: cerrar al hacer clic fuera del modal (fondo oscuro)
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BackgroundTransparency = 0.5
background.Visible = false
background.Parent = screenGui
background.ZIndex = modal.ZIndex - 1
 
updatesIcon.selected:Connect(function()
    background.Visible = true
end)
updatesIcon.deselected:Connect(function()
    background.Visible = false
end)
background.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        modal.Visible = false
        background.Visible = false
        updatesIcon:deselect()
    end
end)
 

-- LOCAL SCRIPT - DANMAKU CON ICONO ESTILO ROBLOX (FONDO OVALADO + ICONO PEQUEÑO)
-- Colocar en: StarterPlayer > StarterPlayerScripts
 
wait(3)
 
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
 
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
 
print("🚀 Iniciando Danmaku Chat...")
 
-- ============================================
-- DESACTIVAR CHAT DE ROBLOX COMPLETAMENTE
-- ============================================
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    TextChatService.ChatWindowConfiguration.Enabled = false
    TextChatService.ChatInputBarConfiguration.Enabled = false
    TextChatService.ChannelTabsConfiguration.Enabled = false
end)
 
-- COLORES
local RED = Color3.fromRGB(255, 50, 50)
local BLACK = Color3.fromRGB(20, 20, 20)
local WHITE = Color3.fromRGB(255, 255, 255)
local ROBLOX_DARK = Color3.fromRGB(30, 30, 30) -- Un poco más claro para parecer UI nativa
 
-- ============================================
-- LIMPIAR CUALQUIER GUI ANTERIOR
-- ============================================
for _, gui in ipairs(playerGui:GetChildren()) do
    if gui.Name == "DanmakuChatUI" or gui.Name == "DanmakuFloating" then
        gui:Destroy()
    end
end
 
wait(0.5)
 
-- ============================================
-- CREAR GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DanmakuChatUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
 
-- ============================================
-- 1. BOTÓN CIRCULAR (IGUAL QUE LA TIENDA)
-- ============================================
local chatButton = Instance.new("ImageButton")
chatButton.Name = "ChatButtonBackground"
chatButton.Size = UDim2.new(0, 52, 0, 52)  -- MISMO TAMAÑO QUE LA TIENDA
chatButton.AnchorPoint = Vector2.new(0, 0)
chatButton.Position = UDim2.new(0, 15, 0, 225) -- DEBAJO DE LA TIENDA
chatButton.BackgroundColor3 = ROBLOX_DARK
chatButton.BackgroundTransparency = 0.2
chatButton.BorderSizePixel = 0
chatButton.AutoButtonColor = false
chatButton.Image = ""
chatButton.ZIndex = 10
chatButton.Parent = screenGui
 
-- CIRCULAR PERFECTO (igual que la tienda)
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0.5, 0) -- Circular
btnCorner.Parent = chatButton
 
-- Borde sutil (Estilo Roblox)
local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(100, 100, 100)
btnStroke.Thickness = 1
btnStroke.Transparency = 0.3
btnStroke.Parent = chatButton
 
-- ============================================
-- 2. EL ICONO (IMAGEN DENTRO) - AJUSTADO
-- ============================================
local iconImage = Instance.new("ImageLabel")
iconImage.Name = "IconImage"
iconImage.Size = UDim2.new(0, 28, 0, 28) -- Un poco más grande para el círculo de 52x52
iconImage.AnchorPoint = Vector2.new(0.5, 0.5)
iconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
iconImage.BackgroundTransparency = 1
iconImage.Image = "rbxasset://textures/ui/TopBar/chatOff.png"
iconImage.ImageColor3 = WHITE
iconImage.ScaleType = Enum.ScaleType.Fit
iconImage.ZIndex = 11
iconImage.Parent = chatButton
 
-- ============================================
-- FLECHITA TRIANGULAR (INDICADOR)
-- ============================================
local arrow = Instance.new("ImageLabel")
arrow.Name = "Arrow"
arrow.Size = UDim2.new(0, 12, 0, 8)
arrow.Position = UDim2.new(0.5, 0, 1, 4) -- Justo debajo del botón
arrow.AnchorPoint = Vector2.new(0.5, 0)
arrow.BackgroundTransparency = 1
arrow.Image = "rbxasset://textures/ui/TopBar/inventoryOn.png"
arrow.ImageColor3 = ROBLOX_DARK
arrow.Rotation = 180
arrow.Visible = false
arrow.ZIndex = 9
arrow.Parent = chatButton
 
print("✅ UI Creada: Estilo Roblox (Fondo ancho + Icono centrado)")
 
-- Efecto Hover (Animación suave)
chatButton.MouseEnter:Connect(function()
    TweenService:Create(chatButton, TweenInfo.new(0.2), {
    BackgroundTransparency = 0,
    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }):Play()
end)
 
chatButton.MouseLeave:Connect(function()
    if not arrow.Visible then -- Solo si no está abierto
        TweenService:Create(chatButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2,
        BackgroundColor3 = ROBLOX_DARK
        }):Play()
    end
end)
 
-- ============================================
-- PANEL DE INPUT
-- ============================================
local inputPanel = Instance.new("Frame")
inputPanel.Size = UDim2.new(0, 400, 0, 90)
inputPanel.AnchorPoint = Vector2.new(1, 0)
inputPanel.Position = UDim2.new(1, -12, 0, 64) -- Ajustado a la nueva altura del botón
inputPanel.BackgroundColor3 = BLACK
inputPanel.BackgroundTransparency = 0.15
inputPanel.Visible = false
inputPanel.ZIndex = 9
inputPanel.Parent = screenGui
 
local panelStroke = Instance.new("UIStroke")
panelStroke.Color = RED
panelStroke.Thickness = 2
panelStroke.Parent = inputPanel
 
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 8)
panelCorner.Parent = inputPanel
 
-- Avatar
local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 45, 0, 45)
avatar.Position = UDim2.new(0, 8, 0, 8)
avatar.BackgroundTransparency = 1
avatar.ZIndex = 11
avatar.Parent = inputPanel
 
task.spawn(function()
    local s, url = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if s then avatar.Image = url end
end)
 
local avCorner = Instance.new("UICorner")
avCorner.CornerRadius = UDim.new(1, 0)
avCorner.Parent = avatar
 
local avStroke = Instance.new("UIStroke")
avStroke.Color = RED
avStroke.Thickness = 2
avStroke.Parent = avatar
 
-- Nombre
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 330, 0, 20)
nameLabel.Position = UDim2.new(0, 60, 0, 10)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = player.DisplayName
nameLabel.TextColor3 = WHITE
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.ZIndex = 11
nameLabel.Parent = inputPanel
 
-- Input Box
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -68, 0, 40)
inputBox.Position = UDim2.new(0, 60, 0, 38)
inputBox.BackgroundColor3 = BLACK
inputBox.BackgroundTransparency = 0.3
inputBox.PlaceholderText = "Escribe aquí..."
inputBox.Text = ""
inputBox.TextColor3 = RED
inputBox.PlaceholderColor3 = Color3.fromRGB(150, 30, 30)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Center
inputBox.ClearTextOnFocus = false
inputBox.ClipsDescendants = true
inputBox.ZIndex = 11
inputBox.Parent = inputPanel
 
local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 10)
inputPadding.PaddingRight = UDim.new(0, 10)
inputPadding.Parent = inputBox
 
local boxStroke = Instance.new("UIStroke")
boxStroke.Color = RED
boxStroke.Thickness = 2
boxStroke.Parent = inputBox
 
local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = inputBox
 
print("✅ Panel creado")
 
-- ============================================
-- DANMAKU (MENSAJES FLOTANTES)
-- ============================================
local floatingGui = Instance.new("ScreenGui")
floatingGui.Name = "DanmakuFloating"
floatingGui.ResetOnSpawn = false
floatingGui.IgnoreGuiInset = true
floatingGui.Parent = playerGui
 
local container = Instance.new("Frame")
container.Size = UDim2.new(1.5, 0, 1, 0)
container.Position = UDim2.new(-0.25, 0, 0, 0)
container.BackgroundTransparency = 1
container.ClipsDescendants = false
container.ZIndex = 5000
container.Parent = floatingGui
 
local activeBubbles = {}
local usedRows = {}
local MAX_BUBBLES = 30
 
local function getFreeRow()
    local cam = workspace.CurrentCamera
    local screenHeight = cam.ViewportSize.Y
    local rowHeight = 44
    local minY = 70
    local maxY = screenHeight - 100
    local totalRows = math.floor((maxY - minY) / rowHeight)
    
    for row, bubble in pairs(usedRows) do
        if not bubble or not bubble.Parent then
            usedRows[row] = nil
        end
    end
    
    for i = 0, totalRows do
        if not usedRows[i] then
            return minY + (i * rowHeight), i
        end
    end
    
    return math.random(minY, maxY), math.random(0, totalRows)
end
 
local function createDanmaku(message)
    if not message then return end
    
    local source = message.TextSource
    local text = message.Text
    
    if not source or not text or text == "" then return end
    
    local displayName = "Usuario"
    if source.UserId then
        local s, p = pcall(function()
            return Players:GetPlayerByUserId(source.UserId)
        end)
        if s and p then
            displayName = p.DisplayName or p.Name
        end
    end
    
    -- Limpieza de burbujas viejas
    while #activeBubbles >= MAX_BUBBLES do
        local oldest = table.remove(activeBubbles, 1)
        if oldest and oldest.Parent then oldest:Destroy() end
    end
    
    local yPos, rowIndex = getFreeRow()
    local cam = workspace.CurrentCamera
    local screenWidth = cam.ViewportSize.X
    
    -- BURBUJA ESTILIZADA
    local bubble = Instance.new("Frame")
    bubble.Size = UDim2.new(0, 200, 0, 36)
    bubble.Position = UDim2.new(0, screenWidth + 100, 0, yPos)
    bubble.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    bubble.BackgroundTransparency = 0.1
    bubble.ClipsDescendants = false
    bubble.ZIndex = 5001
    bubble.Parent = container
    
    local bStroke = Instance.new("UIStroke")
    bStroke.Color = RED
    bStroke.Thickness = 2
    bStroke.Parent = bubble
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = bubble
    
    -- Sombra roja detrás
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = RED
    shadow.BackgroundTransparency = 0.75
    shadow.ZIndex = 5000
    shadow.Parent = bubble
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(1, 0)
    shadowCorner.Parent = shadow
    
    local bAvatar = Instance.new("ImageLabel")
    bAvatar.Size = UDim2.new(0, 30, 0, 30)
    bAvatar.Position = UDim2.new(0, 3, 0.5, -15)
    bAvatar.BackgroundTransparency = 1
    bAvatar.ZIndex = 5002
    bAvatar.Parent = bubble
    
    task.spawn(function()
        local s, url = pcall(function()
            return Players:GetUserThumbnailAsync(source.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if s and bAvatar then bAvatar.Image = url end
    end)
    
    local bAvCorner = Instance.new("UICorner")
    bAvCorner.CornerRadius = UDim.new(1, 0)
    bAvCorner.Parent = bAvatar
    
    local bText = Instance.new("TextLabel")
    bText.Size = UDim2.new(1, -38, 1, 0)
    bText.Position = UDim2.new(0, 35, 0, 0)
    bText.BackgroundTransparency = 1
    bText.Text = displayName .. ": " .. text
    bText.TextColor3 = WHITE
    bText.Font = Enum.Font.GothamBold
    bText.TextSize = 13
    bText.TextXAlignment = Enum.TextXAlignment.Left
    bText.TextYAlignment = Enum.TextYAlignment.Center
    bText.TextWrapped = false
    bText.TextStrokeTransparency = 0.2
    bText.TextStrokeColor3 = BLACK
    bText.ZIndex = 5002
    bText.Parent = bubble
    
    local textService = game:GetService("TextService")
    local bounds = textService:GetTextSize(bText.Text, bText.TextSize, bText.Font, Vector2.new(9999, 36))
    local finalWidth = math.clamp(bounds.X + 42, 150, 480)
    bubble.Size = UDim2.new(0, finalWidth, 0, 36)
    
    table.insert(activeBubbles, bubble)
    usedRows[rowIndex] = bubble
    
    -- Animación
    local duration = 12 -- Velocidad
    local endX = -finalWidth - 200
    
    local slideIn = TweenService:Create(
    bubble,
    TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Position = UDim2.new(0, screenWidth - finalWidth - 10, 0, yPos)}
    )
    slideIn:Play()
    
    slideIn.Completed:Connect(function()
        local slideAcross = TweenService:Create(
        bubble,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Position = UDim2.new(0, endX, 0, yPos)}
        )
        slideAcross:Play()
        
        -- Efecto latido en borde
        task.spawn(function()
            for i = 1, duration * 2 do
                if not bubble or not bubble.Parent then break end
                TweenService:Create(bStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Thickness = 3}):Play()
                wait(0.5)
                if not bubble or not bubble.Parent then break end
                TweenService:Create(bStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Thickness = 2}):Play()
                wait(0.5)
            end
        end)
    end)
    
    -- Limpieza automática
    wait(duration + 0.3 - 2)
    if bubble and bubble.Parent then
        local fadeInfo = TweenInfo.new(2)
        TweenService:Create(bubble, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(bStroke, fadeInfo, {Transparency = 1}):Play()
        TweenService:Create(shadow, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(bText, fadeInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
        TweenService:Create(bAvatar, fadeInfo, {ImageTransparency = 1}):Play()
        
        wait(2)
        if bubble and bubble.Parent then
            bubble:Destroy()
            local idx = table.find(activeBubbles, bubble)
            if idx then table.remove(activeBubbles, idx) end
            usedRows[rowIndex] = nil
        end
    end
end
 
-- CONECTAR CHAT
local success, general = pcall(function()
    return TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
end)
 
if not success or not general then
    warn("❌ No se pudo conectar al chat")
    return
end
 
print("✅ Chat conectado")
general.MessageReceived:Connect(createDanmaku)
 
-- ============================================
-- TOGGLE PANEL
-- ============================================
local panelOpen = false
 
local function togglePanel()
    panelOpen = not panelOpen
    
    if panelOpen then
        -- AQUI CAMBIAMOS LA IMAGEN DEL HIJO (ICONIMAGE), NO EL BOTON
        iconImage.Image = "rbxasset://textures/ui/TopBar/chatOn.png"
        chatButton.BackgroundTransparency = 0
        
        arrow.Visible = true
        arrow.ImageTransparency = 1
        TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        ImageTransparency = 0
        }):Play()
        
        inputPanel.Visible = true
        inputPanel.Size = UDim2.new(0, 400, 0, 0)
        TweenService:Create(inputPanel, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 90)
        }):Play()
        wait(0.21)
        inputBox:CaptureFocus()
    else
        -- AQUI CAMBIAMOS LA IMAGEN DEL HIJO (ICONIMAGE)
        iconImage.Image = "rbxasset://textures/ui/TopBar/chatOff.png"
        chatButton.BackgroundTransparency = 0.2
        
        TweenService:Create(arrow, TweenInfo.new(0.15), {
        ImageTransparency = 1
        }):Play()
        task.delay(0.15, function()
            arrow.Visible = false
        end)
        
        inputBox:ReleaseFocus()
        TweenService:Create(inputPanel, TweenInfo.new(0.15), {
        Size = UDim2.new(0, 400, 0, 0)
        }):Play()
        wait(0.16)
        inputPanel.Visible = false
    end
end
 
chatButton.MouseButton1Click:Connect(function()
    togglePanel()
end)
 
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    if input.KeyCode == Enum.KeyCode.Slash and not panelOpen then
        togglePanel()
    elseif input.KeyCode == Enum.KeyCode.Escape and panelOpen then
        togglePanel()
    end
end)
 
inputBox.FocusLost:Connect(function(enter)
    if enter and inputBox.Text ~= "" then
        print("📤 Enviando:", inputBox.Text)
        pcall(function()
            general:SendAsync(inputBox.Text)
        end)
        inputBox.Text = ""
        togglePanel()
    end
end)
 
wait(1)
pcall(function()
    general:DisplaySystemMessage("⚡ Danmaku activado ⚡")
end)
 
 
 

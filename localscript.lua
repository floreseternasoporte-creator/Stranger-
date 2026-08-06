local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")
local TweenService = game:GetService("TweenService")
 
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
 
local GROUP_ID = 249446828  -- GlamGames
 
print("=== DEBUG: Script iniciado ===")
 
-- Verificar si ya está unido
local isInGroup = player:IsInGroup(GROUP_ID)
print("=== DEBUG: ¿Estás en GlamGames? ===", isInGroup)
 
if isInGroup then
    print("=== DEBUG: Ya estás unido, no muestro GUI ===")
    return
end
 
print("=== DEBUG: NO estás unido, creando GUI... ===")
 
-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ForceJoinCommunity"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
 
-- Fondo oscuro con efecto Upside Down
local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.fromScale(1, 1)
bgFrame.BackgroundColor3 = Color3.fromRGB(8, 5, 15)
bgFrame.BackgroundTransparency = 0.2
bgFrame.BorderSizePixel = 0
bgFrame.ZIndex = 1
bgFrame.Parent = screenGui
 
-- Gradiente sutil en el fondo
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 5, 25)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
}
bgGradient.Rotation = 45
bgGradient.Parent = bgFrame
 
-- Partículas flotantes estándar
for i = 1, 40 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.fromOffset(math.random(3, 10), math.random(3, 10))
    particle.Position = UDim2.fromScale(math.random(), math.random())
    particle.BackgroundColor3 = Color3.fromRGB(200, 180, 150)
    particle.BackgroundTransparency = 0.7
    particle.BorderSizePixel = 0
    particle.ZIndex = 2
    particle.Parent = bgFrame
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    spawn(function()
        while particle.Parent do
            local tweenInfo = TweenInfo.new(math.random(3, 7), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
            local goal = {
            Position = UDim2.fromScale(math.random(), math.random()),
            BackgroundTransparency = math.random(50, 90) / 100
            }
            TweenService:Create(particle, tweenInfo, goal):Play()
            wait(math.random(3, 7))
        end
    end)
end
 
-- Partículas rojas grandes
for i = 1, 12 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.fromOffset(math.random(8, 20), math.random(8, 20))
    particle.Position = UDim2.fromScale(math.random(), math.random())
    particle.BackgroundColor3 = Color3.fromRGB(140, 30, 50)
    particle.BackgroundTransparency = 0.6
    particle.BorderSizePixel = 0
    particle.ZIndex = 2
    particle.Parent = bgFrame
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    spawn(function()
        while particle.Parent do
            local tweenInfo = TweenInfo.new(math.random(10, 18), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
            local goal = {
            Position = UDim2.fromScale(math.random(), math.random()),
            BackgroundTransparency = math.random(40, 80) / 100
            }
            TweenService:Create(particle, tweenInfo, goal):Play()
            wait(math.random(8, 15))
        end
    end)
end
 
-- Vignette
local vignette = Instance.new("ImageLabel")
vignette.Size = UDim2.fromScale(1, 1)
vignette.BackgroundTransparency = 1
vignette.Image = "rbxasset://textures/ui/VignetteMask.png"
vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
vignette.ImageTransparency = 0.35
vignette.ZIndex = 3
vignette.Parent = bgFrame
 
-- Blocker
local blocker = Instance.new("TextButton")
blocker.Size = UDim2.fromScale(1, 1)
blocker.BackgroundTransparency = 1
blocker.Text = ""
blocker.Active = true
blocker.ZIndex = 5
blocker.Parent = screenGui
 
-- Content Frame principal
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0.5, 0, 0.6, 0)  -- Aumenté altura un poco para el carrusel
contentFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
contentFrame.BackgroundTransparency = 0.1
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 10
contentFrame.Parent = screenGui
 
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 20)
contentCorner.Parent = contentFrame
 
-- Gradiente moderno
local contentGradient = Instance.new("UIGradient")
contentGradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 45)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 5, 20))
}
contentGradient.Rotation = 135
contentGradient.Parent = contentFrame
 
-- Borde brillante rojo
local borderGlow = Instance.new("UIStroke")
borderGlow.Color = Color3.fromRGB(200, 40, 40)
borderGlow.Thickness = 3
borderGlow.Transparency = 0.3
borderGlow.Parent = contentFrame
 
spawn(function()
    while contentFrame.Parent do
        TweenService:Create(borderGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
        {Transparency = 0.6, Thickness = 4}):Play()
        wait(1.5)
    end
end)
 
-- Sombra roja
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.fromScale(1.05, 1.05)
shadow.Position = UDim2.fromScale(-0.025, -0.025)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/InGameMenu/TopBarShadow.png"
shadow.ImageColor3 = Color3.fromRGB(180, 30, 30)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = 9
shadow.Parent = contentFrame
 
-- Líneas decorativas
local topDecor = Instance.new("Frame")
topDecor.Size = UDim2.new(0.9, 0, 0.004, 0)
topDecor.Position = UDim2.new(0.05, 0, 0.12, 0)
topDecor.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
topDecor.BorderSizePixel = 0
topDecor.ZIndex = 15
topDecor.Parent = contentFrame
 
local topDecor2 = topDecor:Clone()
topDecor2.Size = UDim2.new(0.9, 0, 0.003, 0)
topDecor2.Position = UDim2.new(0.05, 0, 0.125, 0)
topDecor2.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
topDecor2.Parent = contentFrame
 
local topDecor3 = topDecor:Clone()
topDecor3.Size = UDim2.new(0.9, 0, 0.002, 0)
topDecor3.Position = UDim2.new(0.05, 0, 0.13, 0)
topDecor3.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
topDecor3.Parent = contentFrame
 
-- Etiqueta del carrusel
local recentLabel = Instance.new("TextLabel")
recentLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
recentLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
recentLabel.BackgroundTransparency = 1
recentLabel.Text = "ÚLTIMOS JUGADORES UNIDOS"
recentLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
recentLabel.TextScaled = true
recentLabel.Font = Enum.Font.GothamBold
recentLabel.ZIndex = 15
recentLabel.Parent = contentFrame
 
-- Carrusel de avatares
local carousel = Instance.new("ScrollingFrame")
carousel.Size = UDim2.new(0.9, 0, 0.25, 0)
carousel.Position = UDim2.new(0.05, 0, 0.23, 0)
carousel.BackgroundTransparency = 1
carousel.BorderSizePixel = 0
carousel.ScrollBarThickness = 6
carousel.ScrollBarImageColor3 = Color3.fromRGB(200, 50, 50)
carousel.ScrollingDirection = Enum.ScrollingDirection.X
carousel.AutomaticCanvasSize = Enum.AutomaticSize.X
carousel.ZIndex = 15
carousel.Parent = contentFrame
 
local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.Padding = UDim.new(0, 15)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Parent = carousel
 
-- Lista de jugadores recientes
local recentPlayers = {}
 
local function updateCarousel()
    -- Limpiar avatares antiguos
    for _, child in ipairs(carousel:GetChildren()) do
        if child:IsA("ImageButton") then
            child:Destroy()
        end
    end
    
    -- Agregar los más recientes (máx 12)
    for i = 1, math.min(12, #recentPlayers) do
        local plr = recentPlayers[i]
        if plr and plr.UserId then
            local content, _ = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            
            local avatarButton = Instance.new("ImageButton")
            avatarButton.Size = UDim2.fromOffset(70, 70)
            avatarButton.BackgroundTransparency = 1
            avatarButton.Image = content
            avatarButton.ZIndex = 16
            avatarButton.Parent = carousel
            
            local avatarCorner = Instance.new("UICorner")
            avatarCorner.CornerRadius = UDim.new(1, 0)
            avatarCorner.Parent = avatarButton
            
            local avatarStroke = Instance.new("UIStroke")
            avatarStroke.Color = Color3.fromRGB(255, 120, 120)
            avatarStroke.Thickness = 2
            avatarStroke.Transparency = 0.4
            avatarStroke.Parent = avatarButton
            
            -- Hover effect
            avatarButton.MouseEnter:Connect(function()
                TweenService:Create(avatarStroke, TweenInfo.new(0.2), {Transparency = 0, Thickness = 3}):Play()
                TweenService:Create(avatarButton, TweenInfo.new(0.2), {Size = UDim2.fromOffset(75, 75)}):Play()
            end)
            avatarButton.MouseLeave:Connect(function()
                TweenService:Create(avatarStroke, TweenInfo.new(0.2), {Transparency = 0.4, Thickness = 2}):Play()
                TweenService:Create(avatarButton, TweenInfo.new(0.2), {Size = UDim2.fromOffset(70, 70)}):Play()
            end)
            
            -- Click → mostrar info
            avatarButton.MouseButton1Click:Connect(function()
                showPlayerInfo(plr)
            end)
        end
    end
end
 
-- Popup de información del jugador
local currentInfoGui = nil
 
local function showPlayerInfo(plr)
    if currentInfoGui then currentInfoGui:Destroy() end
    
    currentInfoGui = Instance.new("Frame")
    currentInfoGui.Size = UDim2.new(0.35, 0, 0.45, 0)
    currentInfoGui.Position = UDim2.new(0.325, 0, 0.275, 0)
    currentInfoGui.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
    currentInfoGui.BackgroundTransparency = 0.1
    currentInfoGui.ZIndex = 20
    currentInfoGui.Parent = screenGui
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 20)
    infoCorner.Parent = currentInfoGui
    
    local infoStroke = Instance.new("UIStroke")
    infoStroke.Color = Color3.fromRGB(200, 40, 40)
    infoStroke.Thickness = 3
    infoStroke.Parent = currentInfoGui
    
    -- Thumbnail grande
    local bigThumb, _ = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    local thumbImg = Instance.new("ImageLabel")
    thumbImg.Size = UDim2.fromOffset(120, 120)
    thumbImg.Position = UDim2.new(0.5, -60, 0.1, 0)
    thumbImg.BackgroundTransparency = 1
    thumbImg.Image = bigThumb
    thumbImg.ZIndex = 21
    thumbImg.Parent = currentInfoGui
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumbImg
    
    -- Info texto
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
    nameLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.DisplayName
    nameLabel.TextColor3 = Color3.fromRGB(255, 240, 230)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.ZIndex = 21
    nameLabel.Parent = currentInfoGui
    
    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(0.9, 0, 0.12, 0)
    userLabel.Position = UDim2.new(0.05, 0, 0.58, 0)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "@" .. plr.Name
    userLabel.TextColor3 = Color3.fromRGB(200, 180, 170)
    userLabel.TextScaled = true
    userLabel.Font = Enum.Font.Gotham
    userLabel.ZIndex = 21
    userLabel.Parent = currentInfoGui
    
    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
    idLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "ID: " .. plr.UserId
    idLabel.TextColor3 = Color3.fromRGB(150, 130, 120)
    idLabel.TextScaled = true
    idLabel.Font = Enum.Font.Gotham
    idLabel.ZIndex = 21
    idLabel.Parent = currentInfoGui
    
    -- Botón cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(40, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 22
    closeBtn.Parent = currentInfoGui
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        currentInfoGui:Destroy()
        currentInfoGui = nil
    end)
end
 
-- Gestión de jugadores recientes
local function addRecentPlayer(plr)
    if plr == player then return end
    table.insert(recentPlayers, 1, plr)
    if #recentPlayers > 15 then
        table.remove(recentPlayers)
    end
    updateCarousel()
end
 
local function removeRecentPlayer(plr)
    for i, p in ipairs(recentPlayers) do
        if p == plr then
            table.remove(recentPlayers, i)
            break
        end
    end
    updateCarousel()
end
 
-- Jugadores ya presentes
for _, plr in ipairs(Players:GetPlayers()) do
    addRecentPlayer(plr)
end
 
-- Eventos en tiempo real
Players.PlayerAdded:Connect(addRecentPlayer)
Players.PlayerRemoving:Connect(removeRecentPlayer)
 
-- Título (movido más abajo)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.9, 0, 0.12, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0.50, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "¡ÚNETE A GLAMGAMES!"
titleLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.ZIndex = 15
titleLabel.Parent = contentFrame
 
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(180, 20, 20)
titleStroke.Thickness = 4
titleStroke.Transparency = 0.3
titleStroke.Parent = titleLabel
 
spawn(function()
    while titleLabel.Parent do
        TweenService:Create(titleStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
        {Transparency = 0.7}):Play()
        wait(2)
    end
end)
 
-- Descripción (movida más abajo)
local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(0.85, 0, 0.18, 0)
descLabel.Position = UDim2.new(0.075, 0, 0.64, 0)
descLabel.BackgroundTransparency = 1
descLabel.Text = "Para continuar jugando y acceder al contenido,\ndebes unirte a nuestra comunidad oficial.\n\n¡Es OBLIGATORIO para jugar!"
descLabel.TextColor3 = Color3.fromRGB(240, 230, 220)
descLabel.TextScaled = true
descLabel.Font = Enum.Font.Gotham
descLabel.TextXAlignment = Enum.TextXAlignment.Center
descLabel.ZIndex = 15
descLabel.Parent = contentFrame
 
-- Botón (movido más abajo)
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0.75, 0, 0.12, 0)
joinButton.Position = UDim2.new(0.125, 0, 0.85, 0)
joinButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
joinButton.Text = "UNIRME AHORA"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextScaled = true
joinButton.Font = Enum.Font.GothamBold
joinButton.ZIndex = 15
joinButton.Parent = contentFrame
 
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 15)
buttonCorner.Parent = joinButton
 
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 30, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 20, 30))
}
buttonGradient.Rotation = 90
buttonGradient.Parent = joinButton
 
local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 120, 120)
buttonStroke.Thickness = 2.5
buttonStroke.Transparency = 0.2
buttonStroke.Parent = joinButton
 
local buttonGlow = Instance.new("Frame")
buttonGlow.Size = UDim2.fromScale(1, 1)
buttonGlow.BackgroundColor3 = Color3.fromRGB(255, 180, 180)
buttonGlow.BackgroundTransparency = 0.7
buttonGlow.BorderSizePixel = 0
buttonGlow.ZIndex = 14
buttonGlow.Parent = joinButton
 
local buttonGlowCorner = Instance.new("UICorner")
buttonGlowCorner.CornerRadius = UDim.new(0, 15)
buttonGlowCorner.Parent = buttonGlow
 
-- Hover y pulso del botón (mismo que antes)
local originalColor = joinButton.BackgroundColor3
joinButton.MouseEnter:Connect(function()
    TweenService:Create(joinButton, TweenInfo.new(0.2), {
    BackgroundColor3 = Color3.fromRGB(220, 50, 50),
    Size = UDim2.new(0.77, 0, 0.125, 0)
    }):Play()
    TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Thickness = 4, Transparency = 0}):Play()
    TweenService:Create(buttonGlow, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
end)
 
joinButton.MouseLeave:Connect(function()
    TweenService:Create(joinButton, TweenInfo.new(0.2), {
    BackgroundColor3 = originalColor,
    Size = UDim2.new(0.75, 0, 0.12, 0)
    }):Play()
    TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Thickness = 2.5, Transparency = 0.2}):Play()
    TweenService:Create(buttonGlow, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
end)
 
spawn(function()
    while joinButton.Parent do
        TweenService:Create(buttonGlow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
        {BackgroundTransparency = 0.9}):Play()
        wait(1)
    end
end)
 
-- Footer
local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(0.9, 0, 0.05, 0)
footerLabel.Position = UDim2.new(0.05, 0, 0.94, 0)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "~ Powered by GlamGames Community ~"
footerLabel.TextColor3 = Color3.fromRGB(160, 140, 130)
footerLabel.TextScaled = true
footerLabel.Font = Enum.Font.GothamMedium
footerLabel.TextTransparency = 0.4
footerLabel.ZIndex = 15
footerLabel.Parent = contentFrame
 
-- Prompt join
local function promptJoin()
    TweenService:Create(joinButton, TweenInfo.new(0.1), {Size = UDim2.new(0.73, 0, 0.115, 0)}):Play()
    wait(0.1)
    TweenService:Create(joinButton, TweenInfo.new(0.1), {Size = UDim2.new(0.75, 0, 0.12, 0)}):Play()
    
    local success, result = pcall(function()
        return GroupService:PromptJoinAsync(GROUP_ID)
    end)
    if success then
        print("=== DEBUG: Prompt enviado OK ===", result)
    else
        print("=== DEBUG: Error en prompt:", result)
    end
end
joinButton.MouseButton1Click:Connect(promptJoin)
 
-- Loop chequeo + fade-out
spawn(function()
    while screenGui.Parent do
        if player:IsInGroup(GROUP_ID) then
            print("=== DEBUG: ¡TE UNISTE! Desvaneciendo GUI... ===")
            
            local fadeInfo = TweenInfo.new(0.9, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            
            -- Fade de elementos principales
            TweenService:Create(bgFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(vignette, fadeInfo, {ImageTransparency = 1}):Play()
            TweenService:Create(contentFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(borderGlow, fadeInfo, {Transparency = 1}):Play()
            TweenService:Create(titleLabel, fadeInfo, {TextTransparency = 1}):Play()
            TweenService:Create(descLabel, fadeInfo, {TextTransparency = 1}):Play()
            TweenService:Create(joinButton, fadeInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(footerLabel, fadeInfo, {TextTransparency = 1}):Play()
            TweenService:Create(recentLabel, fadeInfo, {TextTransparency = 1}):Play()
            
            -- Fade partículas
            for _, child in ipairs(bgFrame:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChild("UICorner") then
                    TweenService:Create(child, fadeInfo, {BackgroundTransparency = 1}):Play()
                end
            end
            
            wait(0.9)
            screenGui:Destroy()
            break
        end
        wait(1)
    end
end)
 
print("=== DEBUG: GUI COMPLETA creada y visible ===")
 

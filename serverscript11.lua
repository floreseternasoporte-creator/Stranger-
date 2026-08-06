-- SISTEMA DE WALKIE-TALKIES Y MISIONES
-- ServerScriptService
 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
 
local missionDataStore = DataStoreService:GetDataStore("MissionData_v1")
 
-- Esperar a que el sistema de madera esté listo
while not _G.AddWood do
    task.wait(0.1)
end
 
print("✅ Sistema de Walkie-Talkies iniciando...")
 
-- Crear eventos
local missionEvents = Instance.new("Folder")
missionEvents.Name = "MissionEvents"
missionEvents.Parent = ReplicatedStorage
 
local walkieTalkieFound = Instance.new("RemoteEvent")
walkieTalkieFound.Name = "WalkieTalkieFound"
walkieTalkieFound.Parent = missionEvents
 
local getMissionData = Instance.new("RemoteFunction")
getMissionData.Name = "GetMissionData"
getMissionData.Parent = missionEvents
 
-- Datos de jugadores
local playerMissions = {}
 
-- POSICIONES DE WALKIE-TALKIES (15 distribuidos por el mapa)
local WALKIE_POSITIONS = {
Vector3.new(50, 5, 50),
Vector3.new(-80, 5, 120),
Vector3.new(150, 5, -60),
Vector3.new(-120, 5, -90),
Vector3.new(200, 5, 200),
Vector3.new(-200, 5, 150),
Vector3.new(100, 5, -150),
Vector3.new(-150, 5, 50),
Vector3.new(0, 5, 180),
Vector3.new(180, 5, 0),
Vector3.new(-100, 5, -150),
Vector3.new(250, 5, -100),
Vector3.new(-250, 5, -50),
Vector3.new(80, 5, -200),
Vector3.new(-50, 5, 250)
}
 
-- Cargar datos del jugador
local function loadPlayerMissions(player)
    local userId = player.UserId
    local key = "Mission_" .. userId
    
    local success, data = pcall(function()
        return missionDataStore:GetAsync(key)
    end)
    
    if success and data then
        playerMissions[userId] = data
        print("📋 Misiones cargadas para " .. player.Name)
    else
        playerMissions[userId] = {
        TreesCut = 0,
        WalkiesTalkiesFound = 0,
        Missions = {
        CutTrees = false,
        FindWalkieTalkie = false
        }
        }
        print("📋 Nuevas misiones para " .. player.Name)
    end
    
    -- Crear leaderstats para walkie-talkies
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local walkiesValue = Instance.new("IntValue")
        walkiesValue.Name = "Walkies"
        walkiesValue.Value = playerMissions[userId].WalkiesTalkiesFound
        walkiesValue.Parent = leaderstats
    end
    
    return playerMissions[userId]
end
 
-- Guardar datos
local function savePlayerMissions(player)
    local userId = player.UserId
    local key = "Mission_" .. userId
    
    if not playerMissions[userId] then return end
    
    local success, err = pcall(function()
        missionDataStore:SetAsync(key, playerMissions[userId])
    end)
    
    if success then
        print("💾 Misiones guardadas para " .. player.Name)
    else
        warn("❌ Error guardando misiones: " .. tostring(err))
    end
end
 
-- Crear walkie-talkie físico
local function createWalkieTalkie(position, index)
    local walkie = Instance.new("Model")
    walkie.Name = "WalkieTalkie_" .. index
    
    -- Base del walkie-talkie
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(1.5, 3, 0.8)
    base.Position = position
    base.Anchored = true
    base.CanCollide = false
    base.Material = Enum.Material.Plastic
    base.Color = Color3.fromRGB(40, 40, 45)
    base.Parent = walkie
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    
    -- Antena
    local antenna = Instance.new("Part")
    antenna.Name = "Antenna"
    antenna.Size = Vector3.new(0.2, 2, 0.2)
    antenna.Position = position + Vector3.new(0, 2.5, 0)
    antenna.Anchored = true
    antenna.CanCollide = false
    antenna.Material = Enum.Material.Metal
    antenna.Color = Color3.fromRGB(80, 80, 85)
    antenna.Parent = walkie
    
    -- Pantalla
    local screen = Instance.new("Part")
    screen.Name = "Screen"
    screen.Size = Vector3.new(1.2, 1, 0.1)
    screen.Position = position + Vector3.new(0, 0.8, 0.45)
    screen.Anchored = true
    screen.CanCollide = false
    screen.Material = Enum.Material.Neon
    screen.Color = Color3.fromRGB(100, 255, 150)
    screen.Parent = walkie
    
    -- Botones
    for i = 1, 3 do
        local button = Instance.new("Part")
        button.Name = "Button" .. i
        button.Size = Vector3.new(0.3, 0.3, 0.15)
        button.Position = position + Vector3.new((i - 2) * 0.4, -0.5, 0.5)
        button.Anchored = true
        button.CanCollide = false
        button.Material = Enum.Material.Plastic
        button.Color = Color3.fromRGB(200, 50, 50)
        button.Parent = walkie
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(1, 0)
    end
    
    -- Luz pulsante
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(100, 255, 150)
    light.Brightness = 3
    light.Range = 15
    light.Parent = screen
    
    -- Animación de luz
    task.spawn(function()
        while walkie.Parent do
            light.Brightness = 3
            task.wait(0.5)
            light.Brightness = 1
            task.wait(0.5)
        end
    end)
    
    -- ProximityPrompt
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Recoger Walkie-Talkie"
    prompt.ObjectText = "📻 Walkie-Talkie"
    prompt.HoldDuration = 1
    prompt.MaxActivationDistance = 10
    prompt.Parent = base
    
    walkie.PrimaryPart = base
    walkie.Parent = workspace
    
    return walkie, prompt
end
 
-- Spawn walkie-talkies
local walkieTalkies = {}
for i, pos in ipairs(WALKIE_POSITIONS) do
    local walkie, prompt = createWalkieTalkie(pos, i)
    table.insert(walkieTalkies, {model = walkie, prompt = prompt, collected = {}})
    
    prompt.Triggered:Connect(function(player)
        local userId = player.UserId
        
        -- Verificar si ya lo recogió
        if walkieTalkies[i].collected[userId] then
            return
        end
        
        -- Marcar como recogido
        walkieTalkies[i].collected[userId] = true
        
        -- Actualizar datos
        if playerMissions[userId] then
            playerMissions[userId].WalkiesTalkiesFound = playerMissions[userId].WalkiesTalkiesFound + 1
            
            -- Actualizar leaderstats
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats and leaderstats:FindFirstChild("Walkies") then
                leaderstats.Walkies.Value = playerMissions[userId].WalkiesTalkiesFound
            end
            
            -- Completar misión si es el primero
            if playerMissions[userId].WalkiesTalkiesFound >= 1 and not playerMissions[userId].Missions.FindWalkieTalkie then
                playerMissions[userId].Missions.FindWalkieTalkie = true
                print("✅ " .. player.Name .. " completó: Encontrar Walkie-Talkie")
            end
            
            savePlayerMissions(player)
        end
        
        -- Notificar al cliente
        walkieTalkieFound:FireClient(player, playerMissions[userId].WalkiesTalkiesFound)
        
        -- Efecto visual
        local explosion = Instance.new("Part")
        explosion.Shape = Enum.PartType.Ball
        explosion.Size = Vector3.new(1, 1, 1)
        explosion.Position = walkie.PrimaryPart.Position
        explosion.Anchored = true
        explosion.CanCollide = false
        explosion.Material = Enum.Material.Neon
        explosion.Color = Color3.fromRGB(100, 255, 150)
        explosion.Transparency = 0.3
        explosion.Parent = workspace
        
        local TweenService = game:GetService("TweenService")
        TweenService:Create(explosion, TweenInfo.new(0.5), {
        Size = Vector3.new(8, 8, 8),
        Transparency = 1
        }):Play()
        
        game:GetService("Debris"):AddItem(explosion, 0.5)
        
        -- Hacer desaparecer el walkie-talkie completamente
        for _, part in ipairs(walkie:GetDescendants()) do
            if part:IsA("BasePart") then
                TweenService:Create(part, TweenInfo.new(0.5), {Transparency = 1}):Play()
            elseif part:IsA("PointLight") then
                TweenService:Create(part, TweenInfo.new(0.5), {Brightness = 0}):Play()
            end
        end
        
        -- Desactivar el prompt
        prompt.Enabled = false
        
        -- Destruir después de la animación
        task.delay(0.5, function()
            walkie:Destroy()
        end)
    end)
end
 
-- Sistema de detección de árboles cortados
local function setupTreeDetection()
    -- Conectar con el sistema de madera existente
    local originalAddWood = _G.AddWood
    
    _G.AddWood = function(player, amount)
        originalAddWood(player, amount)
        
        -- Si es madera positiva (cortó árbol)
        if amount > 0 then
            local userId = player.UserId
            if playerMissions[userId] then
                playerMissions[userId].TreesCut = playerMissions[userId].TreesCut + 1
                
                -- Completar misión si cortó 5 árboles
                if playerMissions[userId].TreesCut >= 5 and not playerMissions[userId].Missions.CutTrees then
                    playerMissions[userId].Missions.CutTrees = true
                    print("✅ " .. player.Name .. " completó: Cortar 5 árboles")
                    savePlayerMissions(player)
                end
            end
        end
    end
end
 
setupTreeDetection()
 
-- Función para obtener datos de misiones
getMissionData.OnServerInvoke = function(player)
    local userId = player.UserId
    return playerMissions[userId]
end
 
-- Eventos de jugador
Players.PlayerAdded:Connect(function(player)
    loadPlayerMissions(player)
end)
 
Players.PlayerRemoving:Connect(function(player)
    savePlayerMissions(player)
    playerMissions[player.UserId] = nil
end)
 
-- Auto-guardado cada 5 minutos
task.spawn(function()
    while true do
        task.wait(300)
        for _, player in ipairs(Players:GetPlayers()) do
            savePlayerMissions(player)
        end
    end
end)
 
-- Guardar al cerrar servidor
game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        savePlayerMissions(player)
    end
    task.wait(3)
end)
 
print("✅ Sistema de Walkie-Talkies y Misiones activo!")
print("📻 " .. #walkieTalkies .. " walkie-talkies spawneados")
 

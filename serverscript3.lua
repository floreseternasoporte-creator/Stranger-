-- Script de DataStore para guardar la madera
-- Coloca este script en ServerScriptService
 
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
 
local woodDataStore = DataStoreService:GetDataStore("WoodData_v1")
 
-- Tabla para almacenar datos en sesión
local playerData = {}
 
-- Función para cargar datos
local function loadPlayerData(player)
    local userId = player.UserId
    local key = "Player_" .. userId
    
    local success, data = pcall(function()
        return woodDataStore:GetAsync(key)
    end)
    
    if success then
        if data then
            playerData[userId] = {
            Wood = data.Wood or 0
            }
            print("✅ Datos cargados para " .. player.Name .. ": " .. playerData[userId].Wood .. " madera")
        else
            -- Nuevo jugador
            playerData[userId] = {
            Wood = 0
            }
            print("🆕 Nuevo jugador: " .. player.Name)
        end
    else
        warn("⚠️ Error al cargar datos de " .. player.Name)
        playerData[userId] = {
        Wood = 0
        }
    end
    
    -- BONUS PARA EL CREADOR Y ADMINISTRADORA
    if player.Name == "Vegetl_t" then
        playerData[userId].Wood = 1000000
        print("👑 CREADOR DETECTADO: " .. player.Name .. " - 1,000,000 madera otorgada")
    elseif player.Name == "chany_uop" then
        playerData[userId].Wood = 1000000
        print("👑 ADMINISTRADORA DETECTADA: " .. player.Name .. " - 1,000,000 madera otorgada")
    end
    
    -- Crear leaderstats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local woodValue = Instance.new("IntValue")
    woodValue.Name = "Wood"
    woodValue.Value = playerData[userId].Wood
    woodValue.Parent = leaderstats
    
    return playerData[userId]
end
 
-- Función para guardar datos
local function savePlayerData(player)
    local userId = player.UserId
    local key = "Player_" .. userId
    
    if not playerData[userId] then
        warn("⚠️ No hay datos para guardar de " .. player.Name)
        return
    end
    
    local data = {
    Wood = playerData[userId].Wood
    }
    
    local success, errorMsg = pcall(function()
        woodDataStore:SetAsync(key, data)
    end)
    
    if success then
        print("💾 Datos guardados para " .. player.Name .. ": " .. data.Wood .. " madera")
    else
        warn("❌ Error al guardar datos de " .. player.Name .. ": " .. tostring(errorMsg))
    end
end
 
-- Función para añadir madera
local function addWood(player, amount)
    local userId = player.UserId
    
    if playerData[userId] then
        playerData[userId].Wood = playerData[userId].Wood + amount
        
        -- Actualizar leaderstats
        if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Wood") then
            player.leaderstats.Wood.Value = playerData[userId].Wood
        end
        
        print("🪵 " .. player.Name .. " ahora tiene " .. playerData[userId].Wood .. " madera (+$" .. amount .. ")")
        
        -- Guardar inmediatamente
        savePlayerData(player)
    end
end
 
-- Función para obtener madera actual
local function getWood(player)
    local userId = player.UserId
    if playerData[userId] then
        return playerData[userId].Wood
    end
    return 0
end
 
-- Eventos de jugador
Players.PlayerAdded:Connect(function(player)
    loadPlayerData(player)
end)
 
Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
    playerData[player.UserId] = nil
end)
 
-- Guardar datos cada 5 minutos (auto-save)
task.spawn(function()
    while true do
        task.wait(300) -- 5 minutos
        print("💾 Auto-guardado de datos...")
        for _, player in pairs(Players:GetPlayers()) do
            savePlayerData(player)
        end
    end
end)
 
-- Guardar todos los datos al cerrar el servidor
game:BindToClose(function()
    print("🔒 Servidor cerrando, guardando todos los datos...")
    for _, player in pairs(Players:GetPlayers()) do
        savePlayerData(player)
    end
    task.wait(3) -- Esperar a que se guarden los datos
end)
 
-- Exponer funciones globales
_G.AddWood = addWood
_G.GetWood = getWood
 
print("✅ Sistema de DataStore de madera cargado correctamente")
 

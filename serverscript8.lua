-- Script de servidor para aumentar la velocidad de los jugadores
-- Colócalo en ServerScriptService
 
local Players = game:GetService("Players")
 
-- Función para aplicar la velocidad al personaje
local function applySpeed(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 25  -- Cambia este número si quieres otra velocidad
end
 
-- Cuando un jugador entra al juego
Players.PlayerAdded:Connect(function(player)
    -- Si el personaje ya está cargado (por si el script se ejecuta tarde)
    if player.Character then
        applySpeed(player.Character)
    end
    
    -- Para personajes nuevos y respawns
    player.CharacterAdded:Connect(applySpeed)
end)
 
-- Opcional: aplicar a jugadores que ya estén en el servidor cuando insertes el script
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        applySpeed(player.Character)
    end
    player.CharacterAdded:Connect(applySpeed)
end
 

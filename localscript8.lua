-- OCULTAR BARRA DE VIDA VERDE DE ROBLOX
-- LocalScript en StarterPlayer > StarterPlayerScripts
 
local Players = game:GetService("Players")
local player = Players.LocalPlayer
 
local function hideHealthBar(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Ocultar barra de vida
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    
    -- Ocultar nombre también si quieres
    humanoid.NameDisplayDistance = 0
    humanoid.HealthDisplayDistance = 0
end
 
-- Aplicar al personaje actual
if player.Character then
    hideHealthBar(player.Character)
end
 
-- Aplicar cuando reaparezca
player.CharacterAdded:Connect(hideHealthBar)
 
print("✅ Barra de vida verde ocultada")
 

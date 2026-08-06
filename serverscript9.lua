-- SERVER SCRIPT - RemoteFunction para compra de poderes
-- ServerScriptService
 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
 
-- Esperar a que el sistema de DataStore esté listo
while not _G.AddWood do
    task.wait(0.1)
end
 
print("✅ AddWood encontrado, creando PurchasePowerEvent...")
 
local purchaseEvent = Instance.new("RemoteFunction")
purchaseEvent.Name = "PurchasePowerEvent"
purchaseEvent.Parent = ReplicatedStorage
 
purchaseEvent.OnServerInvoke = function(player, powerName, price)
    if not player or not powerName or not price then 
        warn("❌ Compra fallida: datos inválidos")
        return false 
    end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then 
        warn("❌ Compra fallida: no leaderstats")
        return false 
    end
    
    local woodValue = leaderstats:FindFirstChild("Wood")
    if not woodValue then 
        warn("❌ Compra fallida: no Wood")
        return false 
    end
    
    if woodValue.Value >= price then
        print("💰 " .. player.Name .. " comprando " .. powerName .. " por " .. price .. " madera")
        _G.AddWood(player, -price)
        print("✅ Compra exitosa! Nueva madera: " .. woodValue.Value)
        return true
    else
        warn("❌ Compra fallida: madera insuficiente (" .. woodValue.Value .. "/" .. price .. ")")
        return false
    end
end
 
print("✅ PurchasePowerEvent creado y listo")
 

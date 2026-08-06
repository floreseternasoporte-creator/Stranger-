-- PODER MINDCLONE - SERVIDOR
-- Agregar al final de serverscript4.lua
 
local mindClonePower = Instance.new("RemoteEvent")
mindClonePower.Name = "MindClonePower"
mindClonePower.Parent = powerEvents
 
POWER_CONFIG.MindClone = {
Cooldown = 30,
Duration = 3,
Range = 50,
Color = Color3.fromRGB(180, 50, 255)
}
 
local function useMindClone(player, targetPlayer)
    local character = player.Character
    local targetCharacter = targetPlayer.Character or targetPlayer
    
    if not character or not targetCharacter then 
        warn("❌ MindClone: character o targetCharacter no encontrado")
        return 
    end
    
    local isPlayer = targetPlayer:IsA("Player")
    
    if isPlayer then
        print("🧠 MindClone activado en jugador: " .. targetPlayer.Name)
        if not checkAndSetCooldown(player.UserId, "MindClone", POWER_CONFIG.MindClone.Cooldown) then return end
    else
        print("🧠 MindClone activado en NPC: " .. targetCharacter.Name)
        if not checkAndSetCooldown(player.UserId, "MindClone", POWER_CONFIG.MindClone.Cooldown) then return end
    end
    
    local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
    if distance > POWER_CONFIG.MindClone.Range then return end
    
    local config = POWER_CONFIG.MindClone
    
    -- Efectos en usuario
    local userEffects = createAdvancedParticles(character.Head, config.Color, "mindclone")
    local noseBleed = createNoseBleed(character)
    local userLight = createScreenDistortion(character, config.Color)
    
    -- Rayo zigzag hacia el objetivo
    local startPos = character.Head.Position
    local endPos = targetCharacter.Head.Position
    local segments = 20
    
    for i = 1, segments do
        local progress = i / segments
        local straightPos = startPos:Lerp(endPos, progress)
        local randomOffset = Vector3.new(
        math.random(-3, 3),
        math.random(-3, 3),
        math.random(-3, 3)
        )
        local segmentPos = straightPos + randomOffset
        
        local beam = Instance.new("Part")
        beam.Size = Vector3.new(0.3, 0.3, 2)
        beam.Position = segmentPos
        beam.Anchored = true
        beam.CanCollide = false
        beam.Material = Enum.Material.Neon
        beam.Color = config.Color
        beam.Transparency = 0.2
        beam.Parent = workspace
        
        TweenService:Create(beam, TweenInfo.new(0.5), {Transparency = 1}):Play()
        Debris:AddItem(beam, 0.5)
        
        task.wait(0.02)
    end
    
    -- Soga mental que ata al objetivo
    local rope = Instance.new("Part")
    rope.Size = Vector3.new(0.5, 0.5, distance)
    rope.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance/2)
    rope.Anchored = true
    rope.CanCollide = false
    rope.Material = Enum.Material.Neon
    rope.Color = config.Color
    rope.Transparency = 0.3
    rope.Parent = workspace
    
    -- Partículas en la soga
    for i = 1, 5 do
        local particle = Instance.new("ParticleEmitter")
        particle.Parent = rope
        particle.Texture = "rbxassetid://6101261905"
        particle.Color = ColorSequence.new(config.Color)
        particle.Size = NumberSequence.new(1, 0)
        particle.Transparency = NumberSequence.new(0, 1)
        particle.Lifetime = NumberRange.new(0.5, 1)
        particle.Rate = 100
        particle.Speed = NumberRange.new(5, 10)
        particle.SpreadAngle = Vector2.new(180, 180)
        particle.LightEmission = 1
    end
    
    -- Inmovilizar objetivo
    local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
    if targetHumanoid then
        targetHumanoid.WalkSpeed = 0
        targetHumanoid.JumpPower = 0
    end
    
    task.wait(config.Duration)
    
    -- Crear clon
    local clone = targetCharacter:Clone()
    clone.Name = targetCharacter.Name .. "_Clone"
    
    -- Hacer el clon semi-transparente y morado
    for _, part in pairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Color = config.Color
            part.Transparency = 0.3
            part.Material = Enum.Material.Neon
        end
        if part:IsA("Script") or part:IsA("LocalScript") then
            part:Destroy()
        end
    end
    
    clone.Parent = workspace
    clone:MoveTo(targetCharacter.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
    
    -- Efecto de aparición del clon
    for i = 1, 10 do
        local orb = Instance.new("Part")
        orb.Shape = Enum.PartType.Ball
        orb.Size = Vector3.new(1, 1, 1)
        orb.Position = clone.HumanoidRootPart.Position + Vector3.new(
        math.random(-3, 3),
        math.random(-3, 3),
        math.random(-3, 3)
        )
        orb.Anchored = true
        orb.CanCollide = false
        orb.Material = Enum.Material.Neon
        orb.Color = config.Color
        orb.Transparency = 0.3
        orb.Parent = workspace
        
        TweenService:Create(orb, TweenInfo.new(1), {Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}):Play()
        Debris:AddItem(orb, 1)
    end
    
    -- El clon ataca al original
    local cloneHumanoid = clone:FindFirstChild("Humanoid")
    if cloneHumanoid then
        cloneHumanoid:MoveTo(targetCharacter.HumanoidRootPart.Position)
        
        -- Hacer que el clon persiga al objetivo
        task.spawn(function()
            for i = 1, 10 do
                if clone and clone.Parent and targetCharacter and targetCharacter.Parent then
                    cloneHumanoid:MoveTo(targetCharacter.HumanoidRootPart.Position)
                    
                    -- Si está cerca, atacar
                    local dist = (clone.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
                    if dist < 5 and targetHumanoid then
                        targetHumanoid:TakeDamage(10)
                        
                        -- Efecto de golpe
                        local hit = Instance.new("Part")
                        hit.Shape = Enum.PartType.Ball
                        hit.Size = Vector3.new(3, 3, 3)
                        hit.Position = targetCharacter.HumanoidRootPart.Position
                        hit.Anchored = true
                        hit.CanCollide = false
                        hit.Material = Enum.Material.Neon
                        hit.Color = config.Color
                        hit.Transparency = 0.3
                        hit.Parent = workspace
                        
                        TweenService:Create(hit, TweenInfo.new(0.3), {Transparency = 1, Size = Vector3.new(6, 6, 6)}):Play()
                        Debris:AddItem(hit, 0.3)
                    end
                end
                task.wait(0.5)
            end
            
            -- Destruir clon con efecto
            if clone and clone.Parent then
                for _, part in pairs(clone:GetDescendants()) do
                    if part:IsA("BasePart") then
                        TweenService:Create(part, TweenInfo.new(1), {Transparency = 1}):Play()
                    end
                end
                task.wait(1)
                clone:Destroy()
            end
        end)
    end
    
    -- Restaurar objetivo
    if targetHumanoid then
        targetHumanoid.WalkSpeed = 16
        targetHumanoid.JumpPower = 50
    end
    
    -- Limpiar efectos
    rope:Destroy()
    task.wait(1)
    for _, effect in ipairs(userEffects) do effect:Destroy() end
    if noseBleed then noseBleed:Destroy() end
    if userLight then userLight:Destroy() end
end
 
mindClonePower.OnServerEvent:Connect(function(player, targetPlayer)
    if targetPlayer then
        if targetPlayer:IsA("Player") then
            useMindClone(player, targetPlayer)
        elseif targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("Humanoid") and targetPlayer:FindFirstChild("HumanoidRootPart") then
            if targetPlayer.Parent == workspace or targetPlayer:IsDescendantOf(workspace) then
                useMindClone(player, targetPlayer)
            end
        end
    end
end)
 
print("✅ Poder MindClone agregado")
 

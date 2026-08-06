local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- ==========================================
-- CONFIGURACIÓN
-- ==========================================
local CONFIG = {
TotalDemogorgons = 8,
MapSize = 500,
DetectionRange = 50,
AttackRange = 8,
PatrolSpeed = 16,
ChaseSpeed = 32,
Damage = 20,
AttackCooldown = 1.2,
PatrolWaitTime = 3,
PatrolRadius = 40,
-- NUEVO: Sistema de detección de daño
DamageDetectionRange = 100,  -- Rango para detectar proyectiles
CanTakeDamage = true
}

local COLORS = {
Skin = BrickColor.new("Dark stone grey"),
SkinDark = BrickColor.new("Really black"),
Belly = BrickColor.new("Sand red"),
InnerMouth = BrickColor.new("Crimson"),
Petal = BrickColor.new("Dusty Rose"),
PetalInner = BrickColor.new("Crimson"),
Tooth = BrickColor.new("Institutional white"),
Claw = BrickColor.new("Really black")
}

local demogorgons = {}

-- ==========================================
-- UTILIDADES
-- ==========================================
local function createPart(name, size, color, parent)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.BrickColor = color
    part.Material = Enum.Material.Plastic
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.CanCollide = false
    part.Anchored = false
    part.Massless = true
    part.Parent = parent
    return part
end

local function weldParts(part0, part1, c0)
    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = c0 or CFrame.new()
    weld.C1 = CFrame.new()
    weld.Parent = part0
    return weld
end

local function createMotor(name, part0, part1, c0, c1)
    local motor = Instance.new("Motor6D")
    motor.Name = name
    motor.Part0 = part0
    motor.Part1 = part1
    motor.C0 = c0 or CFrame.new()
    motor.C1 = c1 or CFrame.new()
    motor.Parent = part0
    return motor
end

-- ==========================================
-- CONSTRUCCIÓN DEL DEMOGORGON MEJORADO
-- ==========================================
local function buildDemogorgon(spawnPos)
    local model = Instance.new("Model")
    model.Name = "Demogorgon"
    
    -- ROOT - ÚNICO CON COLISIÓN REAL
    local root = createPart("HumanoidRootPart", Vector3.new(2,2,1), COLORS.Skin, model)
    root.Transparency = 1
    root.CanCollide = true
    root.Massless = false
    root.CFrame = CFrame.new(spawnPos)
    
    -- TORSO MEJORADO
    local torso = createPart("UpperTorso", Vector3.new(2.8,2.8,1.8), COLORS.Skin, model)
    local torsoWeld = weldParts(root, torso, CFrame.new(0, 1.2, 0))
    
    -- Detalles musculares
    local chestDetail = createPart("ChestMuscle", Vector3.new(2.2,1.8,0.6), COLORS.SkinDark, model)
    weldParts(torso, chestDetail, CFrame.new(0, 0.3, -0.7))
    
    -- Costillas
    for i = -1,1,2 do
        for r = 1,3 do
            local rib = createPart("Rib", Vector3.new(0.25,1.2,0.25), COLORS.SkinDark, model)
            weldParts(torso, rib, CFrame.new(i * 1.1, 0.8 - r * 0.6, -0.85) * CFrame.Angles(0, 0, i * math.rad(15)))
        end
    end
    
    -- ABDOMEN
    local lower = createPart("LowerTorso", Vector3.new(2.2,2.2,1.5), COLORS.Belly, model)
    local lowerWeld = weldParts(torso, lower, CFrame.new(0, -2.8, 0))
    
    -- CUELLO
    local neck = createPart("Neck", Vector3.new(1.4,1.8,1.4), COLORS.Skin, model)
    local neckWeld = weldParts(torso, neck, CFrame.new(0, 2.2, 0))
    
    -- ==========================================
    -- CABEZA MEJORADA - MÁS FIEL A LA IMAGEN
    -- ==========================================
    local headBase = createPart("HeadBase", Vector3.new(2.8,2.8,2.8), COLORS.Skin, model)
    headBase.Shape = Enum.PartType.Ball
    local headWeld = weldParts(neck, headBase, CFrame.new(0, 1.8, 0))
    
    -- Boca interna GRANDE y prominente
    local innerMouth = createPart("InnerMouth", Vector3.new(2.0,2.0,2.0), COLORS.InnerMouth, model)
    innerMouth.Shape = Enum.PartType.Ball
    weldParts(headBase, innerMouth, CFrame.new(0,0,0.7))
    
    -- Garganta profunda
    local throat = createPart("Throat", Vector3.new(1.5,1.5,1.8), BrickColor.new("Really black"), model)
    throat.Shape = Enum.PartType.Ball
    weldParts(innerMouth, throat, CFrame.new(0,0,0.5))
    
    -- Dientes internos circulares
    for i = 1,28 do
        local angle = math.rad((360/28) * i)
        local tooth = Instance.new("WedgePart")
        tooth.Name = "InnerTooth"..i
        tooth.Size = Vector3.new(0.18,1.0,0.18)
        tooth.BrickColor = COLORS.Tooth
        tooth.CanCollide = false
        tooth.Anchored = false
        tooth.Massless = true
        tooth.Parent = model
        
        local radius = 0.9
        local toothCF = CFrame.new(math.sin(angle)*radius, math.cos(angle)*radius, 0.4) 
        * CFrame.Angles(0, -angle, math.rad(90))
        weldParts(innerMouth, tooth, toothCF)
    end
    
    -- ==========================================
    -- PÉTALOS MEJORADOS - MÁS GRANDES Y VISIBLES
    -- ==========================================
    local petalWelds = {}
    for i = 1,5 do
        local angle = math.rad((360 / 5) * i)
        
        -- Pétalo principal MÁS GRANDE
        local petal = Instance.new("WedgePart")
        petal.Name = "Petal"..i
        petal.Size = Vector3.new(2.2,8.5,0.8)  -- Más grande y visible
        petal.BrickColor = COLORS.Petal
        petal.CanCollide = false
        petal.Anchored = false
        petal.Massless = true
        petal.Parent = model
        
        local baseCF = CFrame.new(math.sin(angle)*1.6, 1.0, math.cos(angle)*1.6) 
        * CFrame.Angles(math.rad(-55), angle + math.rad(180), 0)
        local petalWeld = weldParts(headBase, petal, baseCF)
        table.insert(petalWelds, {weld = petalWeld, baseCF = baseCF, angle = angle, index = i})
        
        -- Interior del pétalo más grande
        local inner = createPart("PetalInner"..i, Vector3.new(1.8,7.5,0.5), COLORS.PetalInner, model)
        weldParts(petal, inner, CFrame.new(0, -0.4, -0.25))
        
        -- Venas más visibles
        for v = 1,8 do
            local vein = createPart("Vein", Vector3.new(0.1,6.5,0.1), BrickColor.new("Maroon"), model)
            local veinX = (v - 4.5) * 0.22
            weldParts(inner, vein, CFrame.new(veinX, 0, 0.18))
        end
        
        -- Más dientes del pétalo
        for t = 1,18 do
            local tooth = Instance.new("WedgePart")
            tooth.Name = "PetalTooth"..i.."_"..t
            tooth.Size = Vector3.new(0.15,1.1,0.15)
            tooth.BrickColor = COLORS.Tooth
            tooth.CanCollide = false
            tooth.Anchored = false
            tooth.Massless = true
            tooth.Parent = model
            
            local toothY = ((t - 9.5) * 0.5)
            local toothX = (t % 2 == 0) and 0.65 or -0.65
            local toothAngle = math.rad(-35 * (toothX > 0 and 1 or -1))
            weldParts(inner, tooth, CFrame.new(toothX, toothY, 0.22) * CFrame.Angles(0, toothAngle, math.rad(45)))
        end
        
        -- Bordes más gruesos
        local edge = createPart("PetalEdge", Vector3.new(0.18,7.8,0.4), BrickColor.new("Maroon"), model)
        weldParts(petal, edge, CFrame.new(-0.9, 0, -0.2))
        local edge2 = createPart("PetalEdge2", Vector3.new(0.18,7.8,0.4), BrickColor.new("Maroon"), model)
        weldParts(petal, edge2, CFrame.new(0.9, 0, -0.2))
    end
    
    -- ==========================================
    -- BRAZOS CON MANOS CORREGIDAS
    -- ==========================================
    
    -- BRAZO DERECHO
    local rShoulder = createPart("RightShoulder", Vector3.new(1.3,1.3,1.3), COLORS.Skin, model)
    weldParts(torso, rShoulder, CFrame.new(2.2, 1, 0))
    
    local rUpperArm = createPart("RightUpperArm", Vector3.new(0.85,3.8,0.85), COLORS.Skin, model)
    local rShoulderMotor = createMotor("RightShoulderMotor", rShoulder, rUpperArm, CFrame.new(0, -0.7, 0), CFrame.new(0, 1.9, 0))
    
    local rMuscle = createPart("RightMuscle", Vector3.new(0.9,2.5,0.6), COLORS.SkinDark, model)
    weldParts(rUpperArm, rMuscle, CFrame.new(0, 0.3, -0.15))
    
    local rForeArm = createPart("RightForeArm", Vector3.new(0.75,4.2,0.75), COLORS.Skin, model)
    local rElbowMotor = createMotor("RightElbowMotor", rUpperArm, rForeArm, CFrame.new(0, -1.9, 0), CFrame.new(0, 2.1, 0))
    
    -- MANO DERECHA - CORREGIDA PARA APUNTAR ADELANTE
    local rHand = createPart("RightHand", Vector3.new(1.4,1.1,0.9), COLORS.Skin, model)
    local rHandMotor = createMotor("RightHandMotor", rForeArm, rHand, CFrame.new(0, -2.1, 0), CFrame.new(0, 0.55, 0))
    
    -- GARRAS DERECHAS - APUNTANDO HACIA ADELANTE CORRECTAMENTE
    for f = -1,1 do
        local claw = Instance.new("WedgePart")
        claw.Size = Vector3.new(0.2,2.0,0.2)
        claw.BrickColor = COLORS.Claw
        claw.CanCollide = false
        claw.Anchored = false
        claw.Massless = true
        claw.Material = Enum.Material.SmoothPlastic
        claw.Parent = model
        
        -- CORRECCIÓN FINAL: Las garras deben apuntar hacia ADELANTE (eje -Z)
        -- Rotamos en el eje X positivo para que apunten hacia donde mira el Demogorgon
        weldParts(rHand, claw, 
        CFrame.new(f * 0.4, -0.55, 0) * 
        CFrame.Angles(math.rad(90), 0, f * math.rad(10))
        )
    end
    
    -- BRAZO IZQUIERDO
    local lShoulder = createPart("LeftShoulder", Vector3.new(1.3,1.3,1.3), COLORS.Skin, model)
    weldParts(torso, lShoulder, CFrame.new(-2.2, 1, 0))
    
    local lUpperArm = createPart("LeftUpperArm", Vector3.new(0.85,3.8,0.85), COLORS.Skin, model)
    local lShoulderMotor = createMotor("LeftShoulderMotor", lShoulder, lUpperArm, CFrame.new(0, -0.7, 0), CFrame.new(0, 1.9, 0))
    
    local lMuscle = createPart("LeftMuscle", Vector3.new(0.9,2.5,0.6), COLORS.SkinDark, model)
    weldParts(lUpperArm, lMuscle, CFrame.new(0, 0.3, -0.15))
    
    local lForeArm = createPart("LeftForeArm", Vector3.new(0.75,4.2,0.75), COLORS.Skin, model)
    local lElbowMotor = createMotor("LeftElbowMotor", lUpperArm, lForeArm, CFrame.new(0, -1.9, 0), CFrame.new(0, 2.1, 0))
    
    -- MANO IZQUIERDA - CORREGIDA
    local lHand = createPart("LeftHand", Vector3.new(1.4,1.1,0.9), COLORS.Skin, model)
    local lHandMotor = createMotor("LeftHandMotor", lForeArm, lHand, CFrame.new(0, -2.1, 0), CFrame.new(0, 0.55, 0))
    
    -- GARRAS IZQUIERDAS - APUNTANDO HACIA ADELANTE
    for f = -1,1 do
        local claw = Instance.new("WedgePart")
        claw.Size = Vector3.new(0.2,2.0,0.2)
        claw.BrickColor = COLORS.Claw
        claw.CanCollide = false
        claw.Anchored = false
        claw.Massless = true
        claw.Material = Enum.Material.SmoothPlastic
        claw.Parent = model
        
        -- Misma corrección para mano izquierda
        weldParts(lHand, claw, 
        CFrame.new(f * 0.4, -0.55, 0) * 
        CFrame.Angles(math.rad(90), 0, f * math.rad(10))
        )
    end
    
    -- ==========================================
    -- PIERNAS CORREGIDAS
    -- ==========================================
    
    -- PIERNA DERECHA
    local rHip = createPart("RightHip", Vector3.new(1.3,1.2,1.3), COLORS.Skin, model)
    weldParts(lower, rHip, CFrame.new(0.8, -1.1, 0))
    
    local rThigh = createPart("RightThigh", Vector3.new(1.2,3.8,1.2), COLORS.Skin, model)
    local rHipMotor = createMotor("RightHipMotor", rHip, rThigh, CFrame.new(0, -0.6, 0), CFrame.new(0, 1.9, 0))
    
    local rThighMuscle = createPart("RightThighMuscle", Vector3.new(1.3,2.8,0.7), COLORS.SkinDark, model)
    weldParts(rThigh, rThighMuscle, CFrame.new(0, 0.3, -0.3))
    
    local rShin = createPart("RightShin", Vector3.new(0.95,3.5,0.95), COLORS.Skin, model)
    local rKneeMotor = createMotor("RightKneeMotor", rThigh, rShin, CFrame.new(0, -1.9, 0), CFrame.new(0, 1.75, 0))
    
    local rCalf = createPart("RightCalf", Vector3.new(1,2.2,0.6), COLORS.SkinDark, model)
    weldParts(rShin, rCalf, CFrame.new(0, -0.4, -0.2))
    
    -- PIE DERECHO
    local rFoot = createPart("RightFoot", Vector3.new(1.3,0.7,3.2), COLORS.Skin, model)
    local rAnkleMotor = createMotor("RightAnkleMotor", rShin, rFoot, 
    CFrame.new(0, -1.75, 0), 
    CFrame.new(0, 0.35, -1.4))
    
    -- Garras del pie
    for t = -1,1 do
        local claw = Instance.new("WedgePart")
        claw.Size = Vector3.new(0.3,1.3,0.3)
        claw.BrickColor = COLORS.Claw
        claw.CanCollide = false
        claw.Anchored = false
        claw.Massless = true
        claw.Material = Enum.Material.SmoothPlastic
        claw.Parent = model
        weldParts(rFoot, claw, CFrame.new(t * 0.4, -0.35, -1.4) * CFrame.Angles(math.rad(-85), 0, 0))
    end
    
    local rHeel = createPart("RightHeel", Vector3.new(1.1,0.6,1.2), COLORS.SkinDark, model)
    weldParts(rFoot, rHeel, CFrame.new(0, -0.15, 1))
    
    -- PIERNA IZQUIERDA
    local lHip = createPart("LeftHip", Vector3.new(1.3,1.2,1.3), COLORS.Skin, model)
    weldParts(lower, lHip, CFrame.new(-0.8, -1.1, 0))
    
    local lThigh = createPart("LeftThigh", Vector3.new(1.2,3.8,1.2), COLORS.Skin, model)
    local lHipMotor = createMotor("LeftHipMotor", lHip, lThigh, CFrame.new(0, -0.6, 0), CFrame.new(0, 1.9, 0))
    
    local lThighMuscle = createPart("LeftThighMuscle", Vector3.new(1.3,2.8,0.7), COLORS.SkinDark, model)
    weldParts(lThigh, lThighMuscle, CFrame.new(0, 0.3, -0.3))
    
    local lShin = createPart("LeftShin", Vector3.new(0.95,3.5,0.95), COLORS.Skin, model)
    local lKneeMotor = createMotor("LeftKneeMotor", lThigh, lShin, CFrame.new(0, -1.9, 0), CFrame.new(0, 1.75, 0))
    
    local lCalf = createPart("LeftCalf", Vector3.new(1,2.2,0.6), COLORS.SkinDark, model)
    weldParts(lShin, lCalf, CFrame.new(0, -0.4, -0.2))
    
    local lFoot = createPart("LeftFoot", Vector3.new(1.3,0.7,3.2), COLORS.Skin, model)
    local lAnkleMotor = createMotor("LeftAnkleMotor", lShin, lFoot, 
    CFrame.new(0, -1.75, 0), 
    CFrame.new(0, 0.35, -1.4))
    
    for t = -1,1 do
        local claw = Instance.new("WedgePart")
        claw.Size = Vector3.new(0.3,1.3,0.3)
        claw.BrickColor = COLORS.Claw
        claw.CanCollide = false
        claw.Anchored = false
        claw.Massless = true
        claw.Material = Enum.Material.SmoothPlastic
        claw.Parent = model
        weldParts(lFoot, claw, CFrame.new(t * 0.4, -0.35, -1.4) * CFrame.Angles(math.rad(-85), 0, 0))
    end
    
    local lHeel = createPart("LeftHeel", Vector3.new(1.1,0.6,1.2), COLORS.SkinDark, model)
    weldParts(lFoot, lHeel, CFrame.new(0, -0.15, 1))
    
    -- ==========================================
    -- HUMANOID CON SISTEMA DE DAÑO
    -- ==========================================
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 500
    humanoid.Health = 500
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.AutoRotate = false
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    humanoid.Parent = model
    
    -- ==========================================
    -- SONIDOS
    -- ==========================================
    local chaseSound = Instance.new("Sound")
    chaseSound.Name = "ChaseSound"
    chaseSound.SoundId = "rbxassetid://597084149"
    chaseSound.Looped = false
    chaseSound.Volume = 1
    chaseSound.RollOffMode = Enum.RollOffMode.Inverse
    chaseSound.Parent = root
    
    local footSound = Instance.new("Sound")
    footSound.Name = "Footstep"
    footSound.SoundId = "rbxassetid://4776173570"
    footSound.Looped = false
    footSound.Volume = 0.9
    footSound.RollOffMode = Enum.RollOffMode.Inverse
    footSound.Parent = root
    
    local attackSound = Instance.new("Sound")
    attackSound.Name = "AttackSound"
    attackSound.SoundId = "rbxassetid://3398620867"
    attackSound.Looped = false
    attackSound.Volume = 1.2
    attackSound.RollOffMode = Enum.RollOffMode.Inverse
    attackSound.Parent = root
    
    local hurtSound = Instance.new("Sound")
    hurtSound.Name = "HurtSound"
    hurtSound.SoundId = "rbxassetid://3398620867"
    hurtSound.Looped = false
    hurtSound.Volume = 1.0
    hurtSound.Pitch = 1.3
    hurtSound.RollOffMode = Enum.RollOffMode.Inverse
    hurtSound.Parent = root
    
    -- ==========================================
    -- DATA DE ANIMACIÓN
    -- ==========================================
    local animData = {
    -- partes
    root = root,
    torso = torso,
    headBase = headBase,
    
    -- welds
    torsoWeld = torsoWeld,
    neckWeld = neckWeld,
    headWeld = headWeld,
    lowerWeld = lowerWeld,
    petalWelds = petalWelds,
    
    -- motors brazos
    rShoulderMotor = rShoulderMotor,
    rElbowMotor = rElbowMotor,
    rHandMotor = rHandMotor,
    lShoulderMotor = lShoulderMotor,
    lElbowMotor = lElbowMotor,
    lHandMotor = lHandMotor,
    
    -- motors piernas
    rHipMotor = rHipMotor,
    rKneeMotor = rKneeMotor,
    rAnkleMotor = rAnkleMotor,
    lHipMotor = lHipMotor,
    lKneeMotor = lKneeMotor,
    lAnkleMotor = lAnkleMotor,
    
    -- estado
    walkCycle = 0,
    isAttacking = false,
    isChasing = false,
    moveDirection = Vector3.new(0, 0, 0),
    targetPosition = nil,
    currentSpeed = CONFIG.PatrolSpeed,
    
    -- audio
    chaseSound = chaseSound,
    footSound = footSound,
    attackSound = attackSound,
    hurtSound = hurtSound,
    lastSoundTick = 0,
    lastStepIndex = nil,
    
    -- NUEVO: Sistema de detección de daño
    lastDamageTick = 0,
    damageCooldown = 0.1
    }
    
    model.PrimaryPart = root
    model.Parent = workspace
    
    return model, animData
end

-- ==========================================
-- SISTEMA DE DETECCIÓN DE DAÑO
-- ==========================================
local function setupDamageDetection(model, data)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Detectar cuando el Demogorgon recibe daño
    humanoid.HealthChanged:Connect(function(health)
        if health < humanoid.MaxHealth and tick() - data.lastDamageTick > data.damageCooldown then
            data.lastDamageTick = tick()
            
            -- Sonido de dolor
            if data.hurtSound then
                pcall(function()
                    data.hurtSound.Pitch = math.random(10, 15) / 10
                    data.hurtSound:Play()
                end)
            end
            
            -- Animación de reacción al daño
            data.isAttacking = true
            task.wait(0.3)
            data.isAttacking = false
            
            print("🩸 Demogorgon recibió daño! Vida: "..math.floor(health).."/"..humanoid.MaxHealth)
        end
    end)
    
    -- Detectar colisiones con proyectiles u objetos dañinos
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.Touched:Connect(function(hit)
                if CONFIG.CanTakeDamage and hit and hit.Parent then
                    -- Detectar proyectiles o ataques (buscar por nombres comunes)
                    local hitName = hit.Name:lower()
                    local hitParentName = hit.Parent.Name:lower()
                    
                    -- Lista de nombres que indican daño
                    local damageKeywords = {
                    "projectile", "fireball", "blast", "explosion", 
                    "magic", "spell", "power", "attack", "bullet",
                    "missile", "rocket", "bomb", "energy"
                    }
                    
                    for _, keyword in ipairs(damageKeywords) do
                        if hitName:find(keyword) or hitParentName:find(keyword) then
                            -- Aplicar daño
                            local damage = 25 -- Daño base
                            
                            -- Buscar si el proyectil tiene configuración de daño
                            local damageValue = hit:FindFirstChild("Damage") or hit.Parent:FindFirstChild("Damage")
                            if damageValue and damageValue:IsA("NumberValue") then
                                damage = damageValue.Value
                            end
                            
                            if humanoid.Health > 0 then
                                humanoid:TakeDamage(damage)
                                print("💥 Demogorgon golpeado por: "..hit.Name.." (-"..damage.." HP)")
                            end
                            
                            -- Destruir el proyectil
                            pcall(function()
                                if hit.Parent then
                                    hit.Parent:Destroy()
                                else
                                    hit:Destroy()
                                end
                            end)
                            break
                        end
                    end
                end
            end)
        end
    end
end

-- ==========================================
-- MOVIMIENTO Y ANIMACIONES REALISTAS
-- ==========================================
local function updateMovement(model, data, dt)
    if not model or not model.Parent then return end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local root = data.root
    if not root then return end
    
    -- RAYCAST PARA ESTAR EN EL SUELO
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {model}
    local ray = Workspace:Raycast(root.Position, Vector3.new(0, -20, 0), rayParams)
    
    local targetY = root.Position.Y
    if ray and ray.Position then
        targetY = ray.Position.Y + 8
    end
    
    -- MOVER HACIA TARGET
    if data.targetPosition then
        local direction = (data.targetPosition - root.Position) * Vector3.new(1, 0, 1)
        local distance = direction.Magnitude
        
        if distance > 0.5 then
            data.moveDirection = direction.Unit
            local moveSpeed = data.currentSpeed
            local newPos = root.Position + (data.moveDirection * moveSpeed * dt)
            newPos = Vector3.new(newPos.X, targetY, newPos.Z)
            root.CFrame = CFrame.new(newPos) * CFrame.Angles(0, math.atan2(data.moveDirection.X, data.moveDirection.Z), 0)
        else
            data.moveDirection = Vector3.new(0, 0, 0)
            root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z) * (root.CFrame - root.Position)
        end
    else
        data.moveDirection = Vector3.new(0, 0, 0)
        root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z) * (root.CFrame - root.Position)
    end
    
    -- ==========================================
    -- ANIMACIONES MEJORADAS - ESTILO STRANGER THINGS
    -- ==========================================
    local moving = data.moveDirection.Magnitude > 0.1
    local running = data.currentSpeed > CONFIG.PatrolSpeed
    
    if data.isAttacking then
        -- ANIMACIÓN DE ATAQUE
        local attackCycle = (tick() % 0.6) * 10
        local attackSwing = math.sin(attackCycle)
        
        data.torsoWeld.C0 = CFrame.new(0, 1.2, 0) * CFrame.Angles(math.rad(35), 0, 0)
        data.neckWeld.C0 = CFrame.new(0, 2.2, 0) * CFrame.Angles(math.rad(-25), 0, 0)
        data.headWeld.C0 = CFrame.new(0, 1.8, 0) * CFrame.Angles(math.rad(-15), 0, 0)
        
        data.rShoulderMotor.C0 = CFrame.new(0, -0.7, 0) * CFrame.Angles(math.rad(-80 + attackSwing * 40), 0, math.rad(25))
        data.rElbowMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(math.rad(45 - attackSwing * 30), 0, 0)
        data.rHandMotor.C0 = CFrame.new(0, -2.1, 0) * CFrame.Angles(math.rad(-25), 0, 0)
        
        data.lShoulderMotor.C0 = CFrame.new(0, -0.7, 0) * CFrame.Angles(math.rad(-80 - attackSwing * 40), 0, math.rad(-25))
        data.lElbowMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(math.rad(45 + attackSwing * 30), 0, 0)
        data.lHandMotor.C0 = CFrame.new(0, -2.1, 0) * CFrame.Angles(math.rad(-25), 0, 0)
        
        for _, pData in ipairs(data.petalWelds) do
            pData.weld.C0 = pData.baseCF * CFrame.Angles(math.rad(-85), 0, 0)
        end
        
    elseif moving then
        -- ANIMACIÓN REALISTA DE CAMINAR
        local speed = running and 14 or 7
        data.walkCycle = data.walkCycle + dt * speed
        
        local swing = math.sin(data.walkCycle)
        local swingCos = math.cos(data.walkCycle)
        
        local legIntensity = running and 0.9 or 0.6
        local armIntensity = running and 1.0 or 0.7
        
        -- TORSO
        local leanForward = running and math.rad(15) or math.rad(8)
        local torsoBob = math.abs(swing) * 0.15
        data.torsoWeld.C0 = CFrame.new(0, 1.2 + torsoBob, 0) * CFrame.Angles(leanForward, swing * 0.1, swingCos * 0.05)
        
        -- CUELLO Y CABEZA
        data.neckWeld.C0 = CFrame.new(0, 2.2, 0) * CFrame.Angles(-leanForward * 0.5 + swing * 0.08, -swing * 0.08, 0)
        data.headWeld.C0 = CFrame.new(0, 1.8, 0) * CFrame.Angles(swing * 0.05, 0, 0)
        
        -- BRAZOS
        local rArmSwing = swingCos * armIntensity
        data.rShoulderMotor.C0 = CFrame.new(0, -0.7, 0) * CFrame.Angles(
        math.rad(rArmSwing * 45 + 10), 
        math.rad(rArmSwing * 5), 
        math.rad(12)
        )
        data.rElbowMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(
        math.rad(15 + math.max(0, rArmSwing * 25)),
        0, 
        0
        )
        data.rHandMotor.C0 = CFrame.new(0, -2.1, 0) * CFrame.Angles(
        math.rad(rArmSwing * 15),
        0, 
        0
        )
        
        local lArmSwing = -swingCos * armIntensity
        data.lShoulderMotor.C0 = CFrame.new(0, -0.7, 0) * CFrame.Angles(
        math.rad(lArmSwing * 45 + 10),
        math.rad(lArmSwing * 5),
        math.rad(-12)
        )
        data.lElbowMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(
        math.rad(15 + math.max(0, lArmSwing * 25)),
        0,
        0
        )
        data.lHandMotor.C0 = CFrame.new(0, -2.1, 0) * CFrame.Angles(
        math.rad(lArmSwing * 15),
        0,
        0
        )
        
        -- PIERNAS - CAMINAR REALISTA
        local rLegSwing = -swingCos * legIntensity
        
        data.rHipMotor.C0 = CFrame.new(0, -0.6, 0) * CFrame.Angles(
        math.rad(rLegSwing * 50),
        0,
        math.rad(2)
        )
        
        local rKneeBend = math.max(0.1, math.abs(rLegSwing) * 1.5)
        data.rKneeMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(
        math.rad(rKneeBend * 45),
        0,
        0
        )
        
        data.rAnkleMotor.C0 = CFrame.new(0, -1.75, 0) * CFrame.Angles(
        math.rad(-rLegSwing * 25 - 20),
        0,
        0
        )
        
        local lLegSwing = swingCos * legIntensity
        
        data.lHipMotor.C0 = CFrame.new(0, -0.6, 0) * CFrame.Angles(
        math.rad(lLegSwing * 50),
        0,
        math.rad(-2)
        )
        
        local lKneeBend = math.max(0.1, math.abs(lLegSwing) * 1.5)
        data.lKneeMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(
        math.rad(lKneeBend * 45),
        0,
        0
        )
        
        data.lAnkleMotor.C0 = CFrame.new(0, -1.75, 0) * CFrame.Angles(
        math.rad(-lLegSwing * 25 - 20),
        0,
        0
        )
        
        -- PÉTALOS
        for _, pData in ipairs(data.petalWelds) do
            local offset = pData.index * 0.8
            local flutterSpeed = running and 3.5 or 2.5
            local flutter = math.sin(data.walkCycle * flutterSpeed + offset) * 0.25
            local openAmount = running and -60 or -45
            
            pData.weld.C0 = pData.baseCF * CFrame.Angles(math.rad(openAmount + flutter * 35), 0, flutter * 0.4)
        end
        
        -- SONIDO DE PASOS
        local stepIndex = math.floor(data.walkCycle)
        if data.lastStepIndex == nil or stepIndex ~= data.lastStepIndex then
            if data.footSound then
                pcall(function()
                    data.footSound.PlaybackSpeed = running and 1.6 or 1.1
                    data.footSound.Volume = running and 1.1 or 0.9
                    data.footSound:Play()
                end)
            end
            data.lastStepIndex = stepIndex
        end
        
    else
        -- IDLE
        data.walkCycle = data.walkCycle + dt * 2
        local breathe = math.sin(data.walkCycle) * 0.06
        local breatheCos = math.cos(data.walkCycle * 0.7) * 0.04
        
        data.torsoWeld.C0 = CFrame.new(0, 1.2, 0) * CFrame.Angles(breathe * 0.2, breatheCos * 0.4, 0)
        data.neckWeld.C0 = CFrame.new(0, 2.2, 0) * CFrame.Angles(breathe * 0.5, breatheCos * 0.3, 0)
        data.headWeld.C0 = CFrame.new(0, 1.8, 0) * CFrame.Angles(breathe * 0.3, 0, breatheCos * 0.2)
        
        data.rShoulderMotor.C0 = CFrame.new(0, -0.7, 0) * CFrame.Angles(math.rad(15 + breathe * 10), 0, math.rad(8))
        data.rElbowMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(math.rad(20 + breatheCos * 8), 0, 0)
        data.rHandMotor.C0 = CFrame.new(0, -2.1, 0) * CFrame.Angles(math.rad(8), 0, 0)
        
        data.lShoulderMotor.C0 = CFrame.new(0, -0.7, 0) * CFrame.Angles(math.rad(15 + breathe * 10), 0, math.rad(-8))
        data.lElbowMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(math.rad(20 + breatheCos * 8), 0, 0)
        data.lHandMotor.C0 = CFrame.new(0, -2.1, 0) * CFrame.Angles(math.rad(8), 0, 0)
        
        data.rHipMotor.C0 = CFrame.new(0, -0.6, 0) * CFrame.Angles(math.rad(10), 0, math.rad(4))
        data.rKneeMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(math.rad(18), 0, 0)
        data.rAnkleMotor.C0 = CFrame.new(0, -1.75, 0) * CFrame.Angles(math.rad(-28), 0, 0)
        
        data.lHipMotor.C0 = CFrame.new(0, -0.6, 0) * CFrame.Angles(math.rad(10), 0, math.rad(-4))
        data.lKneeMotor.C0 = CFrame.new(0, -1.9, 0) * CFrame.Angles(math.rad(18), 0, 0)
        data.lAnkleMotor.C0 = CFrame.new(0, -1.75, 0) * CFrame.Angles(math.rad(-28), 0, 0)
        
        for _, pData in ipairs(data.petalWelds) do
            local offset = pData.index * 0.6
            local flutter = math.sin(data.walkCycle * 1.5 + offset) * 0.15
            
            pData.weld.C0 = pData.baseCF * CFrame.Angles(math.rad(flutter * 25), 0, flutter * 0.3)
        end
    end
end

-- ==========================================
-- IA
-- ==========================================
local function createAI(model, data)
    local root = data.root
    local hum = model:FindFirstChildOfClass("Humanoid")
    local spawnPos = root.Position
    
    local ai = {
    state = "patrol",
    target = nil,
    lastAttack = 0,
    patrolPoint = nil,
    patrolWait = 0,
    isWaiting = false
    }
    
    local function findNearestPlayer()
        local nearest = nil
        local minDist = CONFIG.DetectionRange
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                local charHum = char:FindFirstChildOfClass("Humanoid")
                if charHum and charHum.Health > 0 then
                    local dist = (char.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = char
                    end
                end
            end
        end
        return nearest
    end
    
    local function attack()
        if tick() - ai.lastAttack < CONFIG.AttackCooldown then return end
        if ai.target and ai.target:FindFirstChild("HumanoidRootPart") then
            local targetHum = ai.target:FindFirstChildOfClass("Humanoid")
            local dist = (ai.target.HumanoidRootPart.Position - root.Position).Magnitude
            if dist <= CONFIG.AttackRange and targetHum and targetHum.Health > 0 then
                data.isAttacking = true
                data.targetPosition = nil
                
                if data.attackSound then
                    pcall(function() data.attackSound:Play() end)
                    end
                        
                        targetHum:TakeDamage(CONFIG.Damage)
                        ai.lastAttack = tick()
                        task.wait(0.6)
                        data.isAttacking = false
                    end
                end
            end
            
            local function updateState()
                if not root or not hum or hum.Health <= 0 then return end
                
                local nearestPlayer = findNearestPlayer()
                if nearestPlayer then
                    ai.target = nearestPlayer
                    ai.state = "chase"
                    data.currentSpeed = CONFIG.ChaseSpeed
                    data.isChasing = true
                else
                    if ai.state == "chase" then
                        ai.target = nil
                        ai.state = "patrol"
                        ai.patrolPoint = nil
                        data.currentSpeed = CONFIG.PatrolSpeed
                        data.isChasing = false
                    end
                end
                
                if ai.state == "chase" then
                    if ai.target and ai.target.Parent then
                        local targetRoot = ai.target:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local dist = (targetRoot.Position - root.Position).Magnitude
                            if dist <= CONFIG.AttackRange then
                                attack()
                            else
                                data.targetPosition = targetRoot.Position
                            end
                        end
                    else
                        ai.state = "patrol"
                        ai.patrolPoint = nil
                        data.currentSpeed = CONFIG.PatrolSpeed
                        data.isChasing = false
                    end
                elseif ai.state == "patrol" then
                    if ai.patrolPoint == nil or (root.Position - ai.patrolPoint).Magnitude < 8 then
                        if not ai.isWaiting then
                            ai.isWaiting = true
                            ai.patrolWait = CONFIG.PatrolWaitTime
                            data.targetPosition = nil
                        end
                    end
                    
                    if ai.isWaiting then
                        if ai.patrolWait > 0 then
                            ai.patrolWait = ai.patrolWait - 0.3
                        else
                            ai.isWaiting = false
                            local randomOffset = Vector3.new(
                            math.random(-CONFIG.PatrolRadius, CONFIG.PatrolRadius),
                            0,
                            math.random(-CONFIG.PatrolRadius, CONFIG.PatrolRadius)
                            )
                            ai.patrolPoint = spawnPos + randomOffset
                            data.targetPosition = ai.patrolPoint
                        end
                    end
                end
            end
            
            -- Loop IA + Audio
            task.spawn(function()
                local lastState = ai.state
                data.lastSoundTick = tick()
                
                while model.Parent and hum.Health > 0 do
                    updateState()
                    
                    local interval = (ai.state == "chase") and 5 or 30
                    
                    if ai.state ~= lastState and ai.state == "chase" then
                        if data.chaseSound then
                            pcall(function() 
                                data.chaseSound.Volume = 1.5
                                data.chaseSound:Play() 
                            end)
                            data.lastSoundTick = tick()
                        end
                    end
                    
                    if tick() - data.lastSoundTick >= interval then
                        if data.chaseSound then
                            pcall(function()
                                data.chaseSound.Volume = (ai.state == "chase") and 1.5 or 0.8
                                data.chaseSound:Play()
                            end)
                            data.lastSoundTick = tick()
                        end
                    end
                    
                    lastState = ai.state
                    task.wait(0.3)
                end
            end)
        end
        
        -- ==========================================
        -- SPAWN
        -- ==========================================
        local function spawnDemogorgons()
            print("🔥 SPAWNING FIXED DEMOGORGONS WITH DAMAGE DETECTION...")
            for i = 1, CONFIG.TotalDemogorgons do
                local randX = math.random(-CONFIG.MapSize, CONFIG.MapSize)
                local randZ = math.random(-CONFIG.MapSize, CONFIG.MapSize)
                local spawnPos = Vector3.new(randX, 500, randZ)
                
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                local ray = Workspace:Raycast(spawnPos, Vector3.new(0, -1000, 0), rayParams)
                
                local finalPos
                if ray and ray.Position then
                    finalPos = ray.Position + Vector3.new(0, 8, 0)
                else
                    finalPos = Vector3.new(randX, 60, randZ)
                end
                
                local model, data = buildDemogorgon(finalPos)
                task.wait(0.05)
                
                -- Configurar sistema de daño
                setupDamageDetection(model, data)
                
                createAI(model, data)
                table.insert(demogorgons, {model = model, data = data})
                print("✅ Fixed Demogorgon "..i.." spawned with damage detection!")
                task.wait(0.15)
            end
            print("✅ ALL FIXED DEMOGORGONS ACTIVE WITH DAMAGE SYSTEM!")
        end
        
        spawnDemogorgons()
        
        -- LOOP PRINCIPAL
        RunService.Heartbeat:Connect(function(dt)
            for i = #demogorgons, 1, -1 do
                local d = demogorgons[i]
                if d.model.Parent and d.model:FindFirstChildOfClass("Humanoid") and d.model:FindFirstChildOfClass("Humanoid").Health > 0 then
                    updateMovement(d.model, d.data, dt)
                else
                    table.remove(demogorgons, i)
                end
            end
        end)
        
        print("🔥 DEMOGORGON COMPLETE - FIXED HANDS + DAMAGE DETECTION + REALISTIC ANIMATIONS!")
       

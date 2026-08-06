-- MUROS ÉPICOS DEL UPSIDE DOWN - 4 LADOS
-- ServerScriptService
 
local TweenService = game:GetService("TweenService")
 
-- CONFIGURACIÓN
local WALL_HEIGHT = 1000  -- ALTURA HASTA EL CIELO
local WALL_THICKNESS = 15
local MAP_SIZE = 2048  -- Tamaño del mapa (ajusta según tu baseplate)
 
-- Colores
local WALL_COLOR = Color3.fromRGB(30, 22, 25)
local VINE_COLORS = {
Color3.fromRGB(65, 40, 35),
Color3.fromRGB(75, 45, 40),
Color3.fromRGB(85, 50, 45)
}
 
-- CREAR MURO BASE
local function createWall(position, rotation, name)
    local wall = Instance.new("Part")
    wall.Name = name
    wall.Size = Vector3.new(MAP_SIZE, WALL_HEIGHT, WALL_THICKNESS)
    wall.Position = position
    wall.Orientation = rotation
    wall.Anchored = true
    wall.CanCollide = true
    wall.Material = Enum.Material.Plastic
    wall.Color = WALL_COLOR
    wall.TopSurface = Enum.SurfaceType.Studs
    wall.BottomSurface = Enum.SurfaceType.Studs
    wall.LeftSurface = Enum.SurfaceType.Studs
    wall.RightSurface = Enum.SurfaceType.Studs
    wall.FrontSurface = Enum.SurfaceType.Studs
    wall.BackSurface = Enum.SurfaceType.Studs
    wall.Parent = workspace
    
    return wall
end
 
-- LIANAS VERTICALES
local function addVines(wall)
    for i = 1, 100 do
        local vine = Instance.new("Part")
        vine.Name = "Vine"
        vine.Size = Vector3.new(
        math.random(1, 3),
        math.random(WALL_HEIGHT * 0.3, WALL_HEIGHT * 0.8),
        math.random(1, 3)
        )
        
        local xOffset = math.random(-MAP_SIZE/2 + 20, MAP_SIZE/2 - 20)
        local yOffset = math.random(-WALL_HEIGHT/4, WALL_HEIGHT/4)
        local zOffset = WALL_THICKNESS/2 + 2
        
        vine.CFrame = wall.CFrame * CFrame.new(xOffset, yOffset, zOffset)
        vine.Anchored = true
        vine.CanCollide = false
        vine.Material = Enum.Material.Plastic
        vine.Color = VINE_COLORS[math.random(1, 3)]
        vine.TopSurface = Enum.SurfaceType.Studs
        vine.BottomSurface = Enum.SurfaceType.Studs
        vine.Parent = wall
    end
end
 
-- RAYOS ROJOS EN EL MURO
local function addLightningToWall(wall)
    task.spawn(function()
        while wall and wall.Parent do
            task.wait(math.random(2, 5))
            
            -- Rayo en posición aleatoria del muro
            local xPos = math.random(-MAP_SIZE/2 + 50, MAP_SIZE/2 - 50)
            local yPos = math.random(WALL_HEIGHT/2, WALL_HEIGHT - 50)
            
            local lightning = Instance.new("Part")
            lightning.Name = "Lightning"
            lightning.Size = Vector3.new(3, 150, 3)
            lightning.CFrame = wall.CFrame * CFrame.new(xPos, yPos, 10)
            lightning.Anchored = true
            lightning.CanCollide = false
            lightning.Material = Enum.Material.Neon
            lightning.Color = Color3.fromRGB(255, 80, 80)
            lightning.Transparency = 0.2
            lightning.Parent = wall
            
            -- Luz
            local light = Instance.new("PointLight")
            light.Brightness = 15
            light.Color = Color3.fromRGB(255, 80, 80)
            light.Range = 150
            light.Parent = lightning
            
            -- Animación
            for i = 1, 6 do
                lightning.Transparency = 0.1
                task.wait(0.05)
                lightning.Transparency = 0.9
                task.wait(0.05)
            end
            
            lightning:Destroy()
        end
    end)
end
 
-- VENAS PULSANTES
local function addPulsingVeins(wall)
    for i = 1, 50 do
        local vein = Instance.new("Part")
        vein.Name = "Vein"
        vein.Size = Vector3.new(2, math.random(100, 300), 2)
        
        local xOffset = math.random(-MAP_SIZE/2 + 30, MAP_SIZE/2 - 30)
        local yOffset = math.random(-WALL_HEIGHT/3, WALL_HEIGHT/3)
        
        vein.CFrame = wall.CFrame * CFrame.new(xOffset, yOffset, WALL_THICKNESS/2 + 1)
        vein.Anchored = true
        vein.CanCollide = false
        vein.Material = Enum.Material.Neon
        vein.Color = Color3.fromRGB(150, 50, 50)
        vein.Transparency = 0.4
        vein.Parent = wall
        
        -- Pulso
        task.spawn(function()
            while vein and vein.Parent do
                TweenService:Create(vein, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                Transparency = 0.2,
                Color = Color3.fromRGB(200, 80, 80)
                }):Play()
                task.wait(1.5)
                TweenService:Create(vein, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                Transparency = 0.6,
                Color = Color3.fromRGB(120, 40, 40)
                }):Play()
                task.wait(1.5)
            end
        end)
    end
end
 
-- LUCES ROJAS FLOTANTES
local function addFloatingLights(wall)
    for i = 1, 30 do
        local lightPart = Instance.new("Part")
        lightPart.Name = "FloatingLight"
        lightPart.Size = Vector3.new(4, 4, 4)
        lightPart.Shape = Enum.PartType.Ball
        
        local xOffset = math.random(-MAP_SIZE/2, MAP_SIZE/2)
        local yOffset = math.random(50, WALL_HEIGHT - 50)
        
        lightPart.CFrame = wall.CFrame * CFrame.new(xOffset, yOffset, 20)
        lightPart.Anchored = true
        lightPart.CanCollide = false
        lightPart.Material = Enum.Material.Neon
        lightPart.Color = Color3.fromRGB(255, 100, 100)
        lightPart.Transparency = 0.3
        lightPart.Parent = wall
        
        local light = Instance.new("PointLight")
        light.Brightness = 8
        light.Color = Color3.fromRGB(255, 80, 80)
        light.Range = 80
        light.Parent = lightPart
        
        -- Movimiento flotante
        task.spawn(function()
            while lightPart and lightPart.Parent do
                local duration = math.random(4, 8)
                local targetOffset = CFrame.new(
                math.random(-20, 20),
                math.random(-30, 30),
                math.random(-10, 10)
                )
                
                TweenService:Create(lightPart, TweenInfo.new(duration, Enum.EasingStyle.Sine), {
                CFrame = wall.CFrame * CFrame.new(xOffset, yOffset, 20) * targetOffset
                }):Play()
                
                task.wait(duration)
            end
        end)
    end
end
 
-- PARTÍCULAS DE ESPORAS EN EL MURO
local function addSporeParticles(wall)
    for i = 1, 20 do
        local emitter = Instance.new("Part")
        emitter.Size = Vector3.new(1, 1, 1)
        emitter.Transparency = 1
        
        local xOffset = math.random(-MAP_SIZE/2, MAP_SIZE/2)
        local yOffset = math.random(0, WALL_HEIGHT)
        
        emitter.CFrame = wall.CFrame * CFrame.new(xOffset, yOffset, 15)
        emitter.Anchored = true
        emitter.CanCollide = false
        emitter.Parent = wall
        
        local particles = Instance.new("ParticleEmitter")
        particles.Texture = "rbxassetid://6073894699"
        particles.Rate = 8
        particles.Lifetime = NumberRange.new(3, 6)
        particles.Speed = NumberRange.new(2, 5)
        particles.SpreadAngle = Vector2.new(30, 30)
        particles.Color = ColorSequence.new(Color3.fromRGB(200, 180, 150))
        particles.Size = NumberSequence.new(2, 4)
        particles.Transparency = NumberSequence.new(0.3, 0.8)
        particles.LightEmission = 0.3
        particles.Parent = emitter
    end
end
 
-- CREAR LOS 4 MUROS
print("🌀 Generando 4 muros épicos del Upside Down...")
 
local halfMap = MAP_SIZE / 2
local wallHeight = WALL_HEIGHT / 2
 
-- MURO NORTE
local northWall = createWall(
Vector3.new(0, wallHeight, -halfMap),
Vector3.new(0, 0, 0),
"NorthWall"
)
print("✅ Muro Norte creado")
 
-- MURO SUR
local southWall = createWall(
Vector3.new(0, wallHeight, halfMap),
Vector3.new(0, 180, 0),
"SouthWall"
)
print("✅ Muro Sur creado")
 
-- MURO ESTE
local eastWall = createWall(
Vector3.new(halfMap, wallHeight, 0),
Vector3.new(0, 90, 0),
"EastWall"
)
print("✅ Muro Este creado")
 
-- MURO OESTE
local westWall = createWall(
Vector3.new(-halfMap, wallHeight, 0),
Vector3.new(0, -90, 0),
"WestWall"
)
print("✅ Muro Oeste creado")
 
-- AGREGAR EFECTOS A TODOS LOS MUROS
local walls = {northWall, southWall, eastWall, westWall}
 
for i, wall in ipairs(walls) do
    print("🌿 Agregando efectos al muro " .. i .. "...")
    
    addVines(wall)
    task.wait(0.1)
    
    addPulsingVeins(wall)
    task.wait(0.1)
    
    addLightningToWall(wall)
    task.wait(0.1)
    
    addFloatingLights(wall)
    task.wait(0.1)
    
    addSporeParticles(wall)
    task.wait(0.1)
end
 
print("========================================")
print("✅ ¡4 MUROS ÉPICOS COMPLETADOS!")
print("📏 Altura: " .. WALL_HEIGHT .. " studs")
print("🌍 Cobertura: 4 lados completos")
print("⚡ Efectos: Rayos, venas, luces, esporas")
print("========================================")
 
-- =================== TECHO ÉPICO ===================
print("🌩️ Generando techo épico...")
 
-- TECHO BASE (CASI INVISIBLE)
local ceiling = Instance.new("Part")
ceiling.Name = "UpsideDownCeiling"
ceiling.Size = Vector3.new(MAP_SIZE, 50, MAP_SIZE)
ceiling.Position = Vector3.new(0, WALL_HEIGHT, 0)
ceiling.Anchored = true
ceiling.CanCollide = true
ceiling.Material = Enum.Material.ForceField
ceiling.Color = Color3.fromRGB(80, 40, 40)
ceiling.Transparency = 0.95
ceiling.Parent = workspace
 
-- NUBES ROJAS
for i = 1, 40 do
    local cloud = Instance.new("Part")
    cloud.Size = Vector3.new(math.random(100, 250), math.random(30, 60), math.random(100, 250))
    cloud.Position = Vector3.new(math.random(-MAP_SIZE/2, MAP_SIZE/2), WALL_HEIGHT - math.random(10, 40), math.random(-MAP_SIZE/2, MAP_SIZE/2))
    cloud.Anchored = true
    cloud.CanCollide = false
    cloud.Material = Enum.Material.Neon
    cloud.Color = Color3.fromRGB(math.random(80, 120), math.random(30, 50), math.random(30, 50))
    cloud.Transparency = 0.6
    cloud.Parent = ceiling
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(1, 0.4, 1)
    mesh.Parent = cloud
    
    task.spawn(function()
        while cloud.Parent do
            TweenService:Create(cloud, TweenInfo.new(math.random(20, 40), Enum.EasingStyle.Linear), {
            Position = cloud.Position + Vector3.new(math.random(-100, 100), math.random(-10, 10), math.random(-100, 100)),
            Transparency = math.random(50, 80) / 100
            }):Play()
            task.wait(math.random(20, 40))
        end
    end)
end
 
-- RAYOS CAYENDO DEL TECHO
task.spawn(function()
    while ceiling.Parent do
        task.wait(math.random(1, 3))
        
        local x = math.random(-MAP_SIZE/2 + 100, MAP_SIZE/2 - 100)
        local z = math.random(-MAP_SIZE/2 + 100, MAP_SIZE/2 - 100)
        
        local lightning = Instance.new("Part")
        lightning.Size = Vector3.new(4, WALL_HEIGHT - 50, 4)
        lightning.Position = Vector3.new(x, WALL_HEIGHT/2, z)
        lightning.Anchored = true
        lightning.CanCollide = false
        lightning.Material = Enum.Material.Neon
        lightning.Color = Color3.fromRGB(255, 100, 100)
        lightning.Transparency = 0.2
        lightning.Parent = workspace
        
        local light = Instance.new("PointLight")
        light.Brightness = 20
        light.Color = Color3.fromRGB(255, 80, 80)
        light.Range = 200
        light.Parent = lightning
        
        for i = 1, math.random(2, 4) do
            local branch = Instance.new("Part")
            branch.Size = Vector3.new(2, math.random(100, 300), 2)
            branch.Position = Vector3.new(x + math.random(-30, 30), math.random(WALL_HEIGHT/2, WALL_HEIGHT - 100), z + math.random(-30, 30))
            branch.Anchored = true
            branch.CanCollide = false
            branch.Material = Enum.Material.Neon
            branch.Color = Color3.fromRGB(255, 120, 120)
            branch.Transparency = 0.4
            branch.Orientation = Vector3.new(math.random(-30, 30), math.random(0, 360), math.random(-30, 30))
            branch.Parent = lightning
        end
        
        local thunder = Instance.new("Sound")
        thunder.SoundId = "rbxassetid://130818250"
        thunder.Volume = 0.6
        thunder.Parent = lightning
        thunder:Play()
        
        for i = 1, 8 do
            lightning.Transparency = 0.1
            task.wait(0.04)
            lightning.Transparency = 0.8
            task.wait(0.04)
        end
        
        lightning:Destroy()
    end
end)
 
-- VÓRTICES GIRATORIOS
for i = 1, 15 do
    local vortex = Instance.new("Part")
    vortex.Size = Vector3.new(80, 5, 80)
    vortex.Position = Vector3.new(math.random(-MAP_SIZE/2, MAP_SIZE/2), WALL_HEIGHT - 20, math.random(-MAP_SIZE/2, MAP_SIZE/2))
    vortex.Anchored = true
    vortex.CanCollide = false
    vortex.Material = Enum.Material.Neon
    vortex.Color = Color3.fromRGB(200, 80, 80)
    vortex.Transparency = 0.5
    vortex.Shape = Enum.PartType.Cylinder
    vortex.Parent = ceiling
    
    task.spawn(function()
        while vortex.Parent do
            vortex.Orientation = vortex.Orientation + Vector3.new(0, 5, 0)
            task.wait(0.05)
        end
    end)
    
    task.spawn(function()
        while vortex.Parent do
            TweenService:Create(vortex, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.3, Size = Vector3.new(90, 5, 90)}):Play()
            task.wait(2)
            TweenService:Create(vortex, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.7, Size = Vector3.new(70, 5, 70)}):Play()
            task.wait(2)
        end
    end)
end
 
-- GRIETAS LUMINOSAS
for i = 1, 60 do
    local crack = Instance.new("Part")
    crack.Size = Vector3.new(math.random(2, 5), math.random(50, 150), math.random(2, 5))
    crack.Position = Vector3.new(math.random(-MAP_SIZE/2, MAP_SIZE/2), WALL_HEIGHT - 25, math.random(-MAP_SIZE/2, MAP_SIZE/2))
    crack.Anchored = true
    crack.CanCollide = false
    crack.Material = Enum.Material.Neon
    crack.Color = Color3.fromRGB(255, 50, 50)
    crack.Transparency = 0.3
    crack.Orientation = Vector3.new(math.random(-45, 45), math.random(0, 360), math.random(-45, 45))
    crack.Parent = ceiling
    
    local light = Instance.new("PointLight")
    light.Brightness = 5
    light.Color = Color3.fromRGB(255, 80, 80)
    light.Range = 60
    light.Parent = crack
    
    task.spawn(function()
        while crack.Parent do
            TweenService:Create(crack, TweenInfo.new(0.5), {Transparency = 0.1}):Play()
            task.wait(0.5)
            TweenService:Create(crack, TweenInfo.new(0.5), {Transparency = 0.6}):Play()
            task.wait(0.5)
        end
    end)
end
 
-- LUCES PULSANTES
for i = 1, 50 do
    local lightPart = Instance.new("Part")
    lightPart.Size = Vector3.new(6, 6, 6)
    lightPart.Shape = Enum.PartType.Ball
    lightPart.Position = Vector3.new(math.random(-MAP_SIZE/2, MAP_SIZE/2), WALL_HEIGHT - math.random(20, 50), math.random(-MAP_SIZE/2, MAP_SIZE/2))
    lightPart.Anchored = true
    lightPart.CanCollide = false
    lightPart.Material = Enum.Material.Neon
    lightPart.Color = Color3.fromRGB(255, 80, 80)
    lightPart.Transparency = 0.4
    lightPart.Parent = ceiling
    
    local light = Instance.new("PointLight")
    light.Brightness = 10
    light.Color = Color3.fromRGB(255, 100, 100)
    light.Range = 100
    light.Parent = lightPart
    
    task.spawn(function()
        while lightPart.Parent do
            TweenService:Create(lightPart, TweenInfo.new(1, Enum.EasingStyle.Sine), {Transparency = 0.2, Size = Vector3.new(8, 8, 8)}):Play()
            TweenService:Create(light, TweenInfo.new(1), {Brightness = 15}):Play()
            task.wait(1)
            TweenService:Create(lightPart, TweenInfo.new(1, Enum.EasingStyle.Sine), {Transparency = 0.6, Size = Vector3.new(6, 6, 6)}):Play()
            TweenService:Create(light, TweenInfo.new(1), {Brightness = 5}):Play()
            task.wait(1)
        end
    end)
end
 
print("========================================")
print("✅ ¡TECHO ÉPICO AGREGADO!")
print("☁️ 40 nubes + ⚡ Rayos + 🌀 Vórtices")
print("========================================")
 

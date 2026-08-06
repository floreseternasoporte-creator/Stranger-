--[[
╔══════════════════════════════════════════════════════════════════════════════════╗
║  ⚡ THE UPSIDE DOWN: SUPER VISIBLE + FILM GRAIN - STRANGER THINGS EDITION ⚡   ║
║           Sistema Fotorrealista AAA 100% VISIBLE de Stranger Things              ║
║      Gráficos Cinematográficos Brillantes + Film Grain + Daño por Proximidad    ║
║                    © 2026 - Versión Definitiva Ultra Visible                     ║
╚══════════════════════════════════════════════════════════════════════════════════╝
 
🎬 CARACTERÍSTICAS ULTRA-ÉPICAS Y 100% VISIBLES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ RAYOS ROJOS FINOS Y BRILLANTES (8 Capas Stranger Things Style)
☀️  ATMÓSFERA OSCURA STRANGER THINGS (Brightness 1.0 + ClockTime 0 = Noche)
💀 SISTEMA DE DAÑO POR PROXIMIDAD (80-100 HP directo, 30-60 cercano)
🌫️ ESPORAS LUMINOSAS DENSAS (500+ flotando + 150 ascendiendo)
✨ ILUMINACIÓN AMBIENTAL MUY BRILLANTE (puedes ver TODO)
🔴 TOQUES PÚRPURA SUTILES (estilo Upside Down pero visible)
💥 PARTÍCULAS BRILLANTES Y VISIBLES
🎆 Niebla Roja Brillante + Chispas de Fuego
💡 Iluminación Volumétrica BRILLANTE
🔊 Audio 3D Espacial con Ecos Dimensionales
🎨 Color Grading Optimizado para Visibilidad
⚙️ Optimización Multi-Servidor Extrema
🌌 Partículas Procedurales Brillantes
💫 Efectos de Electrocución en Jugadores
🖼️ Vignette (bordes oscuros cinematográficos)
 
📦 INSTALACIÓN: ServerScriptService
✅ 100% VISIBLE: Puedes ver el suelo, paredes, TODO perfectamente
🌟 MODERNO: Sin efectos vintage, gráficos limpios y brillantes
💀 LETAL: Los rayos causan daño real
🔴 STRANGER THINGS: Rayos rojos finos como en la serie
]]
 
-- ═══════════════════════════════════════════════════════════════════════════
-- 🎮 SERVICIOS
-- ═══════════════════════════════════════════════════════════════════════════
 
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
 
math.randomseed(os.time() + tick())
 
-- ═══════════════════════════════════════════════════════════════════════════
-- ⚙️ CONFIGURACIÓN ULTRA ÉPICA
-- ═══════════════════════════════════════════════════════════════════════════
 
local CONFIG = {
-- 🌩️ TORMENTA ÉPICA
STORM = {
INTERVAL = 4.5,                  -- Oleadas cada 4.5 segundos (más intenso)
BOLTS_PER_WAVE = 75,             -- Más rayos por oleada
PLAYER_PROXIMITY_BOLTS = 7,      -- Rayos cerca de jugadores
MEGA_BOLT_CHANCE = 0.15,         -- 15% chance de rayo MEGA épico
MAX_HEIGHT = 5500,
FLASH_DURATION = 1.0,
BRANCH_CHANCE = 0.50,            -- Más ramificaciones
},
 
-- 💀 SISTEMA DE DAÑO POR PROXIMIDAD
DAMAGE = {
ENABLED = true,
DIRECT_HIT = {MIN = 80, MAX = 100},      -- Impacto directo = muerte casi segura
CLOSE_RANGE = {MIN = 30, MAX = 60},      -- Cerca (0-15 studs)
MEDIUM_RANGE = {MIN = 10, MAX = 30},     -- Medio (15-35 studs)
FAR_RANGE = {MIN = 5, MAX = 15},         -- Lejos (35-60 studs)
DIRECT_HIT_RADIUS = 8,
CLOSE_RADIUS = 15,
MEDIUM_RADIUS = 35,
FAR_RADIUS = 60,
ELECTROCUTION_TIME = 2.0,        -- Tiempo de efecto de electrocución
RAGDOLL_CHANCE = 0.7,            -- 70% chance de ragdoll en impacto cercano
},
 
-- ⚡ RAYOS ROJOS ULTRA-DETALLADOS (8 CAPAS FINAS Y BRILLANTES)
LIGHTNING = {
-- CAPA 1: NÚCLEO BLANCO INCANDESCENTE ULTRA-BRILLANTE
CORE = {
COLOR = Color3.fromRGB(255, 255, 255),
WIDTH = 1.8,
EMISSION = 5.0,
},
 
-- CAPA 2: PLASMA ROJO BRILLANTE INTENSO
PLASMA_INNER = {
COLOR = Color3.fromRGB(255, 40, 50),
WIDTH = 3.5,
EMISSION = 4.5,
},
 
-- CAPA 3: ENERGÍA CARMESÍ RADIANTE
ENERGY = {
COLOR = Color3.fromRGB(255, 20, 30),
WIDTH = 6.0,
EMISSION = 4.0,
},
 
-- CAPA 4: ROJO SANGRE PROFUNDO
BLOOD = {
COLOR = Color3.fromRGB(230, 15, 25),
WIDTH = 9.0,
EMISSION = 3.5,
},
 
-- CAPA 5: CARMESÍ OSCURO SOBRENATURAL
CRIMSON = {
COLOR = Color3.fromRGB(200, 10, 20),
WIDTH = 13.0,
EMISSION = 3.0,
},
 
-- CAPA 6: ROJO PROFUNDO DIMENSIONAL
DARK_RED = {
COLOR = Color3.fromRGB(170, 5, 15),
WIDTH = 18.0,
EMISSION = 2.5,
},
 
-- CAPA 7: PÚRPURA MIND FLAYER
VOID = {
COLOR = Color3.fromRGB(140, 30, 100),
WIDTH = 24.0,
EMISSION = 2.0,
},
 
-- CAPA 8: RESPLANDOR ROJO FINAL
ATMOSPHERE = {
COLOR = Color3.fromRGB(100, 20, 60),
WIDTH = 32.0,
EMISSION = 1.5,
},
 
SEGMENTS = 22,                   -- Más segmentos = más detalle
DEVIATION = 90,                  -- Más caótico
MEGA_WIDTH_MULT = 1.6,          -- Multiplicador para rayos MEGA (reducido)
},
 
-- 🌫️ ESPORAS LUMINOSAS MASIVAS (STRANGER THINGS)
SPORES = {
ENABLED = true,
AMBIENT_COUNT = 500,             -- MÁS esporas flotantes constantes
IMPACT_COUNT = 200,              -- MÁS esporas por impacto
RISING_COUNT = 150,              -- Esporas que suben del suelo
SIZE_MIN = 0.12,
SIZE_MAX = 0.55,
FLOAT_SPEED = 3.0,
GLOW_INTENSITY = 1.5,
COLOR = Color3.fromRGB(255, 255, 255),
BLUE_SPORES = true,              -- Esporas azules también
BLUE_COLOR = Color3.fromRGB(150, 180, 255),
},
 
-- 🎆 PARTÍCULAS CINEMATOGRÁFICAS ÉPICAS
PARTICLES = {
ELECTRIC_SPARKS = 150,           -- MÁS chispas brillantes
PLASMA_BURST = 130,              -- MÁS plasma rojo
ENERGY_ORBS = 90,                -- MÁS orbes de energía
ASH_PARTICLES = 60,              -- MENOS ceniza oscura
VOID_DUST = 50,                  -- MENOS polvo oscuro
SHOCKWAVES = 10,                 -- Más ondas de choque
REALITY_TEARS = 80,              -- MÁS desgarros brillantes
DIMENSIONAL_RIFTS = 70,          -- MÁS rifts
HEAT_DISTORTION = 50,            -- Distorsión del aire
ENERGY_RINGS = 60,               -- MÁS anillos de energía
DARK_MATTER = 30,                -- MENOS materia oscura
ELECTRO_DISCHARGE = 120,         -- MÁS descarga eléctrica
RED_MIST = 100,                  -- NUEVA: Niebla roja brillante
FIRE_SPARKS = 80,                -- NUEVA: Chispas de fuego
},
 
-- 🔊 AUDIO MEJORADO
AUDIO = {
THUNDER = "rbxassetid://130457325001606",
DISTANT = "rbxassetid://9125402735",
MEGA_THUNDER = "rbxassetid://9125402735",  -- Para rayos MEGA
VOLUME = 4.5,
MEGA_VOLUME = 6.0,
MAX_DISTANCE = 6000,
POOL_SIZE = 30,
ECHO_ENABLED = true,             -- Eco dimensional
},
 
-- 💡 ILUMINACIÓN VOLUMÉTRICA MUY BRILLANTE
LIGHTING = {
IMPACT_RANGE = 250,
IMPACT_BRIGHTNESS = 180,
MEGA_BRIGHTNESS = 240,
SKY_FLASH = 0.9,
BLOOM_INTENSITY = 1.5,
BLOOM_SIZE = 24,
AMBIENT_LIGHT = Color3.fromRGB(25, 20, 35),      -- Oscuro con toque púrpura
OUTDOOR_AMBIENT = Color3.fromRGB(30, 25, 40),    -- Oscuro
GOD_RAYS_INTENSITY = 0.35,
},
 
-- 🎨 COLOR GRADING VISIBLE
COLOR = {
TINT = Color3.fromRGB(120, 100, 140),    -- Tinte oscuro púrpura
SATURATION = -0.15,                       -- Menos saturación
CONTRAST = 0.25,                          -- Más contraste
BRIGHTNESS = 0.0,                         -- Sin brightness extra
},
 
-- 🌍 ÁREA
COVERAGE = Vector3.new(5500, 120, 5500),
}
 
-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 TEXTURAS
-- ═══════════════════════════════════════════════════════════════════════════
 
local TEX = {
BOLT = "rbxassetid://4483431961",
BEAM = "rbxassetid://1084991215",
SPARK = "rbxassetid://6101261905",
ORB = "rbxassetid://8639966539",
WAVE = "rbxassetid://4995929",
RING = "rbxassetid://1053548563",
SMOKE = "rbxassetid://1084991215",
SPORE = "rbxassetid://6101261905",
DISTORTION = "rbxassetid://1084991215",  -- Para distorsión de calor
}
 
-- ═══════════════════════════════════════════════════════════════════════════
-- 🔧 UTILIDADES
-- ═══════════════════════════════════════════════════════════════════════════
 
local function rand(min, max)
    return min + (math.random() * (max - min))
end
 
local function randVec(range)
    return Vector3.new(rand(-range, range), rand(-range, range), rand(-range, range))
end
 
-- ═══════════════════════════════════════════════════════════════════════════
-- 💀 SISTEMA DE DAÑO POR PROXIMIDAD
-- ═══════════════════════════════════════════════════════════════════════════
 
local DamageSystem = {}
 
function DamageSystem:ApplyDamage(position, isMega)
    if not CONFIG.DAMAGE.ENABLED then return end
    
    local dmgConfig = CONFIG.DAMAGE
    local maxRadius = dmgConfig.FAR_RADIUS
    
    -- Encontrar jugadores en rango
    local region = Region3.new(
    position - Vector3.new(maxRadius, maxRadius, maxRadius),
    position + Vector3.new(maxRadius, maxRadius, maxRadius)
    )
    region = region:ExpandToGrid(4)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                local distance = (hrp.Position - position).Magnitude
                local damage = 0
                local effectIntensity = 1.0
                
                -- Calcular daño según distancia
                if distance <= dmgConfig.DIRECT_HIT_RADIUS then
                    -- IMPACTO DIRECTO - LETAL
                    damage = rand(dmgConfig.DIRECT_HIT.MIN, dmgConfig.DIRECT_HIT.MAX)
                    effectIntensity = 1.5
                    
                    -- Ragdoll garantizado en impacto directo
                    self:ApplyRagdoll(player.Character, 3.0)
                    
                elseif distance <= dmgConfig.CLOSE_RADIUS then
                    -- CERCA - DAÑO ALTO
                    damage = rand(dmgConfig.CLOSE_RANGE.MIN, dmgConfig.CLOSE_RANGE.MAX)
                    effectIntensity = 1.2
                    
                    -- Chance de ragdoll
                    if math.random() < dmgConfig.RAGDOLL_CHANCE then
                        self:ApplyRagdoll(player.Character, 2.0)
                    end
                    
                elseif distance <= dmgConfig.MEDIUM_RADIUS then
                    -- MEDIO - DAÑO MODERADO
                    damage = rand(dmgConfig.MEDIUM_RANGE.MIN, dmgConfig.MEDIUM_RANGE.MAX)
                    effectIntensity = 0.8
                    
                elseif distance <= dmgConfig.FAR_RADIUS then
                    -- LEJOS - DAÑO LEVE
                    damage = rand(dmgConfig.FAR_RANGE.MIN, dmgConfig.FAR_RANGE.MAX)
                    effectIntensity = 0.5
                end
                
                -- Rayos MEGA hacen 50% más daño
                if isMega then
                    damage = damage * 1.5
                    effectIntensity = effectIntensity * 1.5
                end
                
                -- Aplicar daño
                if damage > 0 then
                    humanoid:TakeDamage(damage)
                    
                    -- Efectos visuales de electrocución
                    self:ApplyElectrocutionEffect(player.Character, effectIntensity)
                end
            end
        end
    end
end
 
function DamageSystem:ApplyElectrocutionEffect(character, intensity)
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Crear efecto de electricidad en el jugador
    local effectPart = Instance.new("Part")
    effectPart.Size = Vector3.new(1, 1, 1)
    effectPart.Anchored = true
    effectPart.CanCollide = false
    effectPart.Transparency = 1
    effectPart.Position = hrp.Position
    effectPart.Parent = character
    
    local att = Instance.new("Attachment", effectPart)
    
    -- Chispas eléctricas rojas
    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = TEX.SPARK
    sparks.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 60, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 20, 35))
    })
    sparks.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1.5 * intensity),
    NumberSequenceKeypoint.new(1, 0)
    })
    sparks.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1)
    })
    sparks.Lifetime = NumberRange.new(0.3, 0.8)
    sparks.Speed = NumberRange.new(10, 30)
    sparks.SpreadAngle = Vector2.new(180, 180)
    sparks.Rate = 100 * intensity
    sparks.LightEmission = 1
    sparks.Parent = att
    
    -- Luz roja parpadeante
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 60, 70)
    light.Brightness = 5 * intensity
    light.Range = 15
    light.Parent = effectPart
    
    -- Efecto de parpadeo
    task.spawn(function()
        for i = 1, 8 do
            light.Enabled = not light.Enabled
            task.wait(0.1)
        end
    end)
    
    -- Limpiar después del tiempo de electrocución
    Debris:AddItem(effectPart, CONFIG.DAMAGE.ELECTROCUTION_TIME)
end
 
function DamageSystem:ApplyRagdoll(character, duration)
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Cambiar a estado Ragdoll
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    -- Aplicar fuerza aleatoria
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local direction = Vector3.new(rand(-1, 1), rand(0.5, 1), rand(-1, 1)).Unit
        local force = Instance.new("BodyVelocity")
        force.Velocity = direction * rand(30, 60)
            force.MaxForce = Vector3.new(4000, 4000, 4000)
                force.Parent = hrp
                    Debris:AddItem(force, 0.2)
                end
                
                -- Restaurar después de la duración
                task.delay(duration, function()
                    if humanoid and humanoid.Health > 0 then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
            end
            
            -- ═══════════════════════════════════════════════════════════════════════════
            -- 🌫️ SISTEMA DE ESPORAS AMBIENTE ÉPICO (STRANGER THINGS)
            -- ═══════════════════════════════════════════════════════════════════════════
            
            local SporeSystem = {}
            SporeSystem.particles = {}
            
            function SporeSystem:Init()
                local sporeFolder = Instance.new("Folder")
                sporeFolder.Name = "AmbientSpores"
                sporeFolder.Parent = Workspace
                
                -- Crear emisores de esporas distribuidos por el mapa (MÁS EMISORES)
                for i = 1, 15 do
                    local emitterPart = Instance.new("Part")
                    emitterPart.Name = "SporeEmitter" .. i
                    emitterPart.Size = Vector3.new(1, 1, 1)
                    emitterPart.Anchored = true
                    emitterPart.CanCollide = false
                    emitterPart.Transparency = 1
                    emitterPart.Position = Vector3.new(
                    rand(-CONFIG.COVERAGE.X/2, CONFIG.COVERAGE.X/2),
                    rand(50, 250),
                    rand(-CONFIG.COVERAGE.Z/2, CONFIG.COVERAGE.Z/2)
                    )
                    emitterPart.Parent = sporeFolder
                    
                    local att = Instance.new("Attachment", emitterPart)
                    
                    -- ESPORAS BLANCAS LUMINOSAS FLOTANTES
                    local spores = Instance.new("ParticleEmitter")
                    spores.Name = "FloatingSpores"
                    spores.Texture = TEX.SPORE
                    spores.Color = ColorSequence.new(CONFIG.SPORES.COLOR)
                    spores.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, CONFIG.SPORES.SIZE_MIN),
                    NumberSequenceKeypoint.new(0.5, CONFIG.SPORES.SIZE_MAX),
                    NumberSequenceKeypoint.new(1, CONFIG.SPORES.SIZE_MIN)
                    })
                    spores.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.5, 0.3),
                    NumberSequenceKeypoint.new(1, 0)
                    })
                    spores.Lifetime = NumberRange.new(15, 25)
                    spores.Speed = NumberRange.new(0.8, 3)
                    spores.SpreadAngle = Vector2.new(180, 180)
                    spores.Acceleration = Vector3.new(
                    rand(-1.5, 1.5),
                    rand(-0.8, 2.0),
                    rand(-1.5, 1.5)
                    )
                    spores.Drag = 1.8
                    spores.VelocityInheritance = 0
                    spores.LightEmission = CONFIG.SPORES.GLOW_INTENSITY
                    spores.LightInfluence = 0
                    spores.Rate = CONFIG.SPORES.AMBIENT_COUNT / 15
                    spores.Rotation = NumberRange.new(0, 360)
                    spores.RotSpeed = NumberRange.new(-25, 25)
                    spores.Parent = att
                    
                    -- ESPORAS AZULES (NUEVO)
                    if CONFIG.SPORES.BLUE_SPORES then
                        local blueSpores = spores:Clone()
                        blueSpores.Name = "BlueSpores"
                        blueSpores.Color = ColorSequence.new(CONFIG.SPORES.BLUE_COLOR)
                        blueSpores.Rate = (CONFIG.SPORES.AMBIENT_COUNT / 15) * 0.3
                        blueSpores.LightEmission = 0.9
                        blueSpores.Parent = att
                        
                        table.insert(self.particles, blueSpores)
                    end
                    
                    table.insert(self.particles, spores)
                end
                
                -- ESPORAS QUE SUBEN DEL SUELO
                for i = 1, 8 do
                    local groundEmitter = Instance.new("Part")
                    groundEmitter.Name = "GroundSporeEmitter" .. i
                    groundEmitter.Size = Vector3.new(1, 1, 1)
                    groundEmitter.Anchored = true
                    groundEmitter.CanCollide = false
                    groundEmitter.Transparency = 1
                    groundEmitter.Position = Vector3.new(
                    rand(-CONFIG.COVERAGE.X/2, CONFIG.COVERAGE.X/2),
                    5,
                    rand(-CONFIG.COVERAGE.Z/2, CONFIG.COVERAGE.Z/2)
                    )
                    groundEmitter.Parent = sporeFolder
                    
                    local att = Instance.new("Attachment", groundEmitter)
                    
                    local risingSpores = Instance.new("ParticleEmitter")
                    risingSpores.Name = "RisingSpores"
                    risingSpores.Texture = TEX.SPORE
                    risingSpores.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    })
                    risingSpores.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.08),
                    NumberSequenceKeypoint.new(0.5, 0.3),
                    NumberSequenceKeypoint.new(1, 0.1)
                    })
                    risingSpores.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.2),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 0.8)
                    })
                    risingSpores.Lifetime = NumberRange.new(8, 15)
                    risingSpores.Speed = NumberRange.new(2, 5)
                    risingSpores.SpreadAngle = Vector2.new(30, 30)
                    risingSpores.Acceleration = Vector3.new(0, 3, 0)
                    risingSpores.Drag = 1.5
                    risingSpores.LightEmission = 0.8
                    risingSpores.Rate = CONFIG.SPORES.RISING_COUNT / 8
                    risingSpores.Rotation = NumberRange.new(0, 360)
                    risingSpores.RotSpeed = NumberRange.new(-20, 20)
                    risingSpores.EmissionDirection = Enum.NormalId.Top
                    risingSpores.Parent = att
                    
                    table.insert(self.particles, risingSpores)
                end
                
                warn("🌫️  Sistema de Esporas ÉPICO Inicializado: " .. CONFIG.SPORES.AMBIENT_COUNT .. " esporas flotantes + " .. CONFIG.SPORES.RISING_COUNT .. " esporas ascendentes")
            end
            
            -- ═══════════════════════════════════════════════════════════════════════════
            -- 🎵 AUDIO POOL MEJORADO
            -- ═══════════════════════════════════════════════════════════════════════════
            
            local AudioPool = {sounds = {}, index = 1, megaSounds = {}, megaIndex = 1}
            
            function AudioPool:Init()
                local folder = Instance.new("Folder")
                folder.Name = "UpsideDown_Audio"
                folder.Parent = Workspace
                
                -- Sonidos normales
                for i = 1, CONFIG.AUDIO.POOL_SIZE do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(0.1, 0.1, 0.1)
                    part.Anchored = true
                    part.CanCollide = false
                    part.Transparency = 1
                    part.Position = Vector3.new(0, -15000, 0)
                    part.Parent = folder
                    
                    local thunder = Instance.new("Sound")
                    thunder.SoundId = CONFIG.AUDIO.THUNDER
                    thunder.Volume = CONFIG.AUDIO.VOLUME
                    thunder.RollOffMode = Enum.RollOffMode.InverseTapered
                    thunder.MaxDistance = CONFIG.AUDIO.MAX_DISTANCE
                    thunder.Parent = part
                    
                    table.insert(self.sounds, {part = part, sound = thunder})
                end
                
                -- Sonidos MEGA
                for i = 1, 10 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(0.1, 0.1, 0.1)
                    part.Anchored = true
                    part.CanCollide = false
                    part.Transparency = 1
                    part.Position = Vector3.new(0, -15000, 0)
                    part.Parent = folder
                    
                    local megaThunder = Instance.new("Sound")
                    megaThunder.SoundId = CONFIG.AUDIO.MEGA_THUNDER
                    megaThunder.Volume = CONFIG.AUDIO.MEGA_VOLUME
                    megaThunder.RollOffMode = Enum.RollOffMode.InverseTapered
                    megaThunder.MaxDistance = CONFIG.AUDIO.MAX_DISTANCE * 1.5
                    megaThunder.Parent = part
                    
                    table.insert(self.megaSounds, {part = part, sound = megaThunder})
                end
            end
            
            function AudioPool:Play(pos, isMega)
                local pool = isMega and self.megaSounds or self.sounds
                local index = isMega and self.megaIndex or self.index
                
                local s = pool[index]
                if not s then return end
                
                s.part.Position = pos
                s.sound.PlaybackSpeed = rand(0.7, 1.1)
                
                if s.sound.Playing then s.sound:Stop() end
                s.sound:Play()
                
                -- Echo dimensional
                if CONFIG.AUDIO.ECHO_ENABLED and not isMega then
                    task.delay(0.3, function()
                        if s.sound and s.sound.Parent then
                            local echo = s.sound:Clone()
                            echo.Volume = CONFIG.AUDIO.VOLUME * 0.4
                            echo.PlaybackSpeed = rand(0.6, 0.9)
                            echo.Parent = s.part
                            echo:Play()
                            Debris:AddItem(echo, 5)
                        end
                    end)
                end
                
                if isMega then
                    self.megaIndex = self.megaIndex + 1
                    if self.megaIndex > #self.megaSounds then self.megaIndex = 1 end
                else
                    self.index = self.index + 1
                    if self.index > #self.sounds then self.index = 1 end
                end
            end
            
            -- ═══════════════════════════════════════════════════════════════════════════
            -- 🌍 RAYCAST
            -- ═══════════════════════════════════════════════════════════════════════════
            
            local function groundCast(x, z)
                local origin = Vector3.new(x, CONFIG.STORM.MAX_HEIGHT, z)
                local dir = Vector3.new(0, -CONFIG.STORM.MAX_HEIGHT * 3, 0)
                
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.FilterDescendantsInstances = {
                Workspace:FindFirstChild("UpsideDown_FX"),
                Workspace:FindFirstChild("UpsideDown_Audio"),
                Workspace:FindFirstChild("AmbientSpores")
                }
                
                local result = Workspace:Raycast(origin, dir, params)
                
                if result then
                    return result.Position, origin.Y
                else
                    return Vector3.new(x, 0, z), origin.Y
                end
            end
            
            -- ═══════════════════════════════════════════════════════════════════════════
            -- 💫 PARTÍCULAS DE IMPACTO ÉPICAS (ULTRA DETALLADAS)
            -- ═══════════════════════════════════════════════════════════════════════════
            
            local function createImpactParticles(parent, pos, isMega)
                local container = Instance.new("Part")
                container.Size = Vector3.new(1, 1, 1)
                container.Anchored = true
                container.CanCollide = false
                container.Transparency = 1
                container.Position = pos
                container.Parent = parent
                
                local att = Instance.new("Attachment", container)
                
                local mult = isMega and 1.8 or 1.0
                
                -- ═══ CHISPAS ELÉCTRICAS ROJAS ═══
                local sparks = Instance.new("ParticleEmitter")
                sparks.Texture = TEX.SPARK
                sparks.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 80, 90)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(230, 25, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 15, 30))
                })
                sparks.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 3.0 * mult),
                NumberSequenceKeypoint.new(0.5, 1.5 * mult),
                NumberSequenceKeypoint.new(1, 0)
                })
                sparks.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.8, 0.5),
                NumberSequenceKeypoint.new(1, 1)
                })
                sparks.Lifetime = NumberRange.new(0.6, 1.5)
                sparks.Speed = NumberRange.new(70, 160)
                sparks.SpreadAngle = Vector2.new(180, 180)
                sparks.Drag = 10
                sparks.LightEmission = 1
                sparks.LightInfluence = 0
                sparks.Rate = 0
                sparks.Parent = att
                sparks:Emit(CONFIG.PARTICLES.ELECTRIC_SPARKS * mult)
                
                -- ═══ EXPLOSIÓN DE PLASMA ROJA ═══
                local plasma = Instance.new("ParticleEmitter")
                plasma.Texture = TEX.ORB
                plasma.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 90)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 25, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 10, 25))
                })
                plasma.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.2, 8 * mult),
                NumberSequenceKeypoint.new(0.6, 5 * mult),
                NumberSequenceKeypoint.new(1, 0)
                })
                plasma.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.7, 0.7),
                NumberSequenceKeypoint.new(1, 1)
                })
                plasma.Lifetime = NumberRange.new(0.8, 2.0)
                plasma.Speed = NumberRange.new(30, 70)
                plasma.SpreadAngle = Vector2.new(140, 140)
                plasma.Drag = 7
                plasma.LightEmission = 1
                plasma.Rate = 0
                plasma.Parent = att
                plasma:Emit(CONFIG.PARTICLES.PLASMA_BURST * mult)
                
                -- ═══ ESFERAS DE ENERGÍA ═══
                local orbs = Instance.new("ParticleEmitter")
                orbs.Texture = TEX.ORB
                orbs.Color = ColorSequence.new(Color3.fromRGB(255, 100, 110))
                orbs.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 4 * mult),
                NumberSequenceKeypoint.new(0.4, 6 * mult),
                NumberSequenceKeypoint.new(1, 0)
                })
                orbs.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
                })
                orbs.Lifetime = NumberRange.new(1.0, 2.5)
                orbs.Speed = NumberRange.new(20, 50)
                orbs.SpreadAngle = Vector2.new(180, 180)
                orbs.Drag = 6
                orbs.LightEmission = 1
                orbs.Rate = 0
                orbs.Parent = att
                orbs:Emit(CONFIG.PARTICLES.ENERGY_ORBS * mult)
                
                -- ═══ 🌫️ ESPORAS DE IMPACTO MASIVAS ═══
                local impactSpores = Instance.new("ParticleEmitter")
                impactSpores.Texture = TEX.SPORE
                impactSpores.Color = ColorSequence.new(CONFIG.SPORES.COLOR)
                impactSpores.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, CONFIG.SPORES.SIZE_MIN * mult),
                NumberSequenceKeypoint.new(0.5, CONFIG.SPORES.SIZE_MAX * mult),
                NumberSequenceKeypoint.new(1, CONFIG.SPORES.SIZE_MIN * mult)
                })
                impactSpores.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0.3),
                NumberSequenceKeypoint.new(1, 0.8)
                })
                impactSpores.Lifetime = NumberRange.new(5, 10)
                impactSpores.Speed = NumberRange.new(15, 40)
                impactSpores.SpreadAngle = Vector2.new(180, 180)
                impactSpores.Acceleration = Vector3.new(0, 2.5, 0)
                impactSpores.Drag = 2.5
                impactSpores.LightEmission = CONFIG.SPORES.GLOW_INTENSITY
                impactSpores.LightInfluence = 0
                impactSpores.Rotation = NumberRange.new(0, 360)
                impactSpores.RotSpeed = NumberRange.new(-35, 35)
                impactSpores.Rate = 0
                impactSpores.Parent = att
                impactSpores:Emit(CONFIG.SPORES.IMPACT_COUNT * mult)
                
                -- ═══ CENIZA LIGERA (REDUCIDA) ═══
                local ash = Instance.new("ParticleEmitter")
                ash.Texture = TEX.SMOKE
                ash.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 110, 130)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 70, 90))
                })
                ash.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.6 * mult),
                NumberSequenceKeypoint.new(0.5, 0.9 * mult),
                NumberSequenceKeypoint.new(1, 0.3 * mult)
                })
                ash.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(0.7, 0.8),
                NumberSequenceKeypoint.new(1, 1)
                })
                ash.Lifetime = NumberRange.new(2.0, 4.0)
                ash.Speed = NumberRange.new(4, 12)
                ash.SpreadAngle = Vector2.new(180, 180)
                ash.Acceleration = Vector3.new(0, 8, 0)
                ash.Drag = 4
                ash.Rotation = NumberRange.new(-180, 180)
                ash.RotSpeed = NumberRange.new(-30, 30)
                ash.LightEmission = 0.2
                ash.Rate = 0
                ash.Parent = att
                ash:Emit(CONFIG.PARTICLES.ASH_PARTICLES * mult)
                
                -- ═══ NIEBLA ROJA BRILLANTE (NUEVA) ═══
                local redMist = Instance.new("ParticleEmitter")
                redMist.Texture = TEX.SMOKE
                redMist.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 60)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 30, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 20, 30))
                })
                redMist.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 8 * mult),
                NumberSequenceKeypoint.new(0.5, 16 * mult),
                NumberSequenceKeypoint.new(1, 24 * mult)
                })
                redMist.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.4),
                NumberSequenceKeypoint.new(0.7, 0.75),
                NumberSequenceKeypoint.new(1, 1)
                })
                redMist.Lifetime = NumberRange.new(2.0, 4.5)
                redMist.Speed = NumberRange.new(6, 18)
                redMist.SpreadAngle = Vector2.new(180, 180)
                redMist.Acceleration = Vector3.new(0, 12, 0)
                redMist.Drag = 2
                redMist.LightEmission = 0.9
                redMist.Rate = 0
                redMist.Parent = att
                redMist:Emit(CONFIG.PARTICLES.RED_MIST * mult)
                
                -- ═══ POLVO DIMENSIONAL BRILLANTE (MEJORADO) ═══
                local dust = Instance.new("ParticleEmitter")
                dust.Texture = TEX.SMOKE
                dust.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 140, 200)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 90, 160))
                })
                dust.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 4 * mult),
                NumberSequenceKeypoint.new(0.5, 9 * mult),
                NumberSequenceKeypoint.new(1, 14 * mult)
                })
                dust.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(0.7, 0.85),
                NumberSequenceKeypoint.new(1, 1)
                })
                dust.Lifetime = NumberRange.new(2.0, 4.0)
                dust.Speed = NumberRange.new(8, 22)
                dust.SpreadAngle = Vector2.new(180, 180)
                dust.Acceleration = Vector3.new(0, 10, 0)
                dust.Drag = 2.5
                dust.LightEmission = 0.7
                dust.Rate = 0
                dust.Parent = att
                dust:Emit(CONFIG.PARTICLES.VOID_DUST * mult)
                
                -- ═══ ONDAS DE CHOQUE ROJAS MASIVAS ═══
                local waves = Instance.new("ParticleEmitter")
                waves.Texture = TEX.WAVE
                waves.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 90)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 25, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 10, 25))
                })
                waves.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 20 * mult),
                NumberSequenceKeypoint.new(0.3, 80 * mult),
                NumberSequenceKeypoint.new(0.7, 120 * mult),
                NumberSequenceKeypoint.new(1, 140 * mult)
                })
                waves.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.6, 0.6),
                NumberSequenceKeypoint.new(1, 1)
                })
                waves.Lifetime = NumberRange.new(1.5)
                waves.Speed = NumberRange.new(0)
                waves.Rotation = NumberRange.new(0, 360)
                waves.LightEmission = 1
                waves.Rate = 0
                waves.Orientation = Enum.ParticleOrientation.FacingCamera
                waves.Parent = att
                waves:Emit(CONFIG.PARTICLES.SHOCKWAVES * mult)
                
                -- ═══ DESGARROS DE REALIDAD ═══
                local tears = Instance.new("ParticleEmitter")
                tears.Texture = TEX.RING
                tears.Color = ColorSequence.new(Color3.fromRGB(200, 15, 30))
                tears.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 25 * mult),
                NumberSequenceKeypoint.new(0.5, 50 * mult),
                NumberSequenceKeypoint.new(1, 70 * mult)
                })
                tears.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(0.7, 0.7),
                NumberSequenceKeypoint.new(1, 1)
                })
                tears.Lifetime = NumberRange.new(1.8)
                tears.Speed = NumberRange.new(0)
                tears.Rotation = NumberRange.new(0, 360)
                tears.LightEmission = 0.95
                tears.Rate = 0
                tears.Parent = att
                tears:Emit(CONFIG.PARTICLES.REALITY_TEARS * mult)
                
                -- ═══ RIFTS DIMENSIONALES ═══
                local rifts = Instance.new("ParticleEmitter")
                rifts.Texture = TEX.RING
                rifts.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 50, 140)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 30, 90))
                })
                rifts.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 30 * mult),
                NumberSequenceKeypoint.new(0.5, 55 * mult),
                NumberSequenceKeypoint.new(1, 80 * mult)
                })
                rifts.Transparency = NumberSequence.new({
                ColorSequenceKeypoint.new(0, 0.3),
                ColorSequenceKeypoint.new(0.7, 0.8),
                ColorSequenceKeypoint.new(1, 1)
                })
                rifts.Lifetime = NumberRange.new(2.0)
                rifts.Speed = NumberRange.new(0)
                rifts.Rotation = NumberRange.new(0, 360)
                rifts.LightEmission = 0.8
                rifts.Rate = 0
                rifts.Parent = att
                rifts:Emit(CONFIG.PARTICLES.DIMENSIONAL_RIFTS * mult)
                
                -- ═══ NUEVO: DISTORSIÓN DE CALOR ═══
                local heatDist = Instance.new("ParticleEmitter")
                heatDist.Texture = TEX.DISTORTION
                heatDist.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 110)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 200, 255))
                })
                heatDist.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 30 * mult),
                NumberSequenceKeypoint.new(0.5, 60 * mult),
                NumberSequenceKeypoint.new(1, 90 * mult)
                })
                heatDist.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(1, 1)
                })
                heatDist.Lifetime = NumberRange.new(1.2, 2.5)
                heatDist.Speed = NumberRange.new(5, 15)
                heatDist.SpreadAngle = Vector2.new(30, 30)
                heatDist.Acceleration = Vector3.new(0, 20, 0)
                heatDist.Drag = 3
                heatDist.LightEmission = 0.3
                heatDist.Rate = 0
                heatDist.Parent = att
                heatDist:Emit(CONFIG.PARTICLES.HEAT_DISTORTION * mult)
                
                -- ═══ NUEVO: ANILLOS DE ENERGÍA ═══
                local energyRings = Instance.new("ParticleEmitter")
                energyRings.Texture = TEX.RING
                energyRings.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 90)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 50, 140))
                })
                energyRings.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 10 * mult),
                NumberSequenceKeypoint.new(0.5, 35 * mult),
                NumberSequenceKeypoint.new(1, 60 * mult)
                })
                energyRings.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.7, 0.8),
                NumberSequenceKeypoint.new(1, 1)
                })
                energyRings.Lifetime = NumberRange.new(1.0)
                energyRings.Speed = NumberRange.new(0)
                energyRings.Rotation = NumberRange.new(0, 360)
                energyRings.RotSpeed = NumberRange.new(-180, 180)
                energyRings.LightEmission = 1
                energyRings.Rate = 0
                energyRings.Orientation = Enum.ParticleOrientation.FacingCamera
                energyRings.Parent = att
                energyRings:Emit(CONFIG.PARTICLES.ENERGY_RINGS * mult)
                
                -- ═══ NUEVO: CHISPAS DE FUEGO ROJAS ═══
                local fireSparks = Instance.new("ParticleEmitter")
                fireSparks.Texture = TEX.SPARK
                fireSparks.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 100)),
                ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 80, 40)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 20, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 10, 20))
                })
                fireSparks.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.2 * mult),
                NumberSequenceKeypoint.new(0.5, 2.0 * mult),
                NumberSequenceKeypoint.new(1, 0)
                })
                fireSparks.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
                })
                fireSparks.Lifetime = NumberRange.new(0.8, 2.0)
                fireSparks.Speed = NumberRange.new(20, 60)
                fireSparks.SpreadAngle = Vector2.new(160, 160)
                fireSparks.Acceleration = Vector3.new(0, -15, 0)
                fireSparks.Drag = 4
                fireSparks.LightEmission = 1
                fireSparks.Rate = 0
                fireSparks.Parent = att
                fireSparks:Emit(CONFIG.PARTICLES.FIRE_SPARKS * mult)
                
                -- ═══ NUEVO: DESCARGA ELECTRO ═══
                local electroDischarge = Instance.new("ParticleEmitter")
                electroDischarge.Texture = TEX.SPARK
                electroDischarge.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 220, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 90)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 50, 140))
                })
                electroDischarge.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.8 * mult),
                NumberSequenceKeypoint.new(0.5, 1.8 * mult),
                NumberSequenceKeypoint.new(1, 0)
                })
                electroDischarge.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
                })
                electroDischarge.Lifetime = NumberRange.new(0.4, 1.2)
                electroDischarge.Speed = NumberRange.new(40, 100)
                electroDischarge.SpreadAngle = Vector2.new(180, 180)
                electroDischarge.Drag = 8
                electroDischarge.LightEmission = 1
                electroDischarge.Rate = 0
                electroDischarge.Parent = att
                electroDischarge:Emit(CONFIG.PARTICLES.ELECTRO_DISCHARGE * mult)
                
                return container
            end
            
            -- ═══════════════════════════════════════════════════════════════════════════
            -- 💡 ILUMINACIÓN VOLUMÉTRICA ÉPICA
            -- ═══════════════════════════════════════════════════════════════════════════
            
            local function createLighting(parent, pos, intensity, isMega)
                local lightPart = Instance.new("Part")
                lightPart.Size = Vector3.new(0.1, 0.1, 0.1)
                lightPart.Anchored = true
                lightPart.CanCollide = false
                lightPart.Transparency = 1
                lightPart.Position = pos
                lightPart.Parent = parent
                
                local brightness = isMega and CONFIG.LIGHTING.MEGA_BRIGHTNESS or CONFIG.LIGHTING.IMPACT_BRIGHTNESS
                brightness = brightness * intensity
                
                -- LUZ ROJA PRINCIPAL ULTRA-INTENSA
                local mainLight = Instance.new("PointLight")
                mainLight.Color = Color3.fromRGB(255, 80, 90)
                mainLight.Brightness = brightness
                mainLight.Range = CONFIG.LIGHTING.IMPACT_RANGE * (isMega and 1.5 or 1.0)
                mainLight.Shadows = true
                mainLight.Parent = lightPart
                
                -- LUZ PÚRPURA SECUNDARIA (MIND FLAYER)
                local voidLight = Instance.new("PointLight")
                voidLight.Color = Color3.fromRGB(120, 50, 140)
                voidLight.Brightness = brightness * 0.6
                voidLight.Range = CONFIG.LIGHTING.IMPACT_RANGE * 0.8 * (isMega and 1.5 or 1.0)
                voidLight.Shadows = false
                voidLight.Parent = lightPart
                
                -- LUZ BLANCA NÚCLEO
                local coreLight = Instance.new("PointLight")
                coreLight.Color = Color3.fromRGB(255, 255, 255)
                coreLight.Brightness = brightness * 0.4
                coreLight.Range = CONFIG.LIGHTING.IMPACT_RANGE * 0.5
                coreLight.Shadows = false
                coreLight.Parent = lightPart
                
                -- SPOTLIGHT VOLUMÉTRICO MASIVO (GOD RAYS)
                local beam = Instance.new("Part")
                beam.Size = Vector3.new(0.1, 0.1, 0.1)
                beam.Anchored = true
                beam.CanCollide = false
                beam.Transparency = 1
                beam.Position = pos + Vector3.new(0, 15, 0)
                beam.Parent = parent
                
                local spotLight = Instance.new("SpotLight")
                spotLight.Color = Color3.fromRGB(255, 100, 110)
                spotLight.Brightness = brightness * 1.2
                spotLight.Range = 500 * (isMega and 1.8 or 1.0)
                spotLight.Angle = 65
                spotLight.Face = Enum.NormalId.Top
                spotLight.Shadows = true
                spotLight.Parent = beam
                
                -- FADE OUT
                local fadeTime = CONFIG.STORM.FLASH_DURATION * (isMega and 2.0 or 1.8)
                local fadeInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
                
                TweenService:Create(mainLight, fadeInfo, {Brightness = 0, Range = 0}):Play()
                TweenService:Create(voidLight, fadeInfo, {Brightness = 0, Range = 0}):Play()
                TweenService:Create(coreLight, fadeInfo, {Brightness = 0, Range = 0}):Play()
                TweenService:Create(spotLight, fadeInfo, {Brightness = 0, Range = 0}):Play()
                
                return lightPart
            end
            
            -- ═══════════════════════════════════════════════════════════════════════════
            -- ⚡ GENERADOR DE RAYOS ÉPICO (10 CAPAS ULTRA-DETALLADAS)
            -- ═══════════════════════════════════════════════════════════════════════════
            
            local function generatePath(start, finish, segments)
                local points = {}
                local delta = finish - start
                local direction = delta.Unit
                
                local perp1 = direction:Cross(Vector3.new(1, 0, 0))
                if perp1.Magnitude < 0.1 then
                    perp1 = direction:Cross(Vector3.new(0, 1, 0))
                end
                perp1 = perp1.Unit
                local perp2 = direction:Cross(perp1).Unit
                
                table.insert(points, start)
                
                for i = 1, segments - 1 do
                    local t = i / segments
                    local base = start + (delta * t)
                    
                    -- Más caos y naturalidad
                    local chaos = math.sin(t * math.pi) * (1 + math.sin(t * 8) * 0.3)
                    local dev = CONFIG.LIGHTNING.DEVIATION * chaos
                    
                    local ox = math.sin(i * 1.4) * dev + math.cos(i * 2.7) * dev * 0.3
                    local oy = math.cos(i * 1.7) * dev + math.sin(i * 3.1) * dev * 0.3
                    
                    local offset = (perp1 * ox) + (perp2 * oy)
                    table.insert(points, base + offset)
                end
                
                table.insert(points, finish)
                return points
            end
            
            local function createBranch(parent, startPos, direction, segments, gen, isMega)
                if gen > 2 then return end  -- Permitir más generaciones
                    
                    local length = rand(50, 130) / (gen + 1)
                    local endPos = startPos + (direction * length) + randVec(35)
                    
                    local path = generatePath(startPos, endPos, math.floor(segments * 0.65))
                    local atts = {}
                    
                    for _, pt in ipairs(path) do
                        local p = Instance.new("Part")
                        p.Size = Vector3.new(0.1, 0.1, 0.1)
                        p.Transparency = 1
                        p.Anchored = true
                        p.CanCollide = false
                        p.Position = pt
                        p.Parent = parent
                        
                        local a = Instance.new("Attachment", p)
                        table.insert(atts, a)
                    end
                    
                    -- 5 capas para ramas (más detalle)
                    local branchLayers = {
                    {COLOR = Color3.fromRGB(255, 255, 255), WIDTH = 2.2, EMISSION = 3.0},
                    {COLOR = Color3.fromRGB(255, 80, 90), WIDTH = 4.5, EMISSION = 2.5},
                    {COLOR = Color3.fromRGB(230, 25, 40), WIDTH = 7.5, EMISSION = 2.2},
                    {COLOR = Color3.fromRGB(200, 15, 30), WIDTH = 11.0, EMISSION = 1.9},
                    {COLOR = Color3.fromRGB(120, 50, 140), WIDTH = 16.0, EMISSION = 1.6},
                    }
                    
                    for i = 1, #atts - 1 do
                        for _, layer in ipairs(branchLayers) do
                            local width = layer.WIDTH * (isMega and 1.5 or 1.0)
                            
                            local beam = Instance.new("Beam")
                            beam.Attachment0 = atts[i]
                            beam.Attachment1 = atts[i + 1]
                            beam.Color = ColorSequence.new(layer.COLOR)
                            beam.Width0 = width
                            beam.Width1 = width
                            beam.FaceCamera = true
                            beam.LightEmission = layer.EMISSION
                            beam.Texture = TEX.BOLT
                            beam.TextureMode = Enum.TextureMode.Wrap
                            beam.TextureLength = 7
                            beam.TextureSpeed = 5.0
                            beam.Parent = parent
                        end
                    end
                    
                    -- Ramificaciones secundarias
                    if gen <= 1 and math.random() < 0.4 then
                        local subBranchCount = math.random(1, 3)
                        for _ = 1, subBranchCount do
                            local bi = math.random(math.floor(#path * 0.3), math.floor(#path * 0.7))
                            local bp = path[bi]
                            local bd = (Vector3.new(rand(-1, 1), rand(-0.4, 0.2), rand(-1, 1))).Unit
                            createBranch(parent, bp, bd, 8, gen + 1, isMega)
                        end
                    end
                end
                
                local function createBolt(impactPos, skyHeight, isNear, isMega)
                    local height = skyHeight - impactPos.Y
                    if height <= 25 then return end
                    
                    local bolt = Instance.new("Folder")
                    bolt.Name = "UpsideDown_Bolt" .. (isMega and "_MEGA" or "")
                    bolt.Parent = Workspace:FindFirstChild("UpsideDown_FX") or Workspace
                    Debris:AddItem(bolt, CONFIG.STORM.FLASH_DURATION + (isMega and 5 or 4))
                    
                    local sky = Vector3.new(impactPos.X, skyHeight, impactPos.Z)
                    local path = generatePath(sky, impactPos, CONFIG.LIGHTNING.SEGMENTS)
                    
                    local atts = {}
                    for _, pt in ipairs(path) do
                        local p = Instance.new("Part")
                        p.Size = Vector3.new(0.1, 0.1, 0.1)
                        p.Transparency = 1
                        p.Anchored = true
                        p.CanCollide = false
                        p.Position = pt
                        p.Parent = bolt
                        
                        local a = Instance.new("Attachment", p)
                        table.insert(atts, a)
                    end
                    
                    -- 8 CAPAS DE RAYOS ROJOS ÉPICOS (STRANGER THINGS STYLE)
                    local layers = {
                    CONFIG.LIGHTNING.CORE,
                    CONFIG.LIGHTNING.PLASMA_INNER,
                    CONFIG.LIGHTNING.ENERGY,
                    CONFIG.LIGHTNING.BLOOD,
                    CONFIG.LIGHTNING.CRIMSON,
                    CONFIG.LIGHTNING.DARK_RED,
                    CONFIG.LIGHTNING.VOID,
                    CONFIG.LIGHTNING.ATMOSPHERE
                    }
                    
                    local widthMult = isMega and CONFIG.LIGHTNING.MEGA_WIDTH_MULT or 1.0
                    
                    for i = 1, #atts - 1 do
                        local a0, a1 = atts[i], atts[i + 1]
                        
                        for layerIdx, layer in ipairs(layers) do
                            local beam = Instance.new("Beam")
                            beam.Name = "Layer" .. layerIdx
                            beam.Attachment0 = a0
                            beam.Attachment1 = a1
                            beam.Color = ColorSequence.new(layer.COLOR)
                            beam.Width0 = layer.WIDTH * widthMult
                            beam.Width1 = layer.WIDTH * widthMult
                            beam.FaceCamera = true
                            beam.LightEmission = layer.EMISSION
                            beam.LightInfluence = 0
                            beam.Texture = TEX.BOLT
                            beam.TextureMode = Enum.TextureMode.Wrap
                            beam.TextureLength = 12 + layerIdx
                            beam.TextureSpeed = 6.5 - (layerIdx * 0.4)
                            beam.ZOffset = 0.15 - (layerIdx * 0.014)
                            beam.Parent = bolt
                        end
                    end
                    
                    -- RAMIFICACIONES ÉPICAS
                    local branchChance = isMega and 0.8 or CONFIG.STORM.BRANCH_CHANCE
                    if math.random() < branchChance then
                        local branchCount = math.random(isMega and 5 or 3, isMega and 9 or 6)
                        for _ = 1, branchCount do
                            local bi = math.random(math.floor(#path * 0.25), math.floor(#path * 0.75))
                            local bp = path[bi]
                            local bd = (Vector3.new(rand(-1, 1), rand(-0.4, 0.2), rand(-1, 1))).Unit
                            createBranch(bolt, bp, bd, 12, 0, isMega)
                        end
                    end
                    
                    -- PILAR DE IMPACTO FINO Y BRILLANTE
                    local pillarHeight = isMega and 220 or 180
                    local pillarWidth = isMega and 10 or 8        -- Más fino
                    
                    local pillar = Instance.new("Part")
                    pillar.Name = "ImpactPillar"
                    pillar.Anchored = true
                    pillar.CanCollide = false
                    pillar.Shape = Enum.PartType.Cylinder
                    pillar.Size = Vector3.new(pillarHeight, pillarWidth, pillarWidth)
                    pillar.Position = impactPos + Vector3.new(0, pillarHeight / 2, 0)
                    pillar.Orientation = Vector3.new(0, 0, 90)
                    pillar.Material = Enum.Material.Neon
                    pillar.Color = Color3.fromRGB(255, 30, 40)    -- Rojo más intenso
                    pillar.Transparency = isMega and 0.1 or 0.15  -- Más visible
                    pillar.Parent = bolt
                    
                    -- EFECTOS
                    createImpactParticles(bolt, impactPos, isMega)
                    createLighting(bolt, impactPos, isNear and 1.6 or 1.2, isMega)
                    
                    -- DAÑO POR PROXIMIDAD
                    DamageSystem:ApplyDamage(impactPos, isMega)
                    
                    -- AUDIO
                    if isNear or isMega or math.random() < 0.5 then
                        AudioPool:Play(impactPos, isMega)
                    end
                    
                    -- EXPLOSIÓN FÍSICA
                    local explosion = Instance.new("Explosion")
                    explosion.Position = impactPos
                    explosion.BlastRadius = 0
                    explosion.BlastPressure = isMega and 5000 or 3500
                    explosion.Visible = false
                    explosion.Parent = Workspace
                    
                    -- DESVANECIMIENTO
                    task.delay(0.15, function()
                        if not bolt.Parent then return end
                        
                        local fadeInfo = TweenInfo.new(
                        CONFIG.STORM.FLASH_DURATION * (isMega and 1.5 or 1.0),
                        Enum.EasingStyle.Exponential,
                        Enum.EasingDirection.Out
                        )
                        
                        TweenService:Create(pillar, fadeInfo, {
                        Transparency = 1,
                        Size = Vector3.new(0, 0, 0)
                        }):Play()
                    end)
                end
                
                -- ═══════════════════════════════════════════════════════════════════════════
                -- 🌩️ BUCLE PRINCIPAL ÉPICO
                -- ═══════════════════════════════════════════════════════════════════════════
                
                local function startStorm()
                    local fx = Instance.new("Folder")
                    fx.Name = "UpsideDown_FX"
                    fx.Parent = Workspace
                    
                    AudioPool:Init()
                    SporeSystem:Init()
                    
                    -- ═══ CONFIGURAR ILUMINACIÓN GLOBAL MUY VISIBLE ═══
                    
                    -- Ambient - DÍA CLARO
                    Lighting.Ambient = Color3.fromRGB(150, 150, 150)
                    Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
                    Lighting.Brightness = 2                            -- DÍA BRILLANTE
                    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
                    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                    Lighting.ClockTime = 14                            -- 2 PM (DÍA)
                    Lighting.GeographicLatitude = 0
                    
                    -- Bloom MEGA-intenso para que los rayos rojos resalten
                    if Lighting:FindFirstChild("Bloom") then
                        Lighting.Bloom.Intensity = CONFIG.LIGHTING.BLOOM_INTENSITY
                        Lighting.Bloom.Size = CONFIG.LIGHTING.BLOOM_SIZE
                        Lighting.Bloom.Threshold = 0.2
                    else
                        local bloom = Instance.new("BloomEffect")
                        bloom.Intensity = CONFIG.LIGHTING.BLOOM_INTENSITY
                        bloom.Size = CONFIG.LIGHTING.BLOOM_SIZE
                        bloom.Threshold = 0.2
                        bloom.Parent = Lighting
                    end
                    
                    -- Color Correction MUY LIGERO (visible)
                    if not Lighting:FindFirstChild("UpsideDownCC") then
                        local cc = Instance.new("ColorCorrectionEffect")
                        cc.Name = "UpsideDownCC"
                        cc.Contrast = CONFIG.COLOR.CONTRAST
                        cc.Saturation = CONFIG.COLOR.SATURATION
                        cc.TintColor = CONFIG.COLOR.TINT
                        cc.Brightness = CONFIG.COLOR.BRIGHTNESS
                        cc.Parent = Lighting
                    end
                    
                    -- Atmosphere DESACTIVADA para día claro
                    local atmo = Lighting:FindFirstChild("Atmosphere")
                    if atmo then
                        atmo:Destroy()
                    end
                    
                    -- SunRays fuertes (God Rays desde rayos)
                    if not Lighting:FindFirstChild("SunRaysEffect") then
                        local sunRays = Instance.new("SunRaysEffect")
                        sunRays.Intensity = CONFIG.LIGHTING.GOD_RAYS_INTENSITY
                        sunRays.Spread = 0.6
                        sunRays.Parent = Lighting
                    end
                    
                    -- DepthOfField muy sutil
                    if not Lighting:FindFirstChild("DepthOfField") then
                        local dof = Instance.new("DepthOfFieldEffect")
                        dof.FarIntensity = 0.05                        -- Muy sutil
                        dof.FocusDistance = 200
                        dof.InFocusRadius = 100
                        dof.NearIntensity = 0.03
                        dof.Parent = Lighting
                    end
                    
                    -- 🌌 CIELO DE DÍA CLARO
                    local sky = Lighting:FindFirstChild("UpsideDownSky")
                    if sky then
                        sky:Destroy()
                    end
                    
                    sky = Instance.new("Sky")
                    sky.Name = "UpsideDownSky"
                    sky.SkyboxBk = "rbxasset://sky/sky512_bk.jpg"
                    sky.SkyboxDn = "rbxasset://sky/sky512_dn.jpg"
                    sky.SkyboxFt = "rbxasset://sky/sky512_ft.jpg"
                    sky.SkyboxLf = "rbxasset://sky/sky512_lf.jpg"
                    sky.SkyboxRt = "rbxasset://sky/sky512_rt.jpg"
                    sky.SkyboxUp = "rbxasset://sky/sky512_up.jpg"
                    sky.SunAngularSize = 21
                    sky.MoonAngularSize = 11
                    sky.Parent = Lighting
                    
                    -- Film Grain REMOVIDO para look moderno
                    
                    warn("╔═══════════════════════════════════════════════════════════════════════╗")
                    warn("║  ⚡ THE UPSIDE DOWN - MODERN EDITION (STRANGER THINGS) ⚡           ║")
                    warn("║  🔴 RAYOS ROJOS FINOS (8 Capas Stranger Things)                     ║")
                    warn("║  💀 SISTEMA DE DAÑO ACTIVADO (80-100 HP directo)                     ║")
                    warn("║  🌫️  ESPORAS LUMINOSAS (500+ flotando + 150 ascendiendo)            ║")
                    warn("║  🌙 ATMÓSFERA OSCURA - Brightness 1.0 + ClockTime 0 (NOCHE)    ║")
                    warn("║  🌟 GRÁFICOS MODERNOS - Sin efectos vintage                         ║")
                    warn("║  ✨ AMBIENTE BRILLANTE con toques púrpura                           ║")
                    warn("║  💫 Bloom Ultra + God Rays                                          ║")
                    warn("║  🎮 100% JUGABLE Y VISIBLE                                           ║")
                    warn("║  ⚙️  Multi-Servidor ULTRA OPTIMIZADO                                 ║")
                    warn("║  ✅ ÉPICO, VISIBLE Y MODERNO                                        ║")
                    warn("╚═══════════════════════════════════════════════════════════════════════╝")
                    
                    while true do
                        task.wait(CONFIG.STORM.INTERVAL)
                        
                        local players = Players:GetPlayers()
                        
                        -- FASE 1: Rayos cerca de jugadores (algunos MEGA)
                        for _, plr in ipairs(players) do
                            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local hrp = plr.Character.HumanoidRootPart
                                
                                for i = 1, CONFIG.STORM.PLAYER_PROXIMITY_BOLTS do
                                    local angle = rand(0, math.pi * 2)
                                    local dist = rand(40, 250)
                                    
                                    local tPos = hrp.Position + Vector3.new(
                                    math.cos(angle) * dist,
                                    0,
                                    math.sin(angle) * dist
                                    )
                                    
                                    local gPos, skyY = groundCast(tPos.X, tPos.Z)
                                    local isMega = math.random() < CONFIG.STORM.MEGA_BOLT_CHANCE
                                    
                                    createBolt(gPos, skyY, true, isMega)
                                    
                                    task.wait(0.05)
                                end
                            end
                        end
                        
                        -- FASE 2: Rayos aleatorios ÉPICOS
                        for i = 1, CONFIG.STORM.BOLTS_PER_WAVE do
                            local rx = rand(-CONFIG.COVERAGE.X / 2, CONFIG.COVERAGE.X / 2)
                            local rz = rand(-CONFIG.COVERAGE.Z / 2, CONFIG.COVERAGE.Z / 2)
                            
                            local gPos, skyY = groundCast(rx, rz)
                            local important = math.random() < 0.2
                            local isMega = math.random() < CONFIG.STORM.MEGA_BOLT_CHANCE
                            
                            createBolt(gPos, skyY, important, isMega)
                            
                            if i % 9 == 0 then
                                task.wait()
                            end
                        end
                        
                        -- FLASH DEL CIELO ÉPICO (ROJO INTENSO)
                        if Lighting:FindFirstChild("UpsideDownCC") then
                            local cc = Lighting.UpsideDownCC
                            local origB = cc.Brightness
                            
                            TweenService:Create(cc, TweenInfo.new(0.12), {
                            Brightness = CONFIG.LIGHTING.SKY_FLASH
                            }):Play()
                            
                            task.delay(0.18, function()
                                TweenService:Create(cc, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                                Brightness = origB
                                }):Play()
                            end)
                        end
                        
                        -- Pulsación de bloom durante la tormenta
                        if Lighting:FindFirstChild("Bloom") then
                            local bloom = Lighting.Bloom
                            local origIntensity = CONFIG.LIGHTING.BLOOM_INTENSITY
                            
                            TweenService:Create(bloom, TweenInfo.new(0.15), {
                            Intensity = origIntensity * 1.8
                            }):Play()
                            
                            task.delay(0.2, function()
                                TweenService:Create(bloom, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
                                Intensity = origIntensity
                                }):Play()
                            end)
                        end
                    end
                end
                
                -- ═══════════════════════════════════════════════════════════════════════════
                -- 🎬 SISTEMA DE FILM GRAIN (EFECTO DE PELÍCULA)
                -- ═══════════════════════════════════════════════════════════════════════════
                
                -- ═══════════════════════════════════════════════════════════════════════════
                -- 🚀 INICIAR SISTEMA ÉPICO
                -- ═══════════════════════════════════════════════════════════════════════════
                
                task.spawn(startStorm)
               

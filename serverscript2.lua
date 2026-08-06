-- Generador de red continua de lianas (tipo "Stranger Things")
-- ServerScriptService
 
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
 
math.randomseed(tick())
 
-- ===================== CONFIG =====================
local VINES_MODEL_NAME = "Eliana_Network"
 
-- Densidad / cobertura del mapa
local GRID_SPACING = 120          -- Reducido: distancia entre nodos del grid (más densidad)
local GRID_PADDING = 500          -- Aumentado: padding extra alrededor del mapa (cobertura "infinita")
local MAX_CONNECTIONS_PER_NODE = 4 -- vecinos (grid usa 4: up/down/left/right)
 
-- Longitud y forma de la curva
local SEGMENTS_PER_CONNECTION = 15 -- AUMENTADO: más segmentos = curva más suave y menos "partida"
local CURVE_BIAS = 0.65            -- Intensidad del control point (más curvatura y caos)
local SEGMENT_THICKNESS = 1.2      -- Ajustado: grosor para que la textura de studs sea visible
 
-- Aspecto (carne viva y grasosa - AHORA CON ESTILO STUDS GARANTIZADO)
local VINE_COLOR = Color3.fromRGB(120, 35, 45) -- Tono de carne oscura/negra y roja
local VINE_MATERIAL = Enum.Material.Plastic -- Material clásico de Roblox, necesario para SurfaceType.Studs
local VINE_TRANSPARENCY = 0
local VINE_GLOSS_PARTICLES = true -- brillo húmedo (grasoso)
 
-- Daño y efectos
local VINE_TOUCH_DAMAGE = 5       -- Daño que se inflige al pisar la liana
local SWAY_AMPLITUDE = 0.9        -- cuánto se balancea (en studs)
local SWAY_SPEED_MIN = 0.35
local SWAY_SPEED_MAX = 0.9
 
-- Sonido al pisar
local STEP_SOUND_ID = "rbxassetid://907668984" -- tu id pedido
local SOUND_POOL_SIZE = 10        -- pool reutilizable de sonidos
local SOUND_VOLUME = 1.0
local SOUND_THROTTLE_SEC = 0.65   -- Tiempo de espera antes de oír el sonido/recibir daño de nuevo
 
-- Performance / límites
local MAX_PARTS_TOTAL = 8000      -- Safety cap
 
-- ================= HELPERS =================
local function randFloat(a,b) return a + math.random() * (b - a) end
 
local function bezierQuad(p0, pc, p1, t)
    local u = 1 - t
    return (u*u)*p0 + (2*u*t)*pc + (t*t)*p1
end
 
-- Detectar área del mapa (robusto)
local function obtenerAreaMapa()
    local mapBounds = Workspace:FindFirstChild("MapBounds")
    if mapBounds and mapBounds:IsA("BasePart") then
        return mapBounds.Position, mapBounds.Size
    end
    local mapModel = Workspace:FindFirstChild("Map")
    if mapModel and mapModel:IsA("Model") then
        local ok, size = pcall(function() return mapModel:GetExtentsSize() end)
            local center = nil
            if mapModel.PrimaryPart then
                center = mapModel.PrimaryPart.Position
            else
                -- fallback center (0) si no se puede calcular sin costosas operaciones
                center = Vector3.new(0,0,0)
            end
            if ok and size then
                return center, size
            else
                return center, Vector3.new(2000,20,2000)
            end
        end
        return Vector3.new(0,0,0), Vector3.new(2000,20,2000)
    end
    
    -- Raycast vertical para suelo
    local function raycastGroundAt(x, z, height)
        height = height or 6000
        local origin = Vector3.new(x, height, z)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {}
        local dir = Vector3.new(0, -height*2, 0)
        local res = Workspace:Raycast(origin, dir, params)
        if res and res.Position then
            return res.Position
        else
            return Vector3.new(x, 0, z)
        end
    end
    
    -- ================= Pool de sonidos para pasos =================
    local SoundPool = {}
    local soundPoolIndex = 1
    local function crearPoolSonidos()
        local folder = Instance.new("Folder")
        folder.Name = "ElianaSoundPool"
        folder.Parent = Workspace
        
        for i=1, SOUND_POOL_SIZE do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1,1,1)
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 1
            part.Position = Vector3.new(0,-5000,0)
            part.Parent = folder
            part.Locked = true
            
            local s = Instance.new("Sound")
            s.Parent = part
            s.SoundId = STEP_SOUND_ID
            s.Volume = SOUND_VOLUME
            s.RollOffMode = Enum.RollOffMode.Inverse
            s.MaxDistance = 80
            table.insert(SoundPool, {part=part, sound=s})
        end
    end
    
    local function playStepSoundAt(pos)
        if #SoundPool == 0 then return end
        local entry = SoundPool[soundPoolIndex]
        if not entry then return end
        entry.part.Position = pos
        if entry.sound.Playing then entry.sound:Stop() end
        entry.sound:Play()
        soundPoolIndex = soundPoolIndex + 1
        if soundPoolIndex > #SoundPool then soundPoolIndex = 1 end
    end
    
    -- =================== Creación de la red de nodos (grid) ===================
    -- Devuelve índices vecinos en la matriz lineal (grid row/col conversion)
    local function indexAt(row, col, cols)
        return (row - 1) * cols + col
    end
    
    -- =================== Construir conexiones contínuas entre nodos ===================
    local function buildNetwork(modelParent)
        -- Generamos grid y convertimos a matriz simple con rows/cols
        local center, size = obtenerAreaMapa()
        local areaX = math.max(size.X, 2000) + GRID_PADDING
        local areaZ = math.max(size.Z, 2000) + GRID_PADDING
        local cols = math.floor(areaX / GRID_SPACING) + 1
        local rows = math.floor(areaZ / GRID_SPACING) + 1
        local minX = center.X - areaX/2
        local minZ = center.Z - areaZ/2
        
        local nodes = {}
        for r = 1, rows do
            for c = 1, cols do
                local x = minX + (c-1)*GRID_SPACING
                local z = minZ + (r-1)*GRID_SPACING
                local p = raycastGroundAt(x, z)
                nodes[#nodes + 1] = {pos = p, row = r, col = c}
            end
        end
        
        -- cap safety: if too many nodes, we may downsample
        local estParts = (#nodes) * 2 * SEGMENTS_PER_CONNECTION
        if estParts > MAX_PARTS_TOTAL then
            warn("Eliana: demasiados segmentos estimados ("..tostring(estParts).."). ¡Puede haber lag! Reduce GRID_SPACING o SEGMENTS_PER_CONNECTION.")
        end
        
        -- Conectar cada nodo con su derecha y abajo (genera una red conectada)
        local totalCreatedParts = 0
        local connections = {} -- list of {p0,p1, controlSeed}
        for i, node in ipairs(nodes) do
            local r, c = node.row, node.col
            -- derecha
            if c < cols then
                local rightIndex = indexAt(r, c+1, cols)
                local p1 = node.pos
                local p2 = nodes[rightIndex].pos
                table.insert(connections, {p0 = p1, p1 = p2, seed = math.random()*1000})
            end
            -- abajo
            if r < rows then
                local downIndex = indexAt(r+1, c, cols)
                local p1 = node.pos
                local p2 = nodes[downIndex].pos
                table.insert(connections, {p0 = p1, p1 = p2, seed = math.random()*1000})
            end
        end
        
        -- Crear partes para cada conexión usando subdivisión Bezier
        for _, conn in ipairs(connections) do
            if totalCreatedParts > MAX_PARTS_TOTAL then break end
            
            local p0 = conn.p0
            local p1 = conn.p1
            -- control point para curvar la conexión
            local mid = (p0 + p1) / 2
            local rawPerp = Vector3.new(-(p1.Z - p0.Z), 0, (p1.X - p0.X))
            local perpUnit = (rawPerp.Magnitude > 0) and rawPerp.Unit or Vector3.new(1,0,0)
            local offsetMag = (p0 - p1).Magnitude * CURVE_BIAS * (0.6 + math.random()*0.9)
            -- Añadimos más variación vertical para un aspecto más orgánico y asqueroso
            local control = mid + perpUnit * offsetMag + Vector3.new(randFloat(-6,6), randFloat(4,12), randFloat(-6,6))
            
            -- crear puntos subdivididos y partes
            local prevPoint = nil
            for s = 0, SEGMENTS_PER_CONNECTION do
                local t = s / SEGMENTS_PER_CONNECTION
                local point = bezierQuad(p0, control, p1, t)
                if prevPoint then
                    -- crear segmento part entre prevPoint y point
                    local dir = (point - prevPoint)
                    local dist = dir.Magnitude
                    if dist > 0.01 then
                        local part = Instance.new("Part")
                        -- part.Shape = Enum.PartType.Block (default) - Se usa para la curva orgánica
                        part.Parent = modelParent
                        part.Anchored = true
                        part.CanCollide = false
                        part.Size = Vector3.new(SEGMENT_THICKNESS, dist, SEGMENT_THICKNESS)
                        part.Position = (prevPoint + point)/2
                        part.Material = VINE_MATERIAL -- Material Plastic con textura de studs
                        part.Color = VINE_COLOR
                        part.Transparency = VINE_TRANSPARENCY
                        part.Locked = true
                        
                        -- >>>>> CAMBIO CRÍTICO: Forzar Studs en TODAS las superficies (igual que el muro) <<<<<
                        -- Esto garantiza que se vea como un ladrillo clásico de Roblox por todos lados.
                        part.TopSurface = Enum.SurfaceType.Studs
                        part.BottomSurface = Enum.SurfaceType.Studs 
                        part.LeftSurface = Enum.SurfaceType.Studs
                        part.RightSurface = Enum.SurfaceType.Studs
                        part.FrontSurface = Enum.SurfaceType.Studs
                        part.BackSurface = Enum.SurfaceType.Studs
                        
                        -- orientar y dar pequeño twist
                        -- La rotación es clave para que los bloques formen la curva de liana
                        part.CFrame = CFrame.new(part.Position, point) * CFrame.Angles(math.rad(90), 0, 0)
                        part.CFrame = part.CFrame * CFrame.Angles(0, 0, math.rad(randFloat(-10,10)))
                        
                        -- particle sheen (grasoso)
                        if VINE_GLOSS_PARTICLES and math.random() < 0.12 then
                            local pe = Instance.new("ParticleEmitter")
                            pe.Parent = part
                            pe.Speed = NumberRange.new(0.05, 0.45)
                            pe.Rate = 4
                            pe.Lifetime = NumberRange.new(0.6, 1.2)
                            pe.Size = NumberSequence.new(6)
                            pe.Color = ColorSequence.new(Color3.fromRGB(150, 60, 70))
                            pe.LightEmission = 0.65
                            pe.Enabled = true
                        end
                        
                        -- etiqueta de uso interno para animación (seed)
                        part:SetAttribute("eliana_seed", conn.seed + s * 0.12)
                        
                        totalCreatedParts = totalCreatedParts + 1
                        if totalCreatedParts > MAX_PARTS_TOTAL then break end
                    end
                end
                prevPoint = point
            end
            if totalCreatedParts > MAX_PARTS_TOTAL then break end
        end
        
        print("Eliana: red generada (~parts):", totalCreatedParts)
    end
    
    -- =================== Animador central (batch safe) ===================
    local function animarRed(model)
        local parts = {}
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") then
                table.insert(parts, p)
            end
        end
        
        -- Precomputar seeds por parte
        local seeds = {}
        for i,p in ipairs(parts) do
            local s = p:GetAttribute("eliana_seed") or (math.random()*10)
            seeds[i] = s
        end
        
        local t0 = tick()
        local batch = 40
        local total = #parts
        local idx = 1
        
        while model and model.Parent do
            local now = tick() - t0
            -- procesar batch
            for b = 1, batch do
                local i = idx
                if i > total then i = ((i - 1) % total) + 1 end
                local part = parts[i]
                if part and part.Parent then
                    local seed = seeds[i] or 0.3
                    local speed = SWAY_SPEED_MIN + (seed % 1) * (SWAY_SPEED_MAX - SWAY_SPEED_MIN)
                    local amp = SWAY_AMPLITUDE * (0.6 + (seed % 1) * 0.9)
                    -- compute small offset perpendicular to the part forward direction
                    local forward = part.CFrame.LookVector
                    local right = part.CFrame.RightVector
                    -- oscillation using sin
                    local offset = right * (math.sin(now * speed + seed) * amp * 0.08) + Vector3.new(0, math.sin(now * speed * 0.7 + seed) * amp * 0.03, 0)
                    -- apply as small translation to original position (we keep basePos attribute)
                    local basePos = part:GetAttribute("eliana_basepos")
                    if not basePos then
                        basePos = part.Position
                        part:SetAttribute("eliana_basepos", basePos)
                    end
                    local target = basePos + offset
                    -- lerp to target for smoothness
                    part.Position = part.Position:Lerp(target, 0.22)
                end
                idx = idx + 1
                if idx > total then idx = 1 end
            end
            task.wait(0.03)
        end
    end
    
    -- =================== Touch handling (sonido y daño) ===================
    local playerLastStep = {} -- throttle per player by userId
    
    local function onPartTouched(part, other)
        local character = other.Parent
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local player = Players:GetPlayerFromCharacter(character)
        
        -- Solo aplica lógica si es un jugador (tiene Humanoid)
        if not player or not humanoid or humanoid.Health <= 0 then return end
        
        local now = tick()
        local last = playerLastStep[player.UserId] or 0
        
        -- Aplicar Throttle (límite de tiempo) al sonido y al daño
        if now - last < SOUND_THROTTLE_SEC then return end
        playerLastStep[player.UserId] = now
        
        -- 1. Aplicar DAÑO
        humanoid:TakeDamage(VINE_TOUCH_DAMAGE)
        
        -- 2. Reproducir SONIDO
        playStepSoundAt(part.Position)
    end
    
    -- Attach touch listeners to all parts in model (single connection using :GetDescendants once)
    local function attachTouchHandlers(model)
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Touched:Connect(function(other) onPartTouched(p, other) end)
                end
                end
                end
                    
                    -- =================== Main: crear modelo, pool, construir y animar ===================
                    local function crearElianaNetwork()
                        -- limpiar si existe
                        local existing = Workspace:FindFirstChild(VINES_MODEL_NAME)
                        if existing then
                            existing:Destroy()
                            task.wait()
                        end
                        
                        local model = Instance.new("Model")
                        model.Name = VINES_MODEL_NAME
                        model.Parent = Workspace
                        
                        crearPoolSonidos()
                        buildNetwork(model)
                        attachTouchHandlers(model)
                        
                        -- Inicia animación central en background
                        task.spawn(function()
                            animarRed(model)
                        end)
                    end
                    
                    -- Ejecutar
                    crearElianaNetwork()
                   

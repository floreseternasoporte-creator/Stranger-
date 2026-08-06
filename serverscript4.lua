-- Script del Servidor para Torres de Transmisión con Sistema de Alarma Tsunami Cinematográfico
-- VERSIÓN CORREGIDA - Sin obstrucciones, solo bocinas girando
-- Coloca este script en ServerScriptService
 
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
 
local AlarmDataStore = DataStoreService:GetDataStore("TsunamiAlarmData")
 
local CinematicEvent = Instance.new("RemoteEvent")
CinematicEvent.Name = "TsunamiCinematicEvent"
CinematicEvent.Parent = ReplicatedStorage
 
math.randomseed(tick())
 
-- ===================== CONFIGURACIÓN =====================
local TOWERS_MODEL_NAME = "Transmission_Towers"
local TOWER_SPACING = 800
local TOWER_SPAWN_PROBABILITY = 0.6
local MAX_TOWERS = 15
 
local TOWER_COLOR = Color3.fromRGB(139, 90, 60)
local TOWER_MATERIAL = Enum.Material.Plastic
local INSULATOR_COLOR = Color3.fromRGB(65, 75, 85)
 
local TOWER_HEIGHT = 220
local BASE_WIDTH = 30
local TOP_WIDTH = 12
local LEG_THICKNESS = 3.5
local CROSSBAR_THICKNESS = 2.5
local NUM_SECTIONS = 14
 
local CABLE_THICKNESS = 0.6
local CABLE_COLOR = Color3.fromRGB(30, 30, 30)
 
local PLATFORM_SIZE = 40
local PLATFORM_HEIGHT = 1.5
local PLATFORM_HOLE_SIZE = 8
 
local LIGHTHOUSE_COLOR = Color3.fromRGB(255, 0, 0)
local ALARM_SOUND_ID = "rbxassetid://6936261488"
local ALARM_DURATION = 120
 
local PRE_EARTHQUAKE_MUSIC = "rbxassetid://1177116301558"
local EARTHQUAKE_MUSIC = "rbxassetid://9045724335"
 
local ALL_LIGHTHOUSES = {}
 
-- ===================== HELPERS =====================
local function randFloat(a,b) return a + math.random() * (b - a) end
 
local function applyStudsStyle(part, color)
    part.Material = TOWER_MATERIAL
    part.Color = color or TOWER_COLOR
    part.Anchored = true
    part.CanCollide = true
    part.Locked = true
    
    part.TopSurface = Enum.SurfaceType.Studs
    part.BottomSurface = Enum.SurfaceType.Inlet
    part.LeftSurface = Enum.SurfaceType.Studs
    part.RightSurface = Enum.SurfaceType.Studs
    part.FrontSurface = Enum.SurfaceType.Studs
    part.BackSurface = Enum.SurfaceType.Studs
end
 
local function obtenerAreaMapa()
    local mapBounds = Workspace:FindFirstChild("MapBounds")
    if mapBounds and mapBounds:IsA("BasePart") then
        return mapBounds.Position, mapBounds.Size
    end
    local mapModel = Workspace:FindFirstChild("Map")
    if mapModel and mapModel:IsA("Model") then
        local ok, size = pcall(function() return mapModel:GetExtentsSize() end)
            local center = mapModel.PrimaryPart and mapModel.PrimaryPart.Position or Vector3.new(0,0,0)
            if ok and size then
                return center, size
            else
                return center, Vector3.new(1500,20,1500)
            end
        end
        return Vector3.new(0,0,0), Vector3.new(1500,20,1500)
    end
    
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
    
    local function createBeam(startPos, endPos, thickness, parentModel, color)
        local beam = Instance.new("Part")
        beam.Shape = Enum.PartType.Block
        
        local distance = (endPos - startPos).Magnitude
        beam.Size = Vector3.new(thickness, thickness, distance)
        
        local midPoint = (startPos + endPos) / 2
        beam.CFrame = CFrame.new(midPoint, endPos)
        
        applyStudsStyle(beam, color)
        beam.Parent = parentModel
        
        return beam
    end
    
    local function createLadder(basePos, height, parentModel)
        local ladderSpacing = 1.5
        local ladderWidth = 2
        local railThickness = 0.4
        local stepThickness = 0.3
        local actualHeight = height + 8
        
        local rail1Start = Vector3.new(basePos.X - ladderWidth/2, basePos.Y, basePos.Z - 3)
        local rail1End = Vector3.new(basePos.X - ladderWidth/2, basePos.Y + actualHeight, basePos.Z - 3)
        createBeam(rail1Start, rail1End, railThickness, parentModel, Color3.fromRGB(150, 150, 160))
        
        local rail2Start = Vector3.new(basePos.X + ladderWidth/2, basePos.Y, basePos.Z - 3)
        local rail2End = Vector3.new(basePos.X + ladderWidth/2, basePos.Y + actualHeight, basePos.Z - 3)
        createBeam(rail2Start, rail2End, railThickness, parentModel, Color3.fromRGB(150, 150, 160))
        
        local numSteps = math.floor(actualHeight / ladderSpacing)
        for i = 0, numSteps do
            local stepY = basePos.Y + (i * ladderSpacing)
            
            local step = Instance.new("Part")
            step.Shape = Enum.PartType.Block
            step.Size = Vector3.new(ladderWidth, stepThickness, stepThickness)
            step.CFrame = CFrame.new(basePos.X, stepY, basePos.Z - 3)
            applyStudsStyle(step, Color3.fromRGB(150, 150, 160))
            step.Parent = parentModel
        end
    end
    
    local function createTopPlatform(centerPos, topY, parentModel)
        local platformColor = Color3.fromRGB(120, 80, 50)
        local halfSize = PLATFORM_SIZE / 2
        local holeHalf = PLATFORM_HOLE_SIZE / 2
        
        local northPlatform = Instance.new("Part")
        northPlatform.Name = "PlatformNorth"
        northPlatform.Shape = Enum.PartType.Block
        northPlatform.Size = Vector3.new(PLATFORM_SIZE, PLATFORM_HEIGHT, halfSize - holeHalf)
        northPlatform.CFrame = CFrame.new(centerPos.X, topY, centerPos.Z + halfSize/2 + holeHalf/2)
        applyStudsStyle(northPlatform, platformColor)
        northPlatform.Parent = parentModel
        
        local southPlatform = Instance.new("Part")
        southPlatform.Name = "PlatformSouth"
        southPlatform.Shape = Enum.PartType.Block
        southPlatform.Size = Vector3.new(PLATFORM_SIZE, PLATFORM_HEIGHT, halfSize - holeHalf)
        southPlatform.CFrame = CFrame.new(centerPos.X, topY, centerPos.Z - halfSize/2 - holeHalf/2)
        applyStudsStyle(southPlatform, platformColor)
        southPlatform.Parent = parentModel
        
        local eastPlatform = Instance.new("Part")
        eastPlatform.Name = "PlatformEast"
        eastPlatform.Shape = Enum.PartType.Block
        eastPlatform.Size = Vector3.new(halfSize - holeHalf, PLATFORM_HEIGHT, PLATFORM_HOLE_SIZE)
        eastPlatform.CFrame = CFrame.new(centerPos.X + halfSize/2 + holeHalf/2, topY, centerPos.Z)
        applyStudsStyle(eastPlatform, platformColor)
        eastPlatform.Parent = parentModel
        
        local westPlatform = Instance.new("Part")
        westPlatform.Name = "PlatformWest"
        westPlatform.Shape = Enum.PartType.Block
        westPlatform.Size = Vector3.new(halfSize - holeHalf, PLATFORM_HEIGHT, PLATFORM_HOLE_SIZE)
        westPlatform.CFrame = CFrame.new(centerPos.X - halfSize/2 - holeHalf/2, topY, centerPos.Z)
        applyStudsStyle(westPlatform, platformColor)
        westPlatform.Parent = parentModel
        
        local railHeight = 3.5
        local railThickness = 0.5
        local railOffset = PLATFORM_SIZE/2 - 0.3
        
        local northRail = Instance.new("Part")
        northRail.Shape = Enum.PartType.Block
        northRail.Size = Vector3.new(PLATFORM_SIZE - 2, railHeight, railThickness)
        northRail.CFrame = CFrame.new(centerPos.X, topY + railHeight/2 + PLATFORM_HEIGHT/2, centerPos.Z + railOffset)
        applyStudsStyle(northRail, Color3.fromRGB(180, 180, 190))
        northRail.Parent = parentModel
        
        local southRail = Instance.new("Part")
        southRail.Shape = Enum.PartType.Block
        southRail.Size = Vector3.new(PLATFORM_SIZE - 2, railHeight, railThickness)
        southRail.CFrame = CFrame.new(centerPos.X, topY + railHeight/2 + PLATFORM_HEIGHT/2, centerPos.Z - railOffset)
        applyStudsStyle(southRail, Color3.fromRGB(180, 180, 190))
        southRail.Parent = parentModel
        
        local eastRail = Instance.new("Part")
        eastRail.Shape = Enum.PartType.Block
        eastRail.Size = Vector3.new(railThickness, railHeight, PLATFORM_SIZE - 2)
        eastRail.CFrame = CFrame.new(centerPos.X + railOffset, topY + railHeight/2 + PLATFORM_HEIGHT/2, centerPos.Z)
        applyStudsStyle(eastRail, Color3.fromRGB(180, 180, 190))
        eastRail.Parent = parentModel
        
        local westRail = Instance.new("Part")
        westRail.Shape = Enum.PartType.Block
        westRail.Size = Vector3.new(railThickness, railHeight, PLATFORM_SIZE - 2)
        westRail.CFrame = CFrame.new(centerPos.X - railOffset, topY + railHeight/2 + PLATFORM_HEIGHT/2, centerPos.Z)
        applyStudsStyle(westRail, Color3.fromRGB(180, 180, 190))
        westRail.Parent = parentModel
        
        local postHeight = railHeight + PLATFORM_HEIGHT/2
        local postSize = 0.8
        local cornerOffset = railOffset - 0.3
        
        local cornerPositions = {
        Vector3.new(centerPos.X + cornerOffset, topY + postHeight/2, centerPos.Z + cornerOffset),
        Vector3.new(centerPos.X + cornerOffset, topY + postHeight/2, centerPos.Z - cornerOffset),
        Vector3.new(centerPos.X - cornerOffset, topY + postHeight/2, centerPos.Z + cornerOffset),
        Vector3.new(centerPos.X - cornerOffset, topY + postHeight/2, centerPos.Z - cornerOffset)
        }
        
        for _, pos in ipairs(cornerPositions) do
            local post = Instance.new("Part")
            post.Shape = Enum.PartType.Block
            post.Size = Vector3.new(postSize, postHeight, postSize)
            post.CFrame = CFrame.new(pos)
            applyStudsStyle(post, Color3.fromRGB(160, 160, 170))
            post.Parent = parentModel
        end
        
        return northPlatform
    end
    
    -- ===================== FARO MEJORADO (SIRENAS REALISTAS) =====================
    local function createTsunamiLighthouse(centerPos, topY, parentModel, towerData)
        local lighthouseX = centerPos.X + 15
        local lighthouseZ = centerPos.Z
        local lighthouseBaseY = topY + PLATFORM_HEIGHT/2
        
        local lighthouseModel = Instance.new("Model")
        lighthouseModel.Name = "TsunamiLighthouse"
        lighthouseModel.Parent = parentModel
        
        -- ===== POSTE CENTRAL (NO GIRA) =====
        local poleHeight = 15
        local pole = Instance.new("Part")
        pole.Name = "CentralPole"
        pole.Shape = Enum.PartType.Cylinder
        pole.Size = Vector3.new(poleHeight, 1.5, 1.5)
        pole.CFrame = CFrame.new(lighthouseX, lighthouseBaseY + poleHeight/2, lighthouseZ) * CFrame.Angles(0, 0, math.rad(90))
        pole.Material = Enum.Material.Metal
        pole.Color = Color3.fromRGB(70, 70, 80)
        pole.Anchored = true
        pole.CanCollide = false
        pole.TopSurface = Enum.SurfaceType.Studs
        pole.Parent = lighthouseModel
        
        local headY = lighthouseBaseY + poleHeight
        
        -- ===== PLATAFORMA CENTRAL (NO GIRA) =====
        local centralPlatform = Instance.new("Part")
        centralPlatform.Name = "CentralPlatform"
        centralPlatform.Shape = Enum.PartType.Cylinder
        centralPlatform.Size = Vector3.new(2, 6, 6)
        centralPlatform.CFrame = CFrame.new(lighthouseX, headY, lighthouseZ) * CFrame.Angles(0, 0, math.rad(90))
        centralPlatform.Material = Enum.Material.Metal
        centralPlatform.Color = Color3.fromRGB(200, 0, 0)
        centralPlatform.Anchored = true
        centralPlatform.CanCollide = false
        centralPlatform.TopSurface = Enum.SurfaceType.Studs
        centralPlatform.Parent = lighthouseModel
        
        -- ===== 4 SIRENAS GIRATORIAS (MEJORADAS) =====
        local sirenAngles = {0, 90, 180, 270}
        local sirens = {}
        local sirenModel = Instance.new("Model")
        sirenModel.Name = "RotatingSirens"
        sirenModel.Parent = lighthouseModel
        
        for i, angle in ipairs(sirenAngles) do
            local rad = math.rad(angle)
            local distance = 4.5
            
            -- Brazo de soporte
            local arm = Instance.new("Part")
            arm.Name = "SirenArm" .. i
            arm.Shape = Enum.PartType.Block
            arm.Size = Vector3.new(0.8, 0.8, 3)
            arm.CFrame = CFrame.new(
            lighthouseX + math.cos(rad) * (distance/2 + 1),
            headY,
            lighthouseZ + math.sin(rad) * (distance/2 + 1)
            ) * CFrame.Angles(0, rad, 0)
            arm.Material = Enum.Material.Metal
            arm.Color = Color3.fromRGB(100, 0, 0)
            arm.Anchored = false
            arm.CanCollide = false
            arm.TopSurface = Enum.SurfaceType.Studs
            arm.Parent = sirenModel
            
            -- Cuerpo de la sirena (base)
            local sirenBody = Instance.new("Part")
            sirenBody.Name = "SirenBody" .. i
            sirenBody.Shape = Enum.PartType.Cylinder
            sirenBody.Size = Vector3.new(2, 2.5, 2.5)
            sirenBody.CFrame = CFrame.new(
            lighthouseX + math.cos(rad) * distance,
            headY,
            lighthouseZ + math.sin(rad) * distance
            ) * CFrame.Angles(0, rad + math.rad(90), 0)
            sirenBody.Material = Enum.Material.Metal
            sirenBody.Color = Color3.fromRGB(180, 0, 0)
            sirenBody.Anchored = false
            sirenBody.CanCollide = false
            sirenBody.TopSurface = Enum.SurfaceType.Studs
            sirenBody.Parent = sirenModel
            
            -- Bocina (trompeta amarilla)
            local horn = Instance.new("Part")
            horn.Name = "SirenHorn" .. i
            horn.Shape = Enum.PartType.Cylinder
            horn.Size = Vector3.new(2.5, 3.5, 3.5)
            horn.CFrame = CFrame.new(
            lighthouseX + math.cos(rad) * (distance + 1.8),
            headY,
            lighthouseZ + math.sin(rad) * (distance + 1.8)
            ) * CFrame.Angles(0, rad + math.rad(90), 0)
            horn.Material = Enum.Material.Metal
            horn.Color = Color3.fromRGB(230, 180, 50)
            horn.Anchored = false
            horn.CanCollide = false
            horn.TopSurface = Enum.SurfaceType.Studs
            horn.Parent = sirenModel
            
            -- Mesh cónico para la bocina
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://1082802"
            mesh.Scale = Vector3.new(3.5, 2.5, 3.5)
            mesh.Parent = horn
            
            -- Spotlight
            local spotlight = Instance.new("SpotLight")
            spotlight.Name = "AlarmLight"
            spotlight.Color = LIGHTHOUSE_COLOR
            spotlight.Brightness = 0
            spotlight.Range = 0
            spotlight.Angle = 50
            spotlight.Face = Enum.NormalId.Right
            spotlight.Enabled = false
            spotlight.Parent = horn
            
            -- Guardar partes
            table.insert(sirens, {
            arm = arm,
            body = sirenBody,
            horn = horn,
            light = spotlight,
            angle = angle,
            distance = distance
            })
            
            -- Soldar brazo a cuerpo
            local weld1 = Instance.new("WeldConstraint")
            weld1.Part0 = arm
            weld1.Part1 = sirenBody
            weld1.Parent = sirenBody
            
            -- Soldar cuerpo a bocina
            local weld2 = Instance.new("WeldConstraint")
            weld2.Part0 = sirenBody
            weld2.Part1 = horn
            weld2.Parent = horn
        end
        
        -- Anclar la primera parte para que todo gire junto
        sirens[1].arm.Anchored = true
        
        -- Soldar todas las sirenas entre sí
        for i = 2, #sirens do
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = sirens[1].arm
            weld.Part1 = sirens[i].arm
            weld.Parent = sirens[i].arm
        end
        
        -- ===== LUZ CENTRAL =====
        local centralLight = Instance.new("PointLight")
        centralLight.Name = "CentralLight"
        centralLight.Color = LIGHTHOUSE_COLOR
        centralLight.Brightness = 0
        centralLight.Range = 0
        centralLight.Enabled = false
        centralLight.Parent = centralPlatform
        
        -- ===== PROXIMITY PROMPT =====
        local proximityPrompt = Instance.new("ProximityPrompt")
        proximityPrompt.ActionText = "ACTIVAR ALARMA DE TSUNAMI"
        proximityPrompt.ObjectText = "🚨 Sistema de Alerta 🚨"
        proximityPrompt.HoldDuration = 2
        proximityPrompt.MaxActivationDistance = 20
        proximityPrompt.RequiresLineOfSight = false
        proximityPrompt.Enabled = true
        proximityPrompt.Parent = centralPlatform
        
        local lighthouseData = {
        model = lighthouseModel,
        pole = pole,
        platform = centralPlatform,
        sirens = sirens,
        sirenModel = sirenModel,
        centralLight = centralLight,
        position = Vector3.new(lighthouseX, headY, lighthouseZ),
        towerData = towerData
        }
        
        table.insert(ALL_LIGHTHOUSES, lighthouseData)
        
        proximityPrompt.Triggered:Connect(function(player)
            print("🚨 ALARMA ACTIVADA POR: " .. player.Name)
            
            local success, isFirstTime = pcall(function()
                return AlarmDataStore:GetAsync(player.UserId .. "_FirstActivation")
            end)
            
            if not success or not isFirstTime then
                pcall(function()
                    AlarmDataStore:SetAsync(player.UserId .. "_FirstActivation", true)
                end)
                
                print("🎬 INICIANDO CINEMÁTICA ÉPICA PARA: " .. player.Name)
                CinematicEvent:FireClient(player, "StartCinematic", lighthouseData)
            end
            
            activateAllLighthouses(lighthouseData)
        end)
        
        return lighthouseData
    end
    
    -- ===================== ACTIVACIÓN =====================
    function activateAllLighthouses(triggeringLighthouse)
        print("🚨🚨🚨 ¡ACTIVANDO TODAS LAS ALARMAS! 🚨🚨🚨")
        
        for _, lighthouse in ipairs(ALL_LIGHTHOUSES) do
            task.spawn(function()
                activateSingleLighthouse(lighthouse)
            end)
        end
    end
    
    function activateSingleLighthouse(lighthouseData)
        local platform = lighthouseData.platform
        local sirens = lighthouseData.sirens
        local sirenModel = lighthouseData.sirenModel
        local centralLight = lighthouseData.centralLight
        local position = lighthouseData.position
        
        -- ===== SONIDO =====
        local alarmSound = Instance.new("Sound")
        alarmSound.SoundId = ALARM_SOUND_ID
        alarmSound.Volume = 1
        alarmSound.Looped = true
        alarmSound.RollOffMaxDistance = 20000
        alarmSound.RollOffMinDistance = 1000
        alarmSound.Parent = platform
        alarmSound:Play()
        
        -- ===== ROTACIÓN DE SIRENAS (SOLO ELLAS) =====
        local rotationSpeed = 2
        local isRotating = true
        
        task.spawn(function()
            local centerX = lighthouseData.position.X
            local centerY = lighthouseData.position.Y
            local centerZ = lighthouseData.position.Z
            
            while isRotating do
                for i, siren in ipairs(sirens) do
                    if siren.arm.Parent then
                        local newAngle = math.rad(siren.angle + (tick() * 50))
                        local distance = siren.distance
                        
                        -- Nueva posición
                        local newX = centerX + math.cos(newAngle) * distance
                        local newZ = centerZ + math.sin(newAngle) * distance
                        
                        -- Actualizar transformaciones
                        siren.arm.CFrame = CFrame.new(
                        centerX + math.cos(newAngle) * (distance/2 + 1),
                        centerY,
                        centerZ + math.sin(newAngle) * (distance/2 + 1)
                        ) * CFrame.Angles(0, newAngle, 0)
                    end
                end
                task.wait(0.03)
            end
        end)
        
        -- ===== PARPADEO =====
        local isFlashing = true
        
        task.spawn(function()
            while isFlashing do
                -- Encender
                for _, siren in ipairs(sirens) do
                    siren.light.Enabled = true
                    siren.light.Brightness = 150
                    siren.light.Range = 2000
                end
                
                centralLight.Enabled = true
                centralLight.Brightness = 200
                centralLight.Range = 2500
                
                task.wait(0.8)
                
                -- Apagar
                for _, siren in ipairs(sirens) do
                    siren.light.Enabled = false
                    siren.light.Brightness = 0
                    siren.light.Range = 0
                end
                
                centralLight.Enabled = false
                centralLight.Brightness = 0
                centralLight.Range = 0
                
                task.wait(0.3)
            end
        end)
        
        -- ===== EFECTOS VISUALES =====
        task.spawn(function()
            for i = 1, 60 do
                task.wait(i * 0.5)
                
                local beam = Instance.new("Part")
                beam.Shape = Enum.PartType.Cylinder
                beam.Size = Vector3.new(8000, 100, 100)
                beam.CFrame = CFrame.new(position.X, position.Y + 4000, position.Z) * CFrame.Angles(0, 0, math.rad(90))
                beam.Material = Enum.Material.Neon
                beam.Color = LIGHTHOUSE_COLOR
                beam.Anchored = true
                beam.CanCollide = false
                beam.Transparency = 0.2
                beam.Parent = Workspace
                
                local beamLight = Instance.new("PointLight")
                beamLight.Color = LIGHTHOUSE_COLOR
                beamLight.Brightness = 80
                beamLight.Range = 1500
                beamLight.Parent = beam
                
                task.wait(1.5)
                
                local fadeInfo = TweenInfo.new(1.5)
                TweenService:Create(beam, fadeInfo, {Transparency = 1}):Play()
                TweenService:Create(beamLight, fadeInfo, {Brightness = 0}):Play()
                
                Debris:AddItem(beam, 2)
            end
        end)
        
        task.spawn(function()
            for i = 1, 50 do
                task.wait(i * 0.4)
                
                local shockwave = Instance.new("Part")
                shockwave.Shape = Enum.PartType.Cylinder
                shockwave.Size = Vector3.new(1, 150, 150)
                shockwave.CFrame = CFrame.new(position.X, position.Y - 100, position.Z) * CFrame.Angles(0, 0, math.rad(90))
                shockwave.Material = Enum.Material.Neon
                shockwave.Color = LIGHTHOUSE_COLOR
                shockwave.Anchored = true
                shockwave.CanCollide = false
                shockwave.Transparency = 0.3
                shockwave.Parent = Workspace
                
                local shockLight = Instance.new("PointLight")
                shockLight.Color = LIGHTHOUSE_COLOR
                shockLight.Brightness = 50
                shockLight.Range = 1000
                shockLight.Parent = shockwave
                
                local expandInfo = TweenInfo.new(4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
                TweenService:Create(shockwave, expandInfo, {
                Size = Vector3.new(1, 12000, 12000),
                Transparency = 1
                }):Play()
                
                TweenService:Create(shockLight, expandInfo, {Brightness = 0, Range = 3000}):Play()
                
                Debris:AddItem(shockwave, 4.5)
            end
        end)
        
        task.spawn(function()
            for i = 1, 100 do
                task.wait(i * 0.25)
                
                local orb = Instance.new("Part")
                orb.Shape = Enum.PartType.Ball
                orb.Size = Vector3.new(200, 200, 200)
                orb.CFrame = CFrame.new(
                position.X + math.random(-3000, 3000),
                position.Y + math.random(500, 2500),
                position.Z + math.random(-3000, 3000)
                )
                orb.Material = Enum.Material.Neon
                orb.Color = Color3.fromRGB(255, math.random(0, 50), 0)
                orb.Anchored = true
                orb.CanCollide = false
                orb.Transparency = 0.2
                orb.Parent = Workspace
                
                local orbLight = Instance.new("PointLight")
                orbLight.Color = LIGHTHOUSE_COLOR
                orbLight.Brightness = 80
                orbLight.Range = 2000
                orbLight.Parent = orb
                
                for flash = 1, 6 do
                    task.wait(0.12)
                    orb.Transparency = 0
                    orbLight.Brightness = 100
                    task.wait(0.12)
                    orb.Transparency = 0.6
                    orbLight.Brightness = 30
                end
                
                local fadeInfo = TweenInfo.new(1.5)
                TweenService:Create(orb, fadeInfo, {Transparency = 1, Size = Vector3.new(50, 50, 50)}):Play()
                TweenService:Create(orbLight, fadeInfo, {Brightness = 0}):Play()
                
                Debris:AddItem(orb, 2)
            end
        end)
        
        -- ===== DURACIÓN =====
        task.wait(ALARM_DURATION)
        
        isRotating = false
        isFlashing = false
        
        for _, siren in ipairs(sirens) do
            siren.light.Enabled = false
            siren.light.Brightness = 0
            siren.light.Range = 0
        end
        
        centralLight.Enabled = false
        centralLight.Brightness = 0
        centralLight.Range = 0
        
        if alarmSound.Parent then
            alarmSound:Stop()
            Debris:AddItem(alarmSound, 1)
        end
        
        print("✅ Alarma finalizada")
    end
    
    -- ===================== CREACIÓN DE TORRE =====================
    local function createTransmissionTower(position, modelParent)
        local towerModel = Instance.new("Model")
        towerModel.Name = "TransmissionTower"
        towerModel.Parent = modelParent
        
        local groundPos = raycastGroundAt(position.X, position.Z)
        local baseY = groundPos.Y
        
        local sectionHeight = TOWER_HEIGHT / NUM_SECTIONS
        
        for section = 1, NUM_SECTIONS do
            local y1 = (section - 1) * sectionHeight
            local y2 = section * sectionHeight
            
            local width1 = BASE_WIDTH - (BASE_WIDTH - TOP_WIDTH) * (y1 / TOWER_HEIGHT)
            local width2 = BASE_WIDTH - (BASE_WIDTH - TOP_WIDTH) * (y2 / TOWER_HEIGHT)
            
            local offset1 = width1 / 2
            local offset2 = width2 / 2
            
            local corners1 = {
            Vector3.new(groundPos.X - offset1, baseY + y1, groundPos.Z - offset1),
            Vector3.new(groundPos.X + offset1, baseY + y1, groundPos.Z - offset1),
            Vector3.new(groundPos.X - offset1, baseY + y1, groundPos.Z + offset1),
            Vector3.new(groundPos.X + offset1, baseY + y1, groundPos.Z + offset1)
            }
            
            local corners2 = {
            Vector3.new(groundPos.X - offset2, baseY + y2, groundPos.Z - offset2),
            Vector3.new(groundPos.X + offset2, baseY + y2, groundPos.Z - offset2),
            Vector3.new(groundPos.X - offset2, baseY + y2, groundPos.Z + offset2),
            Vector3.new(groundPos.X + offset2, baseY + y2, groundPos.Z + offset2)
            }
            
            for i = 1, 4 do
                createBeam(corners1[i], corners2[i], LEG_THICKNESS, towerModel)
            end
            
            createBeam(corners2[1], corners2[2], CROSSBAR_THICKNESS, towerModel)
            createBeam(corners2[2], corners2[4], CROSSBAR_THICKNESS, towerModel)
            createBeam(corners2[4], corners2[3], CROSSBAR_THICKNESS, towerModel)
            createBeam(corners2[3], corners2[1], CROSSBAR_THICKNESS, towerModel)
        end
        
        createLadder(Vector3.new(groundPos.X, baseY, groundPos.Z), TOWER_HEIGHT, towerModel)
        
        local topY = baseY + TOWER_HEIGHT
        local armHeight1 = topY - 25
        local armHeight2 = topY - 55
        local armHeight3 = topY - 85
        local armLength = 45
        local cablePoints = {}
        
        local function getTowerWidthAtHeight(heightAboveBase)
            return BASE_WIDTH - (BASE_WIDTH - TOP_WIDTH) * (heightAboveBase / TOWER_HEIGHT)
        end
        
        local function createArm(centerX, centerZ, y, direction, armIndex)
            local heightAboveBase = y - baseY
            local towerWidthAtHeight = getTowerWidthAtHeight(heightAboveBase)
            local towerEdge = towerWidthAtHeight / 2
            
            local armStartX = centerX + (direction * towerEdge)
            local armStart = Vector3.new(armStartX, y, centerZ)
            local armEnd = Vector3.new(armStartX + direction * armLength, y, centerZ)
            
            local anchorBase = Instance.new("Part")
            anchorBase.Shape = Enum.PartType.Block
            anchorBase.Size = Vector3.new(3, 2, 3)
            anchorBase.CFrame = CFrame.new(armStartX, y - 1, centerZ)
            applyStudsStyle(anchorBase, Color3.fromRGB(100, 70, 50))
            anchorBase.Parent = towerModel
            
            createBeam(armStart, armEnd, CROSSBAR_THICKNESS * 1.2, towerModel)
            
            local supportStartX = centerX + (direction * towerEdge)
            local supportStart1 = Vector3.new(supportStartX, y - 12, centerZ)
            createBeam(supportStart1, armEnd, CROSSBAR_THICKNESS * 0.8, towerModel)
            
            local supportStart2 = Vector3.new(supportStartX, y - 6, centerZ)
            local supportMid = Vector3.new(armStartX + direction * (armLength * 0.5), y, centerZ)
            createBeam(supportStart2, supportMid, CROSSBAR_THICKNESS * 0.7, towerModel)
            
            for i = 1, 2 do
                local vertPos = armLength * (0.4 + i * 0.25)
                local vertBottom = Vector3.new(armStartX + direction * vertPos, y - 10, centerZ)
                local vertTop = Vector3.new(armStartX + direction * vertPos, y, centerZ)
                createBeam(vertBottom, vertTop, CROSSBAR_THICKNESS * 0.6, towerModel)
            end
            
            local insulatorY = y - 3
            local insulator = Instance.new("Part")
            insulator.Shape = Enum.PartType.Cylinder
            insulator.Size = Vector3.new(3, 2.5, 2.5)
            insulator.CFrame = CFrame.new(armStartX + direction * armLength, insulatorY, centerZ) * CFrame.Angles(0, 0, math.rad(90))
            applyStudsStyle(insulator, INSULATOR_COLOR)
            insulator.Parent = towerModel
            
            local chain = Instance.new("Part")
            chain.Shape = Enum.PartType.Cylinder
            chain.Size = Vector3.new(2, 0.3, 0.3)
            chain.CFrame = CFrame.new(armStartX + direction * armLength, y - 1.5, centerZ) * CFrame.Angles(0, 0, math.rad(90))
            chain.Material = Enum.Material.Metal
            chain.Color = Color3.fromRGB(80, 80, 90)
            chain.Anchored = true
            chain.CanCollide = false
            chain.Parent = towerModel
            
            local cablePoint = Vector3.new(armStartX + direction * armLength, insulatorY - 3, centerZ)
            table.insert(cablePoints, cablePoint)
        end
        
        createArm(groundPos.X, groundPos.Z, armHeight1, -1, 1)
        createArm(groundPos.X, groundPos.Z, armHeight1, 1, 2)
        createArm(groundPos.X, groundPos.Z, armHeight2, -1, 3)
        createArm(groundPos.X, groundPos.Z, armHeight2, 1, 4)
        createArm(groundPos.X, groundPos.Z, armHeight3, -1, 5)
        createArm(groundPos.X, groundPos.Z, armHeight3, 1, 6)
        
        local platformY = topY + 5
        createTopPlatform(groundPos, platformY, towerModel)
        
        -- SIN palo ni luz roja arriba
        
        local towerData = {
        position = groundPos,
        cablePoints = cablePoints,
        model = towerModel,
        topY = platformY
        }
        
        createTsunamiLighthouse(groundPos, platformY, towerModel, towerData)
        
        return towerData
    end
    
    -- ===================== CABLES =====================
    local function createPowerCable(point1, point2, parentModel)
        local distance = (point2 - point1).Magnitude
        local midPoint = (point1 + point2) / 2
        local sagAmount = distance * 0.05
        local sagPoint = Vector3.new(midPoint.X, midPoint.Y - sagAmount, midPoint.Z)
        
        local cable1 = Instance.new("Part")
        cable1.Shape = Enum.PartType.Cylinder
        local dist1 = (sagPoint - point1).Magnitude
        cable1.Size = Vector3.new(dist1, CABLE_THICKNESS, CABLE_THICKNESS)
        cable1.CFrame = CFrame.new((point1 + sagPoint) / 2, sagPoint)
        cable1.CFrame = cable1.CFrame * CFrame.Angles(0, math.rad(90), 0)
        cable1.Material = TOWER_MATERIAL
        cable1.Color = CABLE_COLOR
        cable1.Anchored = true
        cable1.CanCollide = false
        cable1.Parent = parentModel
        
        local cable2 = Instance.new("Part")
        cable2.Shape = Enum.PartType.Cylinder
        local dist2 = (point2 - sagPoint).Magnitude
        cable2.Size = Vector3.new(dist2, CABLE_THICKNESS, CABLE_THICKNESS)
        cable2.CFrame = CFrame.new((sagPoint + point2) / 2, point2)
        cable2.CFrame = cable2.CFrame * CFrame.Angles(0, math.rad(90), 0)
        cable2.Material = TOWER_MATERIAL
        cable2.Color = CABLE_COLOR
        cable2.Anchored = true
        cable2.CanCollide = false
        cable2.Parent = parentModel
    end
    
    -- ===================== GENERACIÓN =====================
    local function generateTowers()
        local existing = Workspace:FindFirstChild(TOWERS_MODEL_NAME)
        if existing then
            existing:Destroy()
            task.wait()
        end
        
        ALL_LIGHTHOUSES = {}
        
        local model = Instance.new("Model")
        model.Name = TOWERS_MODEL_NAME
        model.Parent = Workspace
        
        local center, size = obtenerAreaMapa()
        
        local areaX = math.min(size.X * 0.8, 1500)
        local areaZ = math.min(size.Z * 0.8, 1500)
        
        local minX = center.X - areaX / 2
        local maxX = center.X + areaX / 2
        local minZ = center.Z - areaZ / 2
        local maxZ = center.Z + areaZ / 2
        
        local towersCreated = 0
        local towerDataList = {}
        
        for x = minX, maxX, TOWER_SPACING do
            for z = minZ, maxZ, TOWER_SPACING do
                if towersCreated >= MAX_TOWERS then break end
                
                if math.random() <= TOWER_SPAWN_PROBABILITY then
                    local spawnX = x + randFloat(-TOWER_SPACING/4, TOWER_SPACING/4)
                    local spawnZ = z + randFloat(-TOWER_SPACING/4, TOWER_SPACING/4)
                    
                    if spawnX >= minX and spawnX <= maxX and spawnZ >= minZ and spawnZ <= maxZ then
                        local spawnPos = Vector3.new(spawnX, 0, spawnZ)
                        
                        local towerData = createTransmissionTower(spawnPos, model)
                        table.insert(towerDataList, towerData)
                        towersCreated = towersCreated + 1
                    end
                end
            end
            if towersCreated >= MAX_TOWERS then break end
        end
        
        print("🗼 Torres: " .. towersCreated)
        print("🚨 Faros: " .. #ALL_LIGHTHOUSES)
        
        local cablesCreated = 0
        local maxConnectionDistance = TOWER_SPACING * 1.5
        
        for i = 1, #towerDataList do
            local tower1 = towerDataList[i]
            
            for j = i + 1, #towerDataList do
                local tower2 = towerDataList[j]
                local distance = (tower2.position - tower1.position).Magnitude
                
                if distance <= maxConnectionDistance then
                    for k = 1, math.min(#tower1.cablePoints, #tower2.cablePoints) do
                        createPowerCable(tower1.cablePoints[k], tower2.cablePoints[k], model)
                        cablesCreated = cablesCreated + 1
                    end
                end
            end
        end
        
        print("⚡ Cables: " .. cablesCreated)
        print("✅ Sistema completo!")
    end
    
    generateTowers()
    
   

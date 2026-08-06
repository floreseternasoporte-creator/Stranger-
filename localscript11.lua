-- UPSIDE DOWN FILTER - STRANGER THINGS
-- LocalScript en StarterPlayer > StarterPlayerScripts

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("🌀 Upside Down Filter - Iniciando...")

-- CREAR EFECTOS DE LIGHTING
local function setupLighting()
    -- SKYBOX ROJO OSCURO
    local sky = Instance.new("Sky")
    sky.Name = "UpsideDownSky"
    sky.SkyboxBk = "rbxassetid://570557620"
    sky.SkyboxDn = "rbxassetid://570557620"
    sky.SkyboxFt = "rbxassetid://570557620"
    sky.SkyboxLf = "rbxassetid://570557620"
    sky.SkyboxRt = "rbxassetid://570557620"
    sky.SkyboxUp = "rbxassetid://570557620"
    sky.StarCount = 0
    sky.SunAngularSize = 0
    sky.MoonAngularSize = 0
    sky.Parent = Lighting
    
    -- Color Correction (tono rojo SUAVE)
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Name = "UpsideDownColor"
    colorCorrection.Brightness = 0.2
    colorCorrection.Contrast = 0.1
    colorCorrection.Saturation = -0.1
    colorCorrection.TintColor = Color3.fromRGB(255, 200, 200)
    colorCorrection.Parent = Lighting
    
    -- Bloom (resplandor)
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "UpsideDownBloom"
    bloom.Intensity = 1
    bloom.Size = 30
    bloom.Threshold = 0.7
    bloom.Parent = Lighting
    
    -- Atmosphere (niebla roja LIGERA)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "UpsideDownAtmosphere"
    atmosphere.Density = 0.2
    atmosphere.Offset = 0.1
    atmosphere.Color = Color3.fromRGB(255, 180, 180)
    atmosphere.Glare = 0.4
    atmosphere.Haze = 1
    atmosphere.Parent = Lighting
    
    -- SunRays (rayos rojos)
    local sunRays = Instance.new("SunRaysEffect")
    sunRays.Name = "UpsideDownRays"
    sunRays.Intensity = 0.25
    sunRays.Spread = 1
    sunRays.Parent = Lighting
    
    -- Ajustar iluminación global (MUY BRILLANTE)
    Lighting.Ambient = Color3.fromRGB(255, 200, 200)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 200, 200)
    Lighting.Brightness = 5
    Lighting.ClockTime = 14
    Lighting.FogColor = Color3.fromRGB(200, 120, 120)
    Lighting.FogEnd = 2000
    Lighting.FogStart = 500
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1
    
    print("✅ Lighting configurado")
end

-- CREAR GUI DE ESPORAS Y EFECTOS
local function createUpsideDownGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UpsideDownFilter"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 1
    screenGui.Parent = playerGui
    
    -- CONTENEDOR DE ESPORAS (SIN VIGNETTE NI OVERLAY OSCURO)
    local sporesContainer = Instance.new("Frame")
    sporesContainer.Name = "SporesContainer"
    sporesContainer.Size = UDim2.new(1, 0, 1, 0)
    sporesContainer.BackgroundTransparency = 1
    sporesContainer.ClipsDescendants = false
    sporesContainer.ZIndex = 3
    sporesContainer.Parent = screenGui
    
    -- CREAR ESPORAS FLOTANTES (80 esporas)
    for i = 1, 80 do
        local spore = Instance.new("ImageLabel")
        spore.Name = "Spore" .. i
        
        -- Tamaño aleatorio
        local size = math.random(8, 25)
        spore.Size = UDim2.new(0, size, 0, size)
        
        -- Posición aleatoria
        spore.Position = UDim2.new(
        math.random(0, 100) / 100,
        math.random(-50, 50),
        math.random(0, 100) / 100,
        math.random(-50, 50)
        )
        
        spore.BackgroundTransparency = 1
        spore.Image = "rbxassetid://6073894699" -- Partícula circular
        spore.ImageColor3 = Color3.fromRGB(
        math.random(200, 255),
        math.random(180, 220),
        math.random(150, 200)
        )
        spore.ImageTransparency = math.random(30, 70) / 100
        spore.ZIndex = 3 + math.random(1, 5)
        spore.Parent = sporesContainer
        
        -- Rotación aleatoria
        spore.Rotation = math.random(0, 360)
        
        -- ANIMACIÓN FLOTANTE
        task.spawn(function()
            local duration = math.random(8, 15)
            local delay = math.random(0, 30) / 10
            
            task.wait(delay)
            
            while spore and spore.Parent do
                -- Movimiento flotante
                local targetX = math.random(0, 100) / 100
                local targetY = math.random(0, 100) / 100
                
                local tweenInfo = TweenInfo.new(
                duration,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
                )
                
                local tween = TweenService:Create(spore, tweenInfo, {
                Position = UDim2.new(
                targetX,
                math.random(-50, 50),
                targetY,
                math.random(-50, 50)
                ),
                Rotation = spore.Rotation + math.random(-180, 180),
                ImageTransparency = math.random(30, 80) / 100
                })
                
                tween:Play()
                tween.Completed:Wait()
                
                task.wait(0.5)
            end
        end)
    end
    
    -- PARTÍCULAS GRANDES (ceniza)
    for i = 1, 30 do
        local ash = Instance.new("Frame")
        ash.Name = "Ash" .. i
        
        local size = math.random(2, 6)
        ash.Size = UDim2.new(0, size, 0, size)
        ash.Position = UDim2.new(
        math.random(0, 100) / 100,
        0,
        math.random(-20, 120) / 100,
        0
        )
        ash.BackgroundColor3 = Color3.fromRGB(
        math.random(150, 200),
        math.random(140, 180),
        math.random(130, 170)
        )
        ash.BackgroundTransparency = math.random(40, 80) / 100
        ash.BorderSizePixel = 0
        ash.ZIndex = 4
        ash.Parent = sporesContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ash
        
        -- CAÍDA LENTA
        task.spawn(function()
            while ash and ash.Parent do
                local duration = math.random(15, 25)
                
                local tweenInfo = TweenInfo.new(
                duration,
                Enum.EasingStyle.Linear
                )
                
                local tween = TweenService:Create(ash, tweenInfo, {
                Position = UDim2.new(
                ash.Position.X.Scale + math.random(-10, 10) / 100,
                0,
                1.2,
                0
                )
                })
                
                tween:Play()
                tween.Completed:Wait()
                
                -- Reiniciar arriba
                ash.Position = UDim2.new(
                math.random(0, 100) / 100,
                0,
                -0.1,
                0
                )
            end
        end)
    end
    
    print("✅ GUI del Upside Down creado")
end

-- SONIDO AMBIENTAL
local function createAmbientSound()
    local sound = Instance.new("Sound")
    sound.Name = "UpsideDownAmbient"
    sound.SoundId = "rbxassetid://9114397505" -- Sonido ambiente oscuro
    sound.Volume = 0.3
    sound.Looped = true
    sound.Parent = workspace
    sound:Play()
    
    print("✅ Sonido ambiental activado")
end

-- RAYOS ROJOS CAYENDO
local function createLightningEffects()
    task.spawn(function()
        while true do
            task.wait(math.random(3, 8))
            
            -- Crear rayo en posición aleatoria
            local randomX = math.random(-500, 500)
            local randomZ = math.random(-500, 500)
            
            local lightning = Instance.new("Part")
            lightning.Name = "Lightning"
            lightning.Size = Vector3.new(2, 200, 2)
            lightning.Position = Vector3.new(randomX, 150, randomZ)
            lightning.Anchored = true
            lightning.CanCollide = false
            lightning.Material = Enum.Material.Neon
            lightning.Color = Color3.fromRGB(255, 100, 100)
            lightning.Transparency = 0.3
            lightning.Parent = workspace
            
            -- Luz del rayo
            local light = Instance.new("PointLight")
            light.Brightness = 10
            light.Color = Color3.fromRGB(255, 80, 80)
            light.Range = 100
            light.Parent = lightning
            
            -- Sonido de trueno
            local thunder = Instance.new("Sound")
            thunder.SoundId = "rbxassetid://130818250"
            thunder.Volume = 0.5
            thunder.Parent = lightning
            thunder:Play()
            
            -- Flash en pantalla
            task.spawn(function()
                local players = game:GetService("Players")
                for _, plr in pairs(players:GetPlayers()) do
                    local gui = plr.PlayerGui:FindFirstChild("UpsideDownFilter")
                    if gui then
                        local flash = Instance.new("Frame")
                        flash.Size = UDim2.new(1, 0, 1, 0)
                        flash.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                        flash.BackgroundTransparency = 0.7
                        flash.BorderSizePixel = 0
                        flash.ZIndex = 10
                        flash.Parent = gui
                        
                        TweenService:Create(flash, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
                        task.wait(0.1)
                        flash:Destroy()
                    end
                end
            end)
            
            -- Animación del rayo
            for i = 1, 5 do
                lightning.Transparency = 0.2
                task.wait(0.05)
                lightning.Transparency = 0.8
                task.wait(0.05)
            end
            
            lightning:Destroy()
        end
    end)
    
    print("✅ Sistema de rayos activado")
end

-- NUBES DE HUMO EN EL CIELO
local function createSkyClouds()
    for i = 1, 15 do
        local cloud = Instance.new("Part")
        cloud.Name = "SkyCloud" .. i
        cloud.Size = Vector3.new(150, 50, 150)
        cloud.Position = Vector3.new(
        math.random(-800, 800),
        math.random(200, 400),
        math.random(-800, 800)
        )
        cloud.Anchored = true
        cloud.CanCollide = false
        cloud.Material = Enum.Material.Neon
        cloud.Color = Color3.fromRGB(100, 50, 50)
        cloud.Transparency = 0.7
        cloud.Parent = workspace
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Sphere
        mesh.Scale = Vector3.new(1, 0.3, 1)
        mesh.Parent = cloud
        
        -- Movimiento lento
        task.spawn(function()
            while cloud and cloud.Parent do
                local duration = math.random(30, 60)
                local targetPos = Vector3.new(
                cloud.Position.X + math.random(-200, 200),
                cloud.Position.Y + math.random(-20, 20),
                cloud.Position.Z + math.random(-200, 200)
                )
                
                TweenService:Create(cloud, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = targetPos,
                Transparency = math.random(60, 85) / 100
                }):Play()
                
                task.wait(duration)
            end
        end)
    end
    
    print("✅ Nubes del cielo creadas")
end

-- INICIALIZAR TODO
setupLighting()
createUpsideDownGUI()
createAmbientSound()
createLightningEffects()
createSkyClouds()

print("🌀 Upside Down Filter - ¡ACTIVADO CON RAYOS Y NUBES!")


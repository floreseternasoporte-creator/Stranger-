-- LocalScript Cinematográfico MEJORADO - Stranger Things Tower Earthquake
-- CAÍDA ÉPICA MEJORADA con cámara lenta REAL
-- Coloca este script en StarterPlayer > StarterPlayerScripts
 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
 
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local head = character:WaitForChild("Head")
 
local CinematicEvent = ReplicatedStorage:WaitForChild("TsunamiCinematicEvent")
 
local camera = workspace.CurrentCamera
local originalCameraType = camera.CameraType
local originalCameraSubject = camera.CameraSubject
 
local PRE_EARTHQUAKE_MUSIC = "rbxassetid://1177116301558"
local EARTHQUAKE_MUSIC = "rbxassetid://9045724335"
 
local isCinematicActive = false
 
-- ===================== FUNCIONES DE CÁMARA =====================
local function createCameraShot(targetCFrame, duration, easingStyle, easingDirection)
    camera.CameraType = Enum.CameraType.Scriptable
    
    local tweenInfo = TweenInfo.new(
    duration,
    easingStyle or Enum.EasingStyle.Sine,
    easingDirection or Enum.EasingDirection.InOut
    )
    
    local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    return tween
end
 
local function followTarget(target, offset, duration)
    local connection
    local startTime = tick()
    
    connection = RunService.RenderStepped:Connect(function()
        if tick() - startTime > duration then
            connection:Disconnect()
            return
        end
        
        if target and target.Parent then
            camera.CFrame = target.CFrame * offset
        else
            connection:Disconnect()
        end
    end)
    
    return connection
end
 
-- ===================== ANIMACIONES DEL PERSONAJE =====================
local function makeCharacterStruggle()
    -- Hacer que los brazos se muevan como tratando de agarrarse
    local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
    local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
    
    if leftArm and rightArm then
        -- Animación de brazos tratando de agarrarse
        task.spawn(function()
            for i = 1, 8 do
                -- Extender brazos
                local leftWeld = Instance.new("Weld")
                leftWeld.Part0 = humanoidRootPart
                leftWeld.Part1 = leftArm
                leftWeld.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(-90 + math.random(-20, 20)), 0, 0)
                leftWeld.Parent = leftArm
                
                local rightWeld = Instance.new("Weld")
                rightWeld.Part0 = humanoidRootPart
                rightWeld.Part1 = rightArm
                rightWeld.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(-90 + math.random(-20, 20)), 0, 0)
                rightWeld.Parent = rightArm
                
                task.wait(0.2)
                
                leftWeld:Destroy()
                rightWeld:Destroy()
                
                task.wait(0.1)
            end
        end)
    end
end
 
-- ===================== CINEMÁTICA ÉPICA =====================
local function startEpicCinematic(lighthouseData)
    if isCinematicActive then return end
    isCinematicActive = true
    
    print("🎬 INICIANDO CINEMÁTICA ÉPICA")
    
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    
    local playerGui = player:WaitForChild("PlayerGui")
    local coreGui = game:GetService("StarterGui")
    coreGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    
    -- ===== FASE 1: MÚSICA PRE-TERREMOTO =====
    local preMusic = Instance.new("Sound")
    preMusic.SoundId = PRE_EARTHQUAKE_MUSIC
    preMusic.Volume = 0.8
    preMusic.Parent = workspace
    preMusic:Play()
    
    -- TOMA 1: Vista panorámica (5s)
    local towerPosition = lighthouseData.position
    local panoCFrame = CFrame.new(
    towerPosition + Vector3.new(150, 100, 150),
    towerPosition
    )
    createCameraShot(panoCFrame, 5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    
    task.wait(5)
    
    -- TOMA 2: Primer plano del faro (3s)
    local lighthousePlatform = lighthouseData.platform
    local closeupCFrame = CFrame.new(
    lighthousePlatform.Position + Vector3.new(10, 2, 10),
    lighthousePlatform.Position
    )
    createCameraShot(closeupCFrame, 3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.wait(3)
    
    -- TOMA 3: Jugador mirando (2s)
    local playerCFrame = CFrame.new(
    humanoidRootPart.Position + Vector3.new(5, 3, 5),
    humanoidRootPart.Position
    )
    createCameraShot(playerCFrame, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    
    task.wait(2)
    
    -- Fade out música
    local fadeOut = TweenService:Create(preMusic, TweenInfo.new(1), {Volume = 0})
    fadeOut:Play()
    
    task.wait(1)
    preMusic:Stop()
    preMusic:Destroy()
    
    -- ===== FASE 2: TERREMOTO =====
    local earthquakeMusic = Instance.new("Sound")
    earthquakeMusic.SoundId = EARTHQUAKE_MUSIC
    earthquakeMusic.Volume = 1
    earthquakeMusic.Looped = false
    earthquakeMusic.Parent = workspace
    earthquakeMusic:Play()
    
    print("🌊 INICIANDO TERREMOTO")
    
    -- TOMA 4: Vista aérea (3s)
    local aerialCFrame = CFrame.new(
    towerPosition + Vector3.new(200, 150, 200),
    towerPosition
    )
    createCameraShot(aerialCFrame, 3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    
    -- ===== TERREMOTO: TAMBALEO =====
    local towerModel = lighthouseData.towerData.model
    local originalCFrames = {}
    
    for _, part in pairs(towerModel:GetDescendants()) do
        if part:IsA("BasePart") and part.Anchored then
            originalCFrames[part] = part.CFrame
        end
    end
    
    local earthquakeDuration = 15
    local earthquakeIntensity = 2
    local earthquakeActive = true
    
    task.spawn(function()
        local startTime = tick()
        
        while earthquakeActive and tick() - startTime < earthquakeDuration do
            for part, originalCFrame in pairs(originalCFrames) do
                if part and part.Parent then
                    local shakeX = math.sin(tick() * 4) * earthquakeIntensity
                    local shakeZ = math.cos(tick() * 3) * earthquakeIntensity
                    local tilt = math.sin(tick() * 2) * math.rad(3)
                    
                    part.CFrame = originalCFrame 
                    * CFrame.new(shakeX, 0, shakeZ) 
                    * CFrame.Angles(tilt, 0, tilt * 0.5)
                end
            end
            
            task.wait(0.03)
        end
        
        for part, originalCFrame in pairs(originalCFrames) do
            if part and part.Parent then
                part.CFrame = originalCFrame
            end
        end
    end)
    
    task.wait(3)
    
    -- TOMA 5: Jugador asustado (2s)
    local faceCFrame = CFrame.new(
    humanoidRootPart.Position + Vector3.new(3, 1.5, 3),
    humanoidRootPart.Position + Vector3.new(0, 1.5, 0)
    )
    createCameraShot(faceCFrame, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(50000, 0, 50000)
    bodyVelocity.Velocity = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
    bodyVelocity.Parent = humanoidRootPart
    
    task.wait(2)
    
    -- TOMA 6: Deslizándose (3s)
    print("🏃 DESLIZÁNDOSE")
    
    bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
    bodyVelocity.Velocity = Vector3.new(math.random(-15, 15), 0, math.random(-15, 15))
    
    local slideConnection = followTarget(
    humanoidRootPart,
    CFrame.new(8, 2, 8) * CFrame.Angles(0, math.rad(-135), 0),
    3
    )
    
    task.wait(3)
    
    bodyVelocity:Destroy()
    
    -- ===== TOMA 7-12: CAÍDA ÉPICA (CÁMARA LENTA REAL - 8+ SEGUNDOS) =====
    print("🌀 INICIANDO CAÍDA ÉPICA")
    
    -- TOMA 7: Jugador tratando de sostenerse (2s)
    print("😰 TRATANDO DE SOSTENERSE")
    
    -- Animación de lucha
    makeCharacterStruggle()
    
    -- Cámara primer plano de la cara (expresión de miedo)
    local struggleCFrame = CFrame.new(
    head.Position + Vector3.new(2, 0.5, 2),
    head.Position
    )
    createCameraShot(struggleCFrame, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.wait(2)
    
    -- TOMA 8: Vista lateral mientras se resbala (1.5s)
    print("🔻 RESBALANDO")
    
    local slipVelocity = Instance.new("BodyVelocity")
    slipVelocity.MaxForce = Vector3.new(100000, 50000, 100000)
    slipVelocity.Velocity = Vector3.new(math.random(-10, 10), -5, math.random(-10, 10))
    slipVelocity.Parent = humanoidRootPart
    
    local sideViewConnection = followTarget(
    humanoidRootPart,
    CFrame.new(6, 0, 0) * CFrame.Angles(0, math.rad(-90), 0),
    1.5
    )
    
    task.wait(1.5)
    
    slipVelocity:Destroy()
    
    -- TOMA 9: INICIO DE LA CAÍDA - CÁMARA LENTA (2s)
    print("⬇️ CAYENDO EN CÁMARA LENTA")
    
    -- Lanzar al jugador
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(100000, 100000, 100000)
    bodyAngularVelocity.AngularVelocity = Vector3.new(
    math.random(-8, 8),
    math.random(10, 20),
    math.random(-8, 8)
    )
    bodyAngularVelocity.Parent = humanoidRootPart
    
    local launchVelocity = Instance.new("BodyVelocity")
    launchVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    launchVelocity.Velocity = Vector3.new(
    math.random(-15, 15),
    40,
    math.random(-15, 15)
    )
    launchVelocity.Parent = humanoidRootPart
    
    -- Vista frontal de la cara cayendo (ÉPICO)
    local frontFaceConnection
    task.spawn(function()
        local startTime = tick()
        local duration = 2
        
        while tick() - startTime < duration do
            -- Cámara frente a la cara
            local faceOffset = head.CFrame.LookVector * 4
            camera.CFrame = CFrame.new(
            head.Position + faceOffset + Vector3.new(0, 0.5, 0),
            head.Position
            )
            
            task.wait(0.03)
        end
    end)
    
    task.wait(2)
    
    -- TOMA 10: Vista de espalda cayendo (2s)
    print("🔄 VISTA DE ESPALDA")
    
    local backViewConnection
    task.spawn(function()
        local startTime = tick()
        local duration = 2
        
        while tick() - startTime < duration do
            -- Cámara detrás del personaje
            local backOffset = -head.CFrame.LookVector * 5
            camera.CFrame = CFrame.new(
            head.Position + backOffset + Vector3.new(0, 1, 0),
            head.Position
            )
            
            task.wait(0.03)
        end
    end)
    
    task.wait(2)
    
    -- TOMA 11: Giro cinematográfico (2s)
    print("🌀 GIRO CINEMATOGRÁFICO")
    
    task.spawn(function()
        local startTime = tick()
        local duration = 2
        
        while tick() - startTime < duration do
            local progress = (tick() - startTime) / duration
            local angle = progress * math.pi * 2
            
            local offset = CFrame.new(
            math.cos(angle) * 10,
            5 + math.sin(progress * math.pi) * 2,
            math.sin(angle) * 10
            )
            
            camera.CFrame = CFrame.new(
            humanoidRootPart.Position + offset.Position,
            humanoidRootPart.Position
            )
            
            task.wait(0.03)
        end
    end)
    
    task.wait(2)
    
    -- TOMA 12: Vista del suelo acercándose (2s)
    print("💥 SUELO ACERCÁNDOSE")
    
    local groundCFrame = CFrame.new(
    humanoidRootPart.Position + Vector3.new(0, -20, 10),
    humanoidRootPart.Position
    )
    createCameraShot(groundCFrame, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    task.wait(2)
    
    launchVelocity:Destroy()
    bodyAngularVelocity:Destroy()
    
    -- ===== TOMA 13: IMPACTO RÁPIDO (0.5s) =====
    print("💥 IMPACTO RÁPIDO")
    
    -- Acelerar la caída
    local fastFall = Instance.new("BodyVelocity")
    fastFall.MaxForce = Vector3.new(0, 100000, 0)
    fastFall.Velocity = Vector3.new(0, -100, 0)
    fastFall.Parent = humanoidRootPart
    
    local impactCFrame = CFrame.new(
    humanoidRootPart.Position + Vector3.new(2, 1, 2),
    humanoidRootPart.Position
    )
    createCameraShot(impactCFrame, 0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
    
    task.wait(0.5)
    
    fastFall:Destroy()
    
    -- ===== FADE TO BLACK =====
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CinematicFade"
    screenGui.Parent = playerGui
    
    local fadeFrame = Instance.new("Frame")
    fadeFrame.Size = UDim2.new(1, 0, 1, 0)
    fadeFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    fadeFrame.BackgroundTransparency = 1
    fadeFrame.BorderSizePixel = 0
    fadeFrame.Parent = screenGui
    
    local fadeTween = TweenService:Create(fadeFrame, TweenInfo.new(2), {BackgroundTransparency = 0})
    fadeTween:Play()
    
    task.wait(2)
    
    -- ===== FIN =====
    earthquakeActive = false
    
    local musicFadeOut = TweenService:Create(earthquakeMusic, TweenInfo.new(2), {Volume = 0})
    musicFadeOut:Play()
    
    task.wait(2)
    
    earthquakeMusic:Stop()
    earthquakeMusic:Destroy()
    
    camera.CameraType = originalCameraType
    camera.CameraSubject = originalCameraSubject
    
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
    
    local fadeInTween = TweenService:Create(fadeFrame, TweenInfo.new(2), {BackgroundTransparency = 1})
    fadeInTween:Play()
    
    task.wait(2)
    
    screenGui:Destroy()
    
    coreGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    
    isCinematicActive = false
    
    print("✅ CINEMÁTICA COMPLETADA")
end
 
-- ===================== CONECTAR =====================
CinematicEvent.OnClientEvent:Connect(function(action, data)
    if action == "StartCinematic" then
        task.spawn(function()
            startEpicCinematic(data)
        end)
    end
end)
 
print("🎬 LocalScript cinematográfico ÉPICO cargado")
 
 

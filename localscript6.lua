-- LocalScript - Música en bucle infinito
 
local SoundService = game:GetService("SoundService")
 
local musica = Instance.new("Sound")
musica.Name = "MusicaFondo"
musica.SoundId = "rbxassetid://109545400120727"
musica.Looped = true
musica.Volume = 1 -- Puedes ajustar el volumen (0 a 10)
musica.Parent = SoundService
 
musica:Play()
 
 

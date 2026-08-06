-- SERVER SCRIPT - MANTENER ICONO DE ROBLOX
-- Colocar en: ServerScriptService
 
local TextChatService = game:GetService("TextChatService")
 
task.wait(1)
 
-- Solo desactivar burbujas, NO el chat completo
task.spawn(function()
    local bubbleConfig = TextChatService:FindFirstChildOfClass("BubbleChatConfiguration")
    if bubbleConfig then
        pcall(function()
            bubbleConfig.Enabled = false
        end)
    end
end)
 
print("✅ SERVER: Burbujas desactivadas, icono de Roblox mantenido")
 

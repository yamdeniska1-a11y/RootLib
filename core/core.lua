local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function g()
    local c = "abcdefghijklmnopqrstuvwxyz0123456789"
    local function b()
        local s = ""
        for i = 1, 4 do s = s .. c:sub(math.random(1, #c), math.random(1, #c)) end
        return s
    end
    return b() .. "-" .. b() .. "-" .. b() .. "-" .. b()
end

local coreFolder = CoreGui:FindFirstChild("RootLib_Core") or Instance.new("Folder", CoreGui)
coreFolder.Name = "RootLib_Core"

local keyVal = coreFolder:FindFirstChild("Key") or Instance.new("StringValue", coreFolder)
keyVal.Name = "Key"
if keyVal.Value == "" then keyVal.Value = g() end

local clientScript = coreFolder:FindFirstChild("ClientVerification")
if not clientScript then
    clientScript = Instance.new("LocalScript")
    clientScript.Name = "ClientVerification"
    clientScript.Source = [[
        local CoreGui = game:GetService("CoreGui")
        local coreFolder = CoreGui:WaitForChild("RootLib_Core")
        local keyVal = coreFolder:WaitForChild("Key")
        
        local player = game:GetService("Players").LocalPlayer
        local pg = player:WaitForChild("PlayerGui")
        local clientFolder = pg:FindFirstChild("RootLib_Client") or Instance.new("Folder", pg)
        clientFolder.Name = "RootLib_Client"
        
        local clientKey = clientFolder:FindFirstChild("Key") or Instance.new("StringValue", clientFolder)
        clientKey.Name = "Key"
        clientKey.Value = keyVal.Value
        
        if clientKey.Value == keyVal.Value then
            _G.RootLibVerified = true
        else
            while true do end
        end
    ]]
    clientScript.Parent = coreFolder
end

StarterGui:SetCore("SendNotification", {
    Title = "RootLib System",
    Text = "Ядро успешно загружено!",
    Duration = 5
})

local Loader = {}
function Loader:LoadFromURL(url, args)
    local pg = player:WaitForChild("PlayerGui")
    local clientFolder = pg:FindFirstChild("RootLib_Client")
    local clientKey = clientFolder and clientFolder:FindFirstChild("Key")
    
    if not clientKey or clientKey.Value ~= keyVal.Value or not _G.RootLibVerified then
        return nil
    end
    
    local s, r = pcall(function()
        if game.HttpGet then
            local f = loadstring(game:HttpGet(url))
            if f then return f(args, clientKey.Value) end
        end
    end)
    return s and r or nil
end

return { Key = keyVal.Value, Loader = Loader }

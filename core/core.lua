local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local function g()
    local c = "abcdefghijklmnopqrstuvwxyz0123456789"
    local function b()
        local s = ""
        for i = 1, 4 do s = s .. c:sub(math.random(1, #c), math.random(1, #c)) end
        return s
    end
    return b() .. "-" .. b() .. "-" .. b() .. "-" .. b()
end

local rootLib = CoreGui:FindFirstChild("RootLib") or Instance.new("Folder", CoreGui)
rootLib.Name = "RootLib"

local coreFolder = rootLib:FindFirstChild("core") or Instance.new("Folder", rootLib)
coreFolder.Name = "core"

local key = g()

local localScript = coreFolder:FindFirstChild("CoreScript") or Instance.new("LocalScript", coreFolder)
localScript.Name = "CoreScript"
localScript.Source = 'local KEY = "' .. key .. '"\nprint("RootLib Core initialized with key:", KEY)\nreturn KEY'

StarterGui:SetCore("SendNotification", {
    Title = "RootLib System",
    Text = "Ядро успешно загружено!",
    Duration = 5
})

local Loader = {}
function Loader:LoadFromURL(url, args)
    local targetScript = coreFolder:FindFirstChild("CoreScript")
    if not targetScript then return nil end
    
    local s, r = pcall(function()
        if game.HttpGet then
            local f = loadstring(game:HttpGet(url))
            if f then return f(args, key) end
        end
    end)
    return s and r or nil
end

return { Key = key, Loader = Loader }

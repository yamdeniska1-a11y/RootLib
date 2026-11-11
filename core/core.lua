local StarterGui = game:GetService("StarterGui")
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

local pg = player:WaitForChild("PlayerGui")
local sc = pg:FindFirstChild("RootLib_Security") or Instance.new("Folder", pg)
sc.Name = "RootLib_Security"

local kv = sc:FindFirstChild("CoreKey") or Instance.new("StringValue", sc)
kv.Name = "CoreKey"
if kv.Value == "" then kv.Value = g() end

local Core = { Key = kv.Value, Version = "1.0.0" }
_G.RootLibCore = Core

StarterGui:SetCore("SendNotification", {
    Title = "RootLib System",
    Text = "Ядро успешно загружено!",
    Duration = 5
})

local Loader = {}
function Loader:LoadFromURL(url, args)
    local sec = pg:FindFirstChild("RootLib_Security")
    local k = sec and sec:FindFirstChild("CoreKey")
    if not k or k.Value ~= Core.Key then return nil end
    local s, r = pcall(function()
        if game.HttpGet then
            local f = loadstring(game:HttpGet(url))
            if f then return f(args, k.Value) end
        end
    end)
    return s and r or nil
end

return { Core = Core, Loader = Loader }

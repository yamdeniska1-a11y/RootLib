local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local function generateSecurityKey()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local function generateBlock(length)
        local block = ""
        for i = 1, length do
            local randIndex = math.random(1, #chars)
            block = block .. chars:sub(randIndex, randIndex)
        end
        return block
    end
    return generateBlock(4) .. "-" .. generateBlock(4) .. "-" .. generateBlock(4) .. "-" .. generateBlock(4)
end

local RootLibFolder = script.Parent.Parent
if not RootLibFolder or RootLibFolder.Name ~= "RootLib" then
    RootLibFolder = game:GetService("ReplicatedStorage"):FindFirstChild("RootLib") or workspace:FindFirstChild("RootLib")
end

local SECURITY_KEY = script:GetAttribute("RootLibKey")
if not SECURITY_KEY then
    SECURITY_KEY = generateSecurityKey()
    script:SetAttribute("RootLibKey", SECURITY_KEY)
end

local RootCore = {
    Version = "1.0.0",
    Key = SECURITY_KEY,
    LoadedModules = {},
}

function RootCore:VerifyStructure()
    if RootLibFolder then
        local requiredFolders = {"core", "loader", "modulegame", "modulelib", "verification"}
        for _, folderName in ipairs(requiredFolders) do
            if not RootLibFolder:FindFirstChild(folderName) then
            end
        end
    end
end

function RootCore:LoadModule(moduleName, sourceURL, providedKey)
   if providedKey ~= self.Key then
        return error("RootLib [ACCESS DENIED]: Неверный ключ безопасности ядра! Попытка несанкционированного доступа.")
    end

   if sourceURL and type(sourceURL) == "string" and #sourceURL > 0 then
        local success, result = pcall(function()
        end)
        if not success then
            warn("RootLib [Loader Error]: Не удалось загрузить модуль по ссылке: " .. tostring(result))
        end
    end
end

StarterGui:SetCore("SendNotification", {
    Title = "RootLib System",
    Text = "Ядро успешно загружено! Защита активна.",
    Duration = 5
})

RootCore:VerifyStructure()

-- Экспортируем ядро в _G или ReplicatedStorage для доступа из модульных скриптов
_G.RootLibCore = RootCore

return RootCore

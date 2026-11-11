local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local CONFIG_URL = "https://raw.githubusercontent.com/yamdeniska1-a11y/RootLib/refs/heads/main/core/config.json"
local CURRENT_PLACE_ID = tostring(game.PlaceId)

local function generateObfuscatedKey()
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
	local key = ""
	for i = 1, 32 do
		local randIndex = math.random(1, #chars)
		key = key .. string.sub(chars, randIndex, randIndex)
	end
	return "_" .. key
end

local function fetchJson(url)
	local success, result = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(url))
	end)
	if success then
		return result
	end
	return nil
end

local rootFolder = CoreGui:FindFirstChild("RootLib")
if not rootFolder then
	rootFolder = Instance.new("Folder")
	rootFolder.Name = "RootLib"
	rootFolder.Parent = CoreGui
end

local coreContainer = rootFolder:FindFirstChild("core")
if not coreContainer then
	coreContainer = Instance.new("Folder")
	coreContainer.Name = "core"
	coreContainer.Parent = rootFolder
end

for _, child in ipairs(coreContainer:GetChildren()) do
	child:Destroy()
end

local sessionKey = generateObfuscatedKey()
local localScript = Instance.new("LocalScript")
localScript.Name = sessionKey
localScript.Parent = coreContainer

local config = fetchJson(CONFIG_URL)
if config and config[CURRENT_PLACE_ID] then
	local scriptsList = config[CURRENT_PLACE_ID]
	for _, scriptUrl in ipairs(scriptsList) do
		task.spawn(function()
			local success, scriptContent = pcall(function()
				return game:HttpGet(scriptUrl)
			end)
			if success and scriptContent then
				local func, err = loadstring(scriptContent)
				if func then
					pcall(func)
				end
			end
		end)
	end
end

task.spawn(function()
	while true do
		task.wait(60)
		local newKey = generateObfuscatedKey()
		if localScript and localScript.Parent then
			localScript.Name = newKey
		end
		
		local freshConfig = fetchJson(CONFIG_URL)
		if not freshConfig or not freshConfig[CURRENT_PLACE_ID] then
			Players.LocalPlayer:Kick()
			break
		end
	end
end)

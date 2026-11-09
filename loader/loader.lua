if not game:IsLoaded() then
    game.Loaded:Wait()
end

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local rootLibFolder = CoreGui:FindFirstChild("RootLib")
if not rootLibFolder then
    rootLibFolder = Instance.new("Folder")
    rootLibFolder.Name = "RootLib"
    rootLibFolder.Parent = CoreGui
end

local loaderFolder = rootLibFolder:FindFirstChild("loader")
if not loaderFolder then
    loaderFolder = Instance.new("Folder")
    loaderFolder.Name = "loader"
    loaderFolder.Parent = rootLibFolder
end

local CORE_URL = "https://raw.githubusercontent.com/yamdeniska1-a11y/RootLib/refs/heads/main/core/core.lua"

local SupportedGames = {
       [122789100578830] = {
        Name = "Infected Lands",
        Version = "Any"
    },
}

local currentPlaceId = game.PlaceId
local currentVersion = game.PlaceVersion

local function ExecuteCore(coreScriptCode)
    local func, err = loadstring(coreScriptCode)
    if func then
        func()
    else
        warn("RootLib Core Execution Error: " .. tostring(err))
    end
end

local function FetchCore()
    local success, result = pcall(function()
        return game:HttpGet(CORE_URL)
    end)
    if success and result and result ~= "" and not result:match("404: Not Found") then
        return result
    end
    return nil
end

local coreCode = FetchCore()

if not coreCode then
    warn("RootLib Loader: Core validation failed. Could not fetch core.lua from the provided link.")
    return
end

local isSupported = false
local gameInfo = SupportedGames[currentPlaceId]

if gameInfo then
    if gameInfo.Version == "Any" or gameInfo.Version == currentVersion then
        isSupported = true
    end
end

if isSupported then
    ExecuteCore(coreCode)
else
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ValidationGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = loaderFolder

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "ValidationFrame"
    mainFrame.Size = UDim2.new(0, 360, 0, 210)
    mainFrame.Position = UDim2.new(0.5, -180, 0.5, -105)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(35, 35, 35)
    mainStroke.Thickness = 1.2
    mainStroke.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Validation"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = mainFrame

    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, 40)
    separator.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    separator.BorderSizePixel = 0
    separator.Parent = mainFrame

    local desc = Instance.new("TextLabel")
    desc.Name = "Description"
    desc.Size = UDim2.new(1, -40, 0, 80)
    desc.Position = UDim2.new(0, 20, 0, 55)
    desc.BackgroundTransparency = 1
    desc.Text = "Compatibility Warning:\nThis game is not found in the supported list or your game version (" .. tostring(currentVersion) .. ") is incorrect.\n\nDo you still want to force inject the core script?"
    desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 13
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Center
    desc.Parent = mainFrame

    local btnContainer = Instance.new("Frame")
    btnContainer.Name = "Buttons"
    btnContainer.Size = UDim2.new(1, -40, 0, 40)
    btnContainer.Position = UDim2.new(0, 20, 1, -55)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = mainFrame

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Name = "CancelBtn"
    cancelBtn.Size = UDim2.new(0.48, 0, 1, 0)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    cancelBtn.Font = Enum.Font.GothamSemibold
    cancelBtn.TextSize = 13
    cancelBtn.AutoButtonColor = true
    cancelBtn.Parent = btnContainer
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 6)
    cancelCorner.Parent = cancelBtn
    
    local cancelStroke = Instance.new("UIStroke")
    cancelStroke.Color = Color3.fromRGB(50, 50, 50)
    cancelStroke.Parent = cancelBtn

    local okayBtn = Instance.new("TextButton")
    okayBtn.Name = "OkayBtn"
    okayBtn.Size = UDim2.new(0.48, 0, 1, 0)
    okayBtn.Position = UDim2.new(0.52, 0, 0, 0)
    okayBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    okayBtn.Text = "Okay"
    okayBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    okayBtn.Font = Enum.Font.GothamSemibold
    okayBtn.TextSize = 13
    okayBtn.AutoButtonColor = true
    okayBtn.Parent = btnContainer
    
    local okayCorner = Instance.new("UICorner")
    okayCorner.CornerRadius = UDim.new(0, 6)
    okayCorner.Parent = okayBtn

   cancelBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        warn("RootLib Loader: Injection cancelled by user.")
    end)

    okayBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        print("RootLib Loader: Bypassing validation. Executing core...")
        ExecuteCore(coreCode)
    end)
end

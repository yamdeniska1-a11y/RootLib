local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local mainFolder = CoreGui:FindFirstChild("RootLib")
if not mainFolder then
    mainFolder = Instance.new("Folder")
    mainFolder.Name = "RootLib"
    mainFolder.Parent = CoreGui
end

local loaderFolder = mainFolder:FindFirstChild("loader")
if not loaderFolder then
    loaderFolder = Instance.new("Folder")
    loaderFolder.Name = "loader"
    loaderFolder.Parent = mainFolder
end

if loaderFolder:FindFirstChild("GameLoaderMenu") then
    loaderFolder.GameLoaderMenu:Destroy()
end

local customGui = Instance.new("ScreenGui")
customGui.Name = "GameLoaderMenu"
customGui.IgnoreGuiInset = true
customGui.Parent = loaderFolder

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 500)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = customGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(30, 30, 30)
stroke.Thickness = 0.6
stroke.Parent = mainFrame

local imageContainer = Instance.new("Frame")
imageContainer.Name = "ImageContainer"
imageContainer.Size = UDim2.new(1, 0, 0, 180)
imageContainer.Position = UDim2.new(0, 0, 0, 0)
imageContainer.BackgroundTransparency = 1
imageContainer.ClipsDescendants = true
imageContainer.Parent = mainFrame

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 10)
containerCorner.Parent = imageContainer

local iconImage = Instance.new("ImageLabel")
iconImage.Name = "GameIcon"
iconImage.Size = UDim2.new(1, 0, 1, 0)
iconImage.Position = UDim2.new(0, 0, 0, 0)
iconImage.BackgroundTransparency = 1
iconImage.ScaleType = Enum.ScaleType.Crop
iconImage.Parent = imageContainer

local imgCorner = Instance.new("UICorner")
imgCorner.CornerRadius = UDim.new(0, 10)
imgCorner.Parent = iconImage

local shadowFade = Instance.new("Frame")
shadowFade.Name = "JointShadow"
shadowFade.Size = UDim2.new(1, 0, 0, 45)
shadowFade.Position = UDim2.new(0, 0, 1, -45)
shadowFade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFade.BorderSizePixel = 0
shadowFade.Parent = imageContainer

local gradient = Instance.new("UIGradient")
gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0.3), 
    NumberSequenceKeypoint.new(1, 0)
})
gradient.Rotation = 90
gradient.Parent = shadowFade

task.spawn(function()
    local success, res = pcall(function()
        local imgUrl = "https://raw.githubusercontent.com/yamdeniska1-a11y/RootLib/refs/heads/main/icon/game/infectedlands.png"
        if writefile and getcustomasset then
            local fileName = "rootlib_temp_icon.png"
            writefile(fileName, game:HttpGet(imgUrl))
            return getcustomasset(fileName)
        end
        return nil
    end)
    if success and res then
        iconImage.Image = res
    else
        iconImage.Image = "rbxassetid://0" 
    end
end)

local particlesContainer = Instance.new("Frame")
particlesContainer.Name = "ParticlesContainer"
particlesContainer.Size = UDim2.new(1, 0, 1, -180)
particlesContainer.Position = UDim2.new(0, 0, 0, 180)
particlesContainer.BackgroundTransparency = 1
particlesContainer.ClipsDescendants = true
particlesContainer.Parent = mainFrame

task.spawn(function()
    local columns = 50
    local columnWidth = 300 / columns
    local activeColumns = {}

    for i = 1, columns do
        activeColumns[i] = false
    end

    while customGui.Parent do
        task.wait(0.05)
        
        local activeCount = 0
        for i = 1, columns do
            if activeColumns[i] then
                activeCount = activeCount + 1
            end
        end

        local targetMax = math.random(30, 50)
        if activeCount < targetMax then
            local availableCols = {}
            for i = 1, columns do
                if not activeColumns[i] then
                    table.insert(availableCols, i)
                end
            end

            if #availableCols > 0 then
                local chosenCol = availableCols[math.random(1, #availableCols)]
                activeColumns[chosenCol] = true

                local dot = Instance.new("Frame")
                dot.Name = "DustDot"
                
                local dotSize = math.random(2, 5)
                dot.Size = UDim2.new(0, dotSize, 0, dotSize)
                
                local minX = (chosenCol - 1) * columnWidth + 1
                local maxX = chosenCol * columnWidth - dotSize - 1
                local randomX = math.random(math.floor(minX), math.floor(math.max(minX, maxX)))
                
                dot.Position = UDim2.new(0, randomX, 1, 10)
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dot.BackgroundTransparency = math.random(25, 60) / 100
                dot.BorderSizePixel = 0
                dot.Parent = particlesContainer

                local dotCorner = Instance.new("UICorner")
                dotCorner.CornerRadius = UDim.new(1, 0)
                dotCorner.Parent = dot

                local speed = math.random(25, 65)

                task.spawn(function()
                    local currentY = 320
                    while dot.Parent and currentY > -10 do
                        local dt = task.wait()
                        currentY = currentY - (speed * dt)
                        dot.Position = UDim2.new(0, randomX, 0, currentY)
                    end
                    
                    if dot then
                        dot:Destroy()
                    end
                    activeColumns[chosenCol] = false
                end)
            end
        end
    end
end)

task.spawn(function()
    task.wait(5)
    
    local tweenService = game:GetService("TweenService")
    local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    pcall(function()
        for _, desc in ipairs(mainFrame:GetDescendants()) do
            if desc:IsA("GuiObject") then
                tweenService:Create(desc, fadeInfo, {BackgroundTransparency = 1}):Play()
            elseif desc:IsA("TextLabel") or desc:IsA("TextBox") then
                tweenService:Create(desc, fadeInfo, {TextTransparency = 1}):Play()
            elseif desc:IsA("ImageLabel") then
                tweenService:Create(desc, fadeInfo, {ImageTransparency = 1}):Play()
            end
        end
        tweenService:Create(stroke, fadeInfo, {Transparency = 1}):Play()
    end)
    
    task.wait(0.5)
    customGui:Destroy()

    local coreUrl = "https://raw.githubusercontent.com/yamdeniska1-a11y/RootLib/refs/heads/main/core/core.lua"
    local success, RootLib = pcall(function()
        return loadstring(game:HttpGet(coreUrl))()
    end)
    
    if not success then
        warn("RootLib Core load error: " .. tostring(RootLib))
    end
end)

local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CLI_KEY = "ZX94-KM28-PL19-QW73"

local rootLib = CoreGui:FindFirstChild("RootLib") or Instance.new("Folder", CoreGui)
rootLib.Name = "RootLib"

local coreFolder = rootLib:FindFirstChild("core") or Instance.new("Folder", rootLib)
coreFolder.Name = "core"

local oldCLI = coreFolder:FindFirstChild("commands-1")
if oldCLI then oldCLI:Destroy() end

local oldNotif = coreFolder:FindFirstChild("custom-notif")
if oldNotif then oldNotif:Destroy() end

local localScript = coreFolder:FindFirstChild("CoreScript") or Instance.new("LocalScript", coreFolder)
localScript.Name = "CoreScript"
localScript.Source = [[
    local cliKey = "]] .. CLI_KEY .. [["
    local envProtected = setmetatable({
        GetKey = function(k)
            if k == cliKey then
                return "RootLib_Core_Authorized_Dump_OK"
            end
            return nil
        end
    }, {
        __metatable = "LockedEnvironment"
    })
    return envProtected
]]

local notifGui = Instance.new("ScreenGui")
notifGui.Name = "custom-notif"
notifGui.ResetOnSpawn = false
notifGui.IgnoreGuiInset = true
notifGui.Parent = coreFolder

local notifFrame = Instance.new("Frame")
notifFrame.Name = "Notification"
notifFrame.Size = UDim2.new(0, 280, 0, 70)
notifFrame.Position = UDim2.new(1, 300, 1, -90)
notifFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
notifFrame.BorderSizePixel = 0
notifFrame.Parent = notifGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 6)
notifCorner.Parent = notifFrame

local notifStroke = Instance.new("UIStroke")
notifStroke.Color = Color3.fromRGB(40, 40, 40)
notifStroke.Thickness = 0.6
notifStroke.Parent = notifFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 20)
titleLabel.Position = UDim2.new(0, 12, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "RootLib System"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.FontFace = Font.new("rbxasset://fonts/families/Cartoon.json")
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = notifFrame

local line = Instance.new("Frame")
line.Size = UDim2.new(1, -24, 0, 1)
line.Position = UDim2.new(0, 12, 0, 31)
line.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
line.BorderSizePixel = 0
line.Parent = notifFrame

local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(1, -20, 0, 20)
descLabel.Position = UDim2.new(0, 12, 0, 38)
descLabel.BackgroundTransparency = 1
descLabel.Text = "Core successfully loaded!"
descLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
descLabel.TextSize = 12
descLabel.FontFace = Font.new("rbxasset://fonts/families/Cartoon.json")
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.Parent = notifFrame

task.spawn(function()
    notifFrame.Position = UDim2.new(1, 300, 1, -90)
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local inTween = TweenService:Create(notifFrame, info, {Position = UDim2.new(1, -290, 1, -90)})
    inTween:Play()
    inTween.Completed:Wait()
    
    task.wait(5)
    
    local outTween = TweenService:Create(notifFrame, info, {Position = UDim2.new(1, 300, 1, -90)})
    outTween:Play()
    outTween.Completed:Wait()
    notifGui:Destroy()
end)

local commands1 = Instance.new("ScreenGui")
commands1.Name = "commands-1"
commands1.ResetOnSpawn = false
commands1.IgnoreGuiInset = true
commands1.Enabled = false
commands1.Parent = coreFolder

local command = Instance.new("Frame")
command.Name = "command"
command.Size = UDim2.new(0, 400, 0, 32)
command.Position = UDim2.new(0.5, -200, 0, 60)
command.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
command.BorderSizePixel = 0
command.ClipsDescendants = true
command.Parent = commands1

local outputBox = Instance.new("ScrollingFrame")
outputBox.Name = "OutputBox"
outputBox.Size = UDim2.new(1, 0, 0, 200)
outputBox.Position = UDim2.new(0, 0, 1, 4)
outputBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
outputBox.BorderSizePixel = 0
outputBox.Visible = false
outputBox.CanvasSize = UDim2.new(0, 0, 0, 0)
outputBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
outputBox.ScrollBarThickness = 4
outputBox.Parent = command

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 6)
outputCorner.Parent = outputBox

local outputStroke = Instance.new("UIStroke")
outputStroke.Color = Color3.fromRGB(40, 40, 40)
outputStroke.Thickness = 0.6
outputStroke.Parent = outputBox

local outputList = Instance.new("UIListLayout")
outputList.SortOrder = Enum.SortOrder.LayoutOrder
outputList.Padding = UDim.new(0, 4)
outputList.Parent = outputBox

local outputPadding = Instance.new("UIPadding")
outputPadding.PaddingTop = UDim.new(0, 6)
outputPadding.PaddingBottom = UDim.new(0, 6)
outputPadding.PaddingLeft = UDim.new(0, 8)
outputPadding.PaddingRight = UDim.new(0, 8)
outputPadding.Parent = outputBox

local function addOutputLine(text)
    outputBox.Visible = true
    local lineLabel = Instance.new("TextLabel")
    lineLabel.Size = UDim2.new(1, 0, 0, 18)
    lineLabel.BackgroundTransparency = 1
    lineLabel.Text = text
    lineLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    lineLabel.TextSize = 13
    lineLabel.FontFace = Font.new("rbxasset://fonts/families/Cartoon.json")
    lineLabel.TextXAlignment = Enum.TextXAlignment.Left
    lineLabel.Parent = outputBox
end

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = command

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 40, 40)
stroke.Thickness = 0.6
stroke.Parent = command

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "close"
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.AutoButtonColor = false
closeBtn.Text = ""
closeBtn.Parent = command

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

local closeImg = Instance.new("ImageLabel")
closeImg.Name = "close"
closeImg.Size = UDim2.new(1, -6, 1, -6)
closeImg.Position = UDim2.new(0, 3, 0, 3)
closeImg.BackgroundTransparency = 1
closeImg.Image = "rbxassetid://116396312853810"
closeImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
closeImg.ScaleType = Enum.ScaleType.Fit
closeImg.Parent = closeBtn

local commander = Instance.new("TextBox")
commander.Name = "commander"
commander.Size = UDim2.new(1, -45, 1, 0)
commander.Position = UDim2.new(0, 10, 0, 0)
commander.BackgroundTransparency = 1
commander.Text = ""
commander.PlaceholderText = "Enter command..."
commander.TextColor3 = Color3.fromRGB(255, 255, 255)
commander.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
commander.TextSize = 14
commander.FontFace = Font.new("rbxasset://fonts/families/Cartoon.json")
commander.TextXAlignment = Enum.TextXAlignment.Left
commander.ClearTextOnFocus = false
commander.TextEditable = true
commander.TextTruncate = Enum.TextTruncate.AtEnd
commander.Parent = command

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end)

closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end)

closeBtn.MouseButton1Click:Connect(function()
    commands1.Enabled = false
    outputBox.Visible = false
    for _, child in ipairs(outputBox:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end)

commander.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local fullCmd = commander.Text
    commander.Text = ""
    if fullCmd == "" then return end
    
    local args = {}
    for word in fullCmd:gmatch("%S+") do
        table.insert(args, word)
    end
    
    if args[1] == "verif" then
        local userKey = args[2]
        if userKey == CLI_KEY then
            addOutputLine("Status: Success")
            addOutputLine("Session Key: " .. CLI_KEY)
            addOutputLine("Access: Granted")
        else
            addOutputLine("Status: Failed")
            addOutputLine("Error: Invalid key!")
        end
    else
        pcall(function()
            local fn = loadstring(fullCmd)
            if fn then fn() end
        end)
    end
end)

local function isInsideTextBox(input)
    if not commands1.Enabled then return false end
    local absPos = command.AbsolutePosition
    local absSize = command.AbsoluteSize
    local outPos = outputBox.AbsolutePosition
    local outSize = outputBox.AbsoluteSize
    local mouse = input.Position
    
    local insideMain = mouse.X >= absPos.X and mouse.X <= absPos.X + absSize.X and mouse.Y >= absPos.Y and mouse.Y <= absPos.Y + absSize.Y
    local insideOut = outputBox.Visible and mouse.X >= outPos.X and mouse.X <= outPos.X + outSize.X and mouse.Y >= outPos.Y and mouse.Y <= outPos.Y + outSize.Y
    
    return insideMain or insideOut
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F6 then
        local isRightShiftDown = UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
        local isLeftAltDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt)
        
        if isRightShiftDown and isLeftAltDown then
            commands1.Enabled = not commands1.Enabled
            if commands1.Enabled then
                commander:CaptureFocus()
            else
                outputBox.Visible = false
                for _, child in ipairs(outputBox:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end
            end
        end
    end
    
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    if not commands1.Enabled then return end
    if isInsideTextBox(input) then return end
    commander.Text = ""
    commander:ReleaseFocus()
end)

local Loader = {}
function Loader:LoadFromURL(url, args)
    local targetScript = coreFolder:FindFirstChild("CoreScript")
    if not targetScript then return nil end
    
    local s, r = pcall(function()
        if game.HttpGet then
            local f = loadstring(game:HttpGet(url))
            if f then return f(args, CLI_KEY) end
        end
    end)
    return s and r or nil
end

return { Key = CLI_KEY, Loader = Loader }

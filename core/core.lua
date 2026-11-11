local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local CLI_KEY = "ZX94-KM28-PL19-QW73"

local rootLib = CoreGui:FindFirstChild("RootLib") or Instance.new("Folder", CoreGui)
rootLib.Name = "RootLib"

local coreFolder = rootLib:FindFirstChild("core") or Instance.new("Folder", rootLib)
coreFolder.Name = "core"

local oldCLI = coreFolder:FindFirstChild("commands-1")
if oldCLI then oldCLI:Destroy() end

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

StarterGui:SetCore("SendNotification", {
    Title = "RootLib System",
    Text = "Ядро успешно загружено!",
    Duration = 5
})

local commands1 = Instance.new("ScreenGui")
commands1.Name = "commands-1"
commands1.ResetOnSpawn = false
commands1.IgnoreGuiInset = true
commands1.Parent = coreFolder

local command = Instance.new("Frame")
command.Name = "command"
command.Size = UDim2.new(0, 400, 0, 32)
command.Position = UDim2.new(0.5, -200, 0, 60)
command.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
command.BorderSizePixel = 0
command.ClipsDescendants = true
command.Visible = false
command.Parent = commands1

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
    command.Visible = false
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
            StarterGui:SetCore("SendNotification", {
                Title = "Verification Success",
                Text = "Доступ разрешен!",
                Duration = 8
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Access Denied",
                Text = "Неверный ключ!",
                Duration = 5
            })
        end
    else
        pcall(function()
            local fn = loadstring(fullCmd)
            if fn then fn() end
        end)
    end
end)

local function isInsideTextBox(input)
    if not commander.Visible or not command.Visible then return false end
    local absPos = commander.AbsolutePosition
    local absSize = commander.AbsoluteSize
    local mouse = input.Position
    return mouse.X >= absPos.X and mouse.X <= absPos.X + absSize.X
    and mouse.Y >= absPos.Y and mouse.Y <= absPos.Y + absSize.Y
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F6 then
        local isRightShiftDown = UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
        local isLeftAltDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt)
        
        if isRightShiftDown and isLeftAltDown then
            command.Visible = not command.Visible
            if command.Visible then
                commander:CaptureFocus()
            end
        end
    end
    
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    if not command.Visible then return end
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

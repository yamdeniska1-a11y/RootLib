local CoreGui = game:GetService("CoreGui")
if game:GetService("CoreGui"):FindFirstChild("RootLib") then
return
end
 local TweenService = game:GetService("TweenService")
  local UserInputService = game:GetService("UserInputService")
   local RunService = game:GetService("RunService")
    local LOADER_URL = "https://raw.githubusercontent.com/yamdeniska1-a11y/RootLib/refs/heads/main/loader/loader.lua"
     local SupportedGames = {
     [122789100578830] = { Name = "Infected Lands", Version = "Any" }
     }
      local function RunCore()
       local success, loaderCode = pcall(function()
       return game:HttpGet(LOADER_URL)
       end)
       if success and loaderCode and not loaderCode:match("404: Not Found") then
        local func, err = loadstring(loaderCode)
        if func then
        func()
        end
        end
        end
         local isSupported = false
          local gameInfo = SupportedGames[game.PlaceId]
          if gameInfo then
          if gameInfo.Version == "Any" or gameInfo.Version == game.PlaceVersion then
          isSupported = true
          end
          end
          if isSupported then
          RunCore()
          return
          end
          if CoreGui:FindFirstChild("RootLib") then
          CoreGui.RootLib:Destroy()
          end

local CoreGui = game:GetService("CoreGui")
 local TweenService = game:GetService("TweenService")
  local UserInputService = game:GetService("UserInputService")
   local RunService = game:GetService("RunService")
   if CoreGui:FindFirstChild("RootLib") then
   CoreGui.RootLib:Destroy()
   end

local RootLib = Instance.new("Folder")
RootLib.Name = "RootLib"
RootLib.Parent = CoreGui
 local VerificationFolder = Instance.new("Folder")
 VerificationFolder.Name = "verification"
 VerificationFolder.Parent = RootLib
  local loaderFolder = Instance.new("Folder")
  loaderFolder.Name = "loader"
  loaderFolder.Parent = RootLib
   local coreFolder = Instance.new("Folder")
   coreFolder.Name = "core"
   coreFolder.Parent = RootLib
    local modulelibFolder = Instance.new("Folder")
    modulelibFolder.Name = "modulelib"
    modulelibFolder.Parent = RootLib
     local modulegameFolder = Instance.new("Folder")
     modulegameFolder.Name = "modulegame"
     modulegameFolder.Parent = RootLib

local loader = Instance.new("ScreenGui")
loader.Name = "loader"
loader.IgnoreGuiInset = true
loader.Parent = loaderFolder
 local frameloader = Instance.new("Frame")
 frameloader.Name = "frameloader"
 frameloader.Size = UDim2.new(0, 400, 0, 150)
 frameloader.Position = UDim2.new(0.5, -200, 0.5, -75)
 frameloader.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 frameloader.BorderSizePixel = 0
 frameloader.Parent = loader
  local MainCorner = Instance.new("UICorner")
  MainCorner.CornerRadius = UDim.new(0, 10)
  MainCorner.Parent = frameloader
   local MainStroke = Instance.new("UIStroke")
   MainStroke.Color = Color3.fromRGB(30, 30, 30)
   MainStroke.Thickness = 0.6
   MainStroke.Parent = frameloader
    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Size = UDim2.new(1, -30, 0, 30)
    title.Position = UDim2.new(0, 15, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Verification"
    title.TextColor3 = Color3.fromRGB(255, 140, 0)
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.FontFace = Font.new("rbxassetid://16658246179", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    title.Parent = frameloader
     local framestroke = Instance.new("Frame")
     framestroke.Name = "framestroke"
     framestroke.Size = UDim2.new(1, -30, 0, 1)
     framestroke.Position = UDim2.new(0, 15, 0, 45)
     framestroke.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
     framestroke.BorderSizePixel = 0
     framestroke.Parent = frameloader
      local message = Instance.new("TextLabel")
      message.Name = "message"
      message.Size = UDim2.new(1, -30, 0, 50)
      message.Position = UDim2.new(0, 15, 0, 55)
      message.BackgroundTransparency = 1
      message.Text = "This game is currently unsupported by the script. Executing it may cause bugs, crashes, or errors. Do you still wish to proceed?"
      message.TextColor3 = Color3.fromRGB(210, 210, 210)
      message.TextSize = 13
      message.Font = Enum.Font.SourceSans
      message.TextXAlignment = Enum.TextXAlignment.Left
      message.TextYAlignment = Enum.TextYAlignment.Top
      message.TextWrapped = true
      message.Parent = frameloader
       local button = Instance.new("Frame")
       button.Name = "button"
       button.Size = UDim2.new(1, -30, 0, 30)
       button.Position = UDim2.new(0, 15, 1, -40)
       button.BackgroundTransparency = 1
       button.Parent = frameloader

local function setupButtonHover(btn)
 local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
  local hoverTween = TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
   local unhoverTween = TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
   btn.MouseEnter:Connect(function()
   hoverTween:Play()
   end)
   btn.MouseLeave:Connect(function()
   unhoverTween:Play()
   end)
   end

local okay = Instance.new("TextButton")
okay.Name = "okay"
okay.Size = UDim2.new(0.48, 0, 1, 0)
okay.Position = UDim2.new(0, 0, 0, 0)
okay.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
okay.AutoButtonColor = false
okay.Text = "Okay"
okay.TextColor3 = Color3.fromRGB(255, 255, 255)
okay.TextSize = 13
okay.Font = Enum.Font.SourceSansBold
okay.Parent = button
 local okayCorner = Instance.new("UICorner")
 okayCorner.CornerRadius = UDim.new(0, 6)
 okayCorner.Parent = okay
  local okayStroke = Instance.new("UIStroke")
  okayStroke.Color = Color3.fromRGB(50, 50, 50)
  okayStroke.Thickness = 0.6
  okayStroke.Parent = okay
  setupButtonHover(okay)
  okay.MouseButton1Click:Connect(function()
  loader:Destroy()
  RunCore()
  end)

local cancel = Instance.new("TextButton")
cancel.Name = "cancel"
cancel.Size = UDim2.new(0.48, 0, 1, 0)
cancel.Position = UDim2.new(0.52, 0, 0, 0)
cancel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
cancel.AutoButtonColor = false
cancel.Text = "Cancel"
cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
cancel.TextSize = 13
cancel.Font = Enum.Font.SourceSansBold
cancel.Parent = button
 local cancelCorner = Instance.new("UICorner")
 cancelCorner.CornerRadius = UDim.new(0, 6)
 cancelCorner.Parent = cancel
  local cancelStroke = Instance.new("UIStroke")
  cancelStroke.Color = Color3.fromRGB(50, 50, 50)
  cancelStroke.Thickness = 0.6
  cancelStroke.Parent = cancel
  setupButtonHover(cancel)
  cancel.MouseButton1Click:Connect(function()
  if CoreGui:FindFirstChild("RootLib") then
  CoreGui.RootLib:Destroy()
  end
  end)

local function makeDrag(frame)
 local dragging = false
  local dragInput, mousePos, framePos
   local targetPosition = frame.Position
   frame.InputBegan:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
   dragging = true
   mousePos = input.Position
   framePos = frame.Position
   targetPosition = frame.Position
   input.Changed:Connect(function()
   if input.UserInputState == Enum.UserInputState.End then
   dragging = false
   end
   end)
   end
   end)
   frame.InputChanged:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
   dragInput = input
   end
   end)
   UserInputService.InputChanged:Connect(function(input)
   if input == dragInput and dragging then
   local delta = input.Position - mousePos
   targetPosition = UDim2.new(
   framePos.X.Scale, 
   framePos.X.Offset + delta.X, 
   framePos.Y.Scale, 
   framePos.Y.Offset + delta.Y
   )
   end
   end)
   RunService.RenderStepped:Connect(function(dt)
   if dragging or (frame.Position.X.Offset ~= targetPosition.X.Offset or frame.Position.Y.Offset ~= targetPosition.Y.Offset) then
    local currentX = frame.Position.X.Offset + (targetPosition.X.Offset - frame.Position.X.Offset) * 0.25
     local currentY = frame.Position.Y.Offset + (targetPosition.Y.Offset - frame.Position.Y.Offset) * 0.25
     frame.Position = UDim2.new(
     frame.Position.X.Scale, 
     currentX, 
     frame.Position.Y.Scale, 
     currentY
     )
     end
     end)
     end

makeDrag(frameloader)
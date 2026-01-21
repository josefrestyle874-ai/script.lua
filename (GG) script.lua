local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local GuiService = game:GetService('GuiService')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TeleportService = game:GetService('TeleportService')
local player = Players.LocalPlayer
local Player = player
local playerGui = player:WaitForChild('PlayerGui')
local camera = Workspace.CurrentCamera
local CONFIG = "JS7_HUB_Config.json"
local ToggleStates = {}
if isfile and readfile and isfile(CONFIG) then
    pcall(function()
        ToggleStates = HttpService:JSONDecode(readfile(CONFIG))
    end)
end
local function save()
    if writefile then
        pcall(function()
            writefile(CONFIG, HttpService:JSONEncode(ToggleStates))
        end)
    end
end

-- Carregar Nothing Library
local NothingLibrary = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NOTHING/main/source.lua'))();
local Notification = NothingLibrary.Notification();

Notification.new({
    Title = "-JS7 ðŸ‘‘ HUB --",
    Description = "Loaded successfully!",
    Duration = 5,
    Icon = "rbxassetid://8997385628"
})

-- Criar janela principal COM TEMA VERMELHO
local Windows = NothingLibrary.new({
    Title = "-JS7 ðŸ‘‘ HUB --",
    Description = "Premium Script Hub",
    Keybind = Enum.KeyCode.RightControl,
    Logo = 'http://www.roblox.com/asset/?id=18898582662',
    Color = Color3.fromRGB(220, 0, 0)
})

-- VariÃ¡veis para armazenar conexÃµes
local activeBestBrainrotESPs = {}
local infJumpConnection = nil
local slowFallConn = nil
local jumpBoostConnection = nil
local aimbotConn = nil
local sentryTeleportConn = nil
local sentryEquipConn = nil
local speedBoostConn = nil
local baseTimerConnection = nil
local bestBrainrotConn = nil
local espConnections = {}
local xrayConnection = nil
local connections = {SemiInvisible = {}}
local isInvisible = false
local platform = nil
local followConn = nil
local stealFloorHRP = nil
local platformV2, connectionV2
local activeV2 = false
local isRisingV2 = false
local originalPropsV2 = {}
local flyToBestActive = false
local linearVelocity = nil
local angularVelocity = nil
local mainConnection = nil
local touchConnection = nil
local ultraSpeedGrappleConn = nil
local ultraSpeedBoostConn = nil
local autoFishCastConn = nil
local autoFishClickConn = nil

-- ABA MAIN
local MainTab = Windows:NewTab({
    Title = "Main",
    Description = "Main Features",
    Icon = "rbxassetid://7733960981"
})

local MainSection = MainTab:NewSection({
    Title = "Player",
    Icon = "rbxassetid://7743869054",
    Position = "Left"
})

local MovementSection = MainTab:NewSection({
    Title = "Movement",
    Icon = "rbxassetid://7733964719",
    Position = "Left"
})

local CombatSection = MainTab:NewSection({
    Title = "Combat",
    Icon = "rbxassetid://7734053708",
    Position = "Right"
})

local TeleportSection = MainTab:NewSection({
    Title = "Teleport",
    Icon = "rbxassetid://7734055656",
    Position = "Right"
})

-- ABA ESP
local ESPTab = Windows:NewTab({
    Title = "ESP",
    Description = "Visual Features",
    Icon = "rbxassetid://7733962543"
})

local PlayerESPSection = ESPTab:NewSection({
    Title = "Player ESP",
    Icon = "rbxassetid://7743869054",
    Position = "Left"
})

local BaseESPSection = ESPTab:NewSection({
    Title = "Base ESP",
    Icon = "rbxassetid://7733964719",
    Position = "Right"
})

-- ABA MISC
local MiscTab = Windows:NewTab({
    Title = "Misc",
    Description = "Miscellaneous Features",
    Icon = "rbxassetid://7733963287"
})

local UtilitySection = MiscTab:NewSection({
    Title = "Utility",
    Icon = "rbxassetid://7743869054",
    Position = "Left"
})

local ServerSection = MiscTab:NewSection({
    Title = "Server",
    Icon = "rbxassetid://7733964719",
    Position = "Right"
})

-- ABA CREDITS
local CreditsTab = Windows:NewTab({
    Title = "Credits",
    Description = "Credits & Information",
    Icon = "rbxassetid://7733963981"
})

local CreditsSection = CreditsTab:NewSection({
    Title = "Credits",
    Icon = "rbxassetid://7743869054",
    Position = "Left"
})

local InfoSection = CreditsTab:NewSection({
    Title = "Information",
    Icon = "rbxassetid://7733964719",
    Position = "Right"
})

-- FUNÃ‡Ã•ES DO SCRIPT
local function clearESP(model)
    local esp = activeBestBrainrotESPs[model]
    if esp then
        if esp[7] then esp[7]:Disconnect() end
        if esp[1] then esp[1]:Destroy() end
        if esp[2] then esp[2]:Destroy() end
        if esp[3] then esp[3]:Destroy() end
        if esp[4] then esp[4]:Destroy() end
        if esp[5] then esp[5]:Destroy() end
        if esp[6] then esp[6]:Destroy() end
        activeBestBrainrotESPs[model] = nil
    end
end

local function toggleInfJump(state)
    if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
    if state then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild('HumanoidRootPart') then
                char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X,50,char.HumanoidRootPart.Velocity.Z)
            end
        end)
    end
end

local function toggleSlowFalling(state)
    if slowFallConn then slowFallConn:Disconnect() slowFallConn = nil end
    if state then
        slowFallConn = RunService.RenderStepped:Connect(function()
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild('HumanoidRootPart')
                if hrp and hrp.Velocity.Y < 0 then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X,-10,hrp.Velocity.Z)
                end
            end
        end)
    end
end

local jumpBoostCanBoost = true
local function toggleJumpBoost(state)
    if jumpBoostConnection then jumpBoostConnection:Disconnect() jumpBoostConnection = nil end
    if state then
        local function setup()
            local char = player.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass('Humanoid')
            local rootPart = char:FindFirstChild('HumanoidRootPart')
            if not humanoid or not rootPart then return end
            jumpBoostConnection = humanoid.StateChanged:Connect(function(_,newState)
                if newState == Enum.HumanoidStateType.Jumping and jumpBoostCanBoost then
                    local currentVel = rootPart.AssemblyLinearVelocity
                    rootPart.AssemblyLinearVelocity = Vector3.new(currentVel.X,100,currentVel.Z)
                    jumpBoostCanBoost = false
                elseif newState == Enum.HumanoidStateType.Landed then
                    jumpBoostCanBoost = true
                end
            end)
        end
        setup()
        player.CharacterAdded:Connect(setup)
    end
end

local function toggleAimbot(state)
    if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
    if state then
        local MAX_DISTANCE = 60
        local COOLDOWN = 0.1
        local OBSTACLE_DISABLE_TIME = 0.5
        local UseItemEvent
        pcall(function()
            UseItemEvent = ReplicatedStorage:WaitForChild('Packages'):WaitForChild('Net'):WaitForChild('RE/UseItem')
        end)
        local aimbotState = { aimbot = true, autoEnabled = true }
        local function getNearestPlayer()
            local char = player.Character
            if not char or not char:FindFirstChild('HumanoidRootPart') then return nil, math.huge end
            local myPos = char.HumanoidRootPart.Position
            local closest, closestDist = nil, math.huge
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') then
                    local d = (myPos - plr.Character.HumanoidRootPart.Position).Magnitude
                    if d < closestDist then closest, closestDist = plr, d end
                end
            end
            return closest, closestDist
        end
        local function chooseHitPart(char)
            for _, name in ipairs({'Head','UpperTorso','LowerTorso','HumanoidRootPart'}) do
                local part = char:FindFirstChild(name)
                if part and part:IsA('BasePart') then return part end
            end
            return char:FindFirstChildWhichIsA('BasePart')
        end
        local lastFire = 0
        aimbotConn = RunService.Heartbeat:Connect(function()
            if not aimbotState.aimbot or not aimbotState.autoEnabled or not UseItemEvent then return end
            if tick() - lastFire < COOLDOWN then return end
            local char = player.Character
            if not char or not char:FindFirstChild('HumanoidRootPart') then return end
            local tool = char:FindFirstChildOfClass('Tool')
            if not tool then return end
            local targetPlayer, dist = getNearestPlayer()
            if not targetPlayer or dist > MAX_DISTANCE then return end
            local hitPart = chooseHitPart(targetPlayer.Character)
            if not hitPart then return end
            local hitPos = hitPart.Position
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {player.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local result = workspace:Raycast(char.HumanoidRootPart.Position,(hitPos-char.HumanoidRootPart.Position).Unit*dist,raycastParams)
            if result and result.Instance and result.Instance.CanCollide then
                result.Instance.CanCollide = false
                task.delay(OBSTACLE_DISABLE_TIME,function()
                    if result.Instance and result.Instance.Parent then result.Instance.CanCollide = true end
                end)
            end
            pcall(function() UseItemEvent:FireServer(hitPos,hitPart) end)
            lastFire = tick()
        end)
    end
end

local function toggleAutoDestroySentry(state)
    if sentryTeleportConn then sentryTeleportConn:Disconnect() sentryTeleportConn = nil end
    if sentryEquipConn then sentryEquipConn:Disconnect() sentryEquipConn = nil end
    if state then
        local function teleportSentries()
            local char = player.Character
            local hrp = char and char:FindFirstChild('HumanoidRootPart')
            if not char or not hrp then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA('Part') and obj.Name:lower():find('sentry') then
                    local frontPos = hrp.CFrame * CFrame.new(0,0,-4)
                    obj.CFrame = CFrame.new(frontPos.Position)
                    obj.CanCollide = false
                end
            end
        end
        local function equipBat()
            local char = player.Character
            if not char then return end
            local backpack = player:FindFirstChild('Backpack')
            if not backpack then return end
            local tool = backpack:FindFirstChild('Bat') or char:FindFirstChild('Bat')
            if tool then
                if not char:FindFirstChild(tool.Name) then tool.Parent = char end
                if tool:IsA('Tool') then pcall(function() tool:Activate() end) end
            end
        end
        sentryEquipConn = RunService.RenderStepped:Connect(equipBat)
        sentryTeleportConn = RunService.Heartbeat:Connect(teleportSentries)
        local charAddedConn
        charAddedConn = player.CharacterAdded:Connect(function(newChar)
            local hrp = newChar:WaitForChild('HumanoidRootPart')
        end)
    end
end

local function toggleSpeedBoostSteal(state)
    if speedBoostConn then speedBoostConn:Disconnect() speedBoostConn = nil end
    if state then
        local speedValue = 27
        speedBoostConn = RunService.RenderStepped:Connect(function()
            local char = player.Character
            local humanoid = char and char:FindFirstChildOfClass('Humanoid')
            local hrp = char and char:FindFirstChild('HumanoidRootPart')
            if humanoid and hrp and humanoid.MoveDirection.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = humanoid.MoveDirection.Unit * speedValue + Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0)
            end
        end)
        local charAddedConn
        charAddedConn = player.CharacterAdded:Connect(function(newChar)
            local humanoid = newChar:WaitForChild('Humanoid')
            local humanoidRootPart = newChar:WaitForChild('HumanoidRootPart')
        end)
    end
end

local playerESP = {Enabled = false,Highlights = {},NameTags = {}}
local function togglePlayerESP(state)
    playerESP.Enabled = state
    if not state then
        for character,_ in pairs(playerESP.Highlights) do playerESP:RemoveForCharacter(character) end
        playerESP.Highlights = {}
        playerESP.NameTags = {}
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            playerESP:CreateHighlightForCharacter(plr.Character)
            playerESP:CreateNameTag(plr, plr.Character)
        end
    end
    local playerAddedConn = Players.PlayerAdded:Connect(function(plr)
        if playerESP.Enabled then
            plr.CharacterAdded:Connect(function(char)
                playerESP:CreateHighlightForCharacter(char)
                playerESP:CreateNameTag(plr, char)
            end)
        end
    end)
    local playerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
        if plr.Character then playerESP:RemoveForCharacter(plr.Character) end
    end)
    local updateConn = RunService.Heartbeat:Connect(function()
        if playerESP.Enabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    playerESP:CreateHighlightForCharacter(plr.Character)
                    playerESP:CreateNameTag(plr, plr.Character)
                end
            end
        end
    end)
    if not state then
        playerAddedConn:Disconnect()
        playerRemovingConn:Disconnect()
        updateConn:Disconnect()
    end
end

function playerESP:CreateHighlightForCharacter(character)
    if not character or not character:IsA('Model') then return end
    if self.Highlights[character] then return end
    local highlight = Instance.new('Highlight')
    highlight.Name = 'ESPHighlight'
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.OutlineColor = Color3.fromRGB(220, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    self.Highlights[character] = highlight
end

function playerESP:CreateNameTag(plr,character)
    if not plr or not character then return end
    if self.NameTags[character] then return end
    local head = character:FindFirstChild('Head')
    if not head then return end
    local billboard = Instance.new('BillboardGui')
    billboard.Name = 'ESPNameTag'
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    local textLabel = Instance.new('TextLabel')
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = plr.Name
    textLabel.TextColor3 = Color3.fromRGB(220, 0, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard
    self.NameTags[character] = billboard
end

function playerESP:RemoveForCharacter(character)
    if self.Highlights[character] then self.Highlights[character]:Destroy() self.Highlights[character] = nil end
    if self.NameTags[character] then self.NameTags[character]:Destroy() self.NameTags[character] = nil end
end

local function toggleBaseTimerESP(state)
    if baseTimerConnection then baseTimerConnection:Disconnect() baseTimerConnection = nil
        for _, plot in pairs(Workspace:FindFirstChild('Plots') and Workspace.Plots:GetChildren() or {}) do
            local purchases = plot:FindFirstChild('Purchases')
            if purchases then
                for _, child in pairs(purchases:GetChildren()) do
                    local main = child:FindFirstChild('Main')
                    if main then
                        local gui = main:FindFirstChild('GlobalTimerGui')
                        if gui then gui:Destroy() end
                    end
                end
            end
        end
        return
    end
    if state then
        local Plots = Workspace:FindFirstChild('Plots')
        local lastValues = {}
        local lastChange = {}
        local function getOrCreateTimerGui(main)
            if not main then return nil end
            local existing = main:FindFirstChild('GlobalTimerGui')
            if existing and existing:FindFirstChild('Label') then return existing.Label end
            local gui = Instance.new('BillboardGui')
            gui.Name = 'GlobalTimerGui'
            gui.Size = UDim2.new(0,120,0,60)
            gui.StudsOffset = Vector3.new(0,5,0)
            gui.AlwaysOnTop = true
            gui.Parent = main
            local lbl = Instance.new('TextLabel')
            lbl.Name = 'Label'
            lbl.Size = UDim2.new(1,0,1,0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(220, 0, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextScaled = true
            lbl.Text = '0'
            lbl.Parent = gui
            return lbl
        end
        local function findLowestFloor(purchases)
            local lowestFloor, lowestY = nil, math.huge
            for _, child in pairs(purchases:GetChildren()) do
                local main = child:FindFirstChild('Main')
                if main then
                    local lowestPart = nil
                    if main:IsA('Model') then
                        for _, part in pairs(main:GetDescendants()) do
                            if part:IsA('BasePart') and (not lowestPart or part.Position.Y < lowestPart.Position.Y) then
                                lowestPart = part
                            end
                        end
                    elseif main:IsA('BasePart') then lowestPart = main end
                    if lowestPart and lowestPart.Position.Y < lowestY then
                        lowestY = lowestPart.Position.Y
                        lowestFloor = child
                    end
                end
            end
            return lowestFloor
        end
        baseTimerConnection = RunService.RenderStepped:Connect(function()
            if not Plots then Plots = Workspace:FindFirstChild('Plots') if not Plots then return end end
            local now = tick()
            for _, plot in pairs(Plots:GetChildren()) do
                local purchases = plot:FindFirstChild('Purchases')
                if purchases then
                    local lowestFloor = findLowestFloor(purchases)
                    if lowestFloor then
                        local main = lowestFloor:FindFirstChild('Main')
                        if main then
                            local remainingTime
                            for _, obj in pairs(main:GetDescendants()) do
                                if obj:IsA('TextLabel') and obj.Name == 'RemainingTime' then
                                    remainingTime = obj break
                                end
                            end
                            local timerLabel = getOrCreateTimerGui(main)
                            if remainingTime then
                                local currentText = remainingTime.Text or '0'
                                local key = plot.Name
                                if lastValues[key] ~= currentText then
                                    lastValues[key] = currentText
                                    lastChange[key] = now
                                end
                                local numeric = tonumber(currentText)
                                local timeSinceChange = now - (lastChange[key] or 0)
                                if numeric and numeric <= 0 then
                                    timerLabel.Text = 'Unlocked'
                                    timerLabel.TextColor3 = Color3.fromRGB(0,255,0)
                                elseif timeSinceChange > 1 then
                                    timerLabel.Text = 'Unlocked'
                                    timerLabel.TextColor3 = Color3.fromRGB(0,255,0)
                                else
                                    timerLabel.Text = currentText
                                    timerLabel.TextColor3 = Color3.fromRGB(220,60,60)
                                end
                            else
                                timerLabel.Text = 'Unlocked'
                                timerLabel.TextColor3 = Color3.fromRGB(0,255,0)
                            end
                        end
                    end
                end
            end
        end)
    end
end

local function parseNumber(txt)
    local cleaned = txt:gsub(',',''):gsub('%s+',''):gsub('%$','')
    local num,suffix = cleaned:match('(%d+%.?%d*)([kKmMb]?)%/s')
    if not num then return nil end
    local value = tonumber(num)
    if not value then return nil end
    suffix = suffix:lower()
    if suffix == 'k' then value = value*1e3
    elseif suffix == 'm' then value = value*1e6
    elseif suffix == 'b' then value = value*1e9 end
    return value
end

local function getRainbowColor()
    local t = tick()*2
    local r = math.floor((math.sin(t)*127+128))
    local g = math.floor((math.sin(t+2)*127+128))
    local b = math.floor((math.sin(t+4)*127+128))
    return Color3.fromRGB(r,g,b)
end

local function getColorFromModel(model,labelText)
    local modelName = (model.Name or ''):lower()
    local text = (labelText or ''):lower()
    local fullText = modelName..' '..text
    if fullText:find('gold') then return Color3.fromRGB(255,215,0)
    elseif fullText:find('diamond') then return Color3.fromRGB(0,170,255)
    elseif fullText:find('rainbow') then return 'rainbow'
    elseif fullText:find('lava') then return Color3.fromRGB(255,69,0)
    elseif fullText:find('bloodrot') then return Color3.fromRGB(139,0,0)
    elseif fullText:find('candy') then return Color3.fromRGB(255,105,180)
    elseif fullText:find('galaxy') then return Color3.fromRGB(170,0,255)
    elseif fullText:find('yin yang') then return Color3.fromRGB(255,255,255)
    elseif fullText:find('chocolate') then return Color3.fromRGB(139,69,19)
    elseif fullText:find('pollinated') then return Color3.fromRGB(255,255,0)
    elseif fullText:find('frozen') then return Color3.fromRGB(173,216,230)
    else return Color3.fromRGB(255,0,0) end
end

local function createESP(model,displayText)
    local color = getColorFromModel(model,displayText)
    local highlight = Instance.new('Highlight')
    highlight.Name = 'BrainrotESPHighlight'
    highlight.Adornee = model
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    if color ~= 'rainbow' then
        highlight.FillColor = color
        highlight.OutlineColor = color
    end
    highlight.Parent = Workspace
    local part = model.PrimaryPart or model:FindFirstChildWhichIsA('BasePart')
    if not part then return highlight,nil,nil,nil end
    local tag = Instance.new('BillboardGui')
    tag.Name = 'BrainrotESPTag'
    tag.Size = UDim2.new(0,200,0,50)
    tag.AlwaysOnTop = true
    tag.StudsOffset = Vector3.new(0,8,0)
    tag.Adornee = part
    tag.Parent = Workspace
    local label = Instance.new('TextLabel')
    label.Name = 'NameText'
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = displayText or model.Name
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = (color == 'rainbow') and getRainbowColor() or color
    label.Parent = tag
    local line = Instance.new('Beam')
    line.Name = 'BrainrotLine'
    line.Color = ColorSequence.new(Color3.fromRGB(220, 0, 0))
    line.Width0 = 0.5
    line.Width1 = 0.5
    line.Transparency = NumberSequence.new(0)
    line.FaceCamera = true
    line.Parent = Workspace
    local startAttachment = Instance.new('Attachment')
    startAttachment.Name = 'LineStart'
    startAttachment.Parent = Workspace.Terrain
    local endAttachment = Instance.new('Attachment')
    endAttachment.Name = 'LineEnd'
    endAttachment.Parent = part
    endAttachment.Position = Vector3.new(0,0,0)
    line.Attachment0 = startAttachment
    line.Attachment1 = endAttachment
    return highlight,tag,label,line
end

local function getBestBrainrots()
    local maxValue = -1
    local bestLabel = nil
    if not Workspace:FindFirstChild('Plots') then return {} end
    for _, plot in pairs(Workspace.Plots:GetChildren()) do
        for _, obj in pairs(plot:GetDescendants()) do
            if obj:IsA('TextLabel') then
                local txt = obj.Text or ''
                if txt:find('/') and txt:lower():find('s') then
                    local val = parseNumber(txt)
                    if val and val > maxValue then
                        maxValue = val
                        bestLabel = obj
                    end
                end
            end
        end
    end
    local results = {}
    if bestLabel then
        local model = bestLabel:FindFirstAncestorOfClass('Model')
        if model then table.insert(results,{model,bestLabel.Text}) end
    end
    return results
end

local function toggleBestBrainrotESP(state)
    if bestBrainrotConn then bestBrainrotConn:Disconnect() bestBrainrotConn = nil end
    for model in pairs(activeBestBrainrotESPs) do clearESP(model) end
    activeBestBrainrotESPs = {}
    if state then
        bestBrainrotConn = RunService.Heartbeat:Connect(function()
            local bestModels = getBestBrainrots()
            local newSet = {}
            for _, data in ipairs(bestModels) do
                local model,labelText = data[1],data[2]
                if model and model.Parent then
                    newSet[model] = true
                    if activeBestBrainrotESPs[model] then
                        local esp = activeBestBrainrotESPs[model]
                        local part = model.PrimaryPart or model:FindFirstChildWhichIsA('BasePart')
                        if part and esp[2] then esp[2].Adornee = part end
                        if part and esp[5] then esp[5].Position = part.Position end
                        local color = getColorFromModel(model,labelText)
                        if color == 'rainbow' then
                            local rainbow = getRainbowColor()
                            esp[3].TextColor3 = rainbow
                            esp[1].FillColor = rainbow
                            esp[1].OutlineColor = rainbow
                        else
                            esp[3].TextColor3 = color
                            esp[1].FillColor = color
                            esp[1].OutlineColor = color
                        end
                        if esp[3].Text ~= labelText then esp[3].Text = labelText end
                    else
                        local highlight,tag,label,line = createESP(model,labelText)
                        local startAttachment = line.Attachment0
                        local endAttachment = line.Attachment1
                        local conn = RunService.Heartbeat:Connect(function()
                            if not model.Parent then clearESP(model) conn:Disconnect() return end
                            line.Color = ColorSequence.new(Color3.fromRGB(220, 0, 0))
                            local char = player.Character
                            if char and char:FindFirstChild('Head') then
                                local head = char.Head
                                local headPosition = head.Position
                                local brainrotPos = part.Position
                                local distance = (headPosition - brainrotPos).Magnitude
                                startAttachment.Position = headPosition
                                local maxDistance = 100
                                local widthMultiplier = math.max(0.2,math.min(1,1-(distance/maxDistance)))
                                line.Width0 = 0.8*widthMultiplier
                                line.Width1 = 0.8*widthMultiplier
                            end
                        end)
                        activeBestBrainrotESPs[model] = {highlight,tag,label,line,startAttachment,endAttachment,conn}
                    end
                end
            end
            for model in pairs(activeBestBrainrotESPs) do
                if not newSet[model] or not model.Parent then clearESP(model) end
            end
        end)
    end
end

local function enableBaseESP()
    local function addHighlight(plot)
        if plot:FindFirstChild("PlotSign") and plot.PlotSign:FindFirstChild("SurfaceGui") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(0,255,0)
            highlight.OutlineColor = Color3.fromRGB(255,255,255)
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.Adornee = plot
            highlight.Parent = plot
        end
    end
    local plotsFolder = workspace:FindFirstChild("Plots")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do addHighlight(plot) end
        table.insert(espConnections,plotsFolder.ChildAdded:Connect(addHighlight))
    end
end

local function disableBaseESP()
    local plotsFolder = workspace:FindFirstChild("Plots")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local highlight = plot:FindFirstChild("ESPHighlight")
            if highlight then highlight:Destroy() end
        end
    end
    for _, conn in ipairs(espConnections) do if conn then conn:Disconnect() end end
    espConnections = {}
end

local originalProps = {}
local function toggleXRay(state)
    if xrayConnection then xrayConnection:Disconnect() xrayConnection = nil end
    for part,props in pairs(originalProps) do
        if part and part.Parent then part.Transparency = props.Transparency part.Material = props.Material end
    end
    originalProps = {}
    if state then
        local plots = workspace:FindFirstChild("Plots")
        if plots then
            originalProps = {}
            for _, plot in ipairs(plots:GetChildren()) do
                local containers = {plot:FindFirstChild("Decorations"),plot:FindFirstChild("AnimalPodiums")}
                for _, container in ipairs(containers) do
                    if container then
                        for _, obj in ipairs(container:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                originalProps[obj] = {Transparency = obj.Transparency,Material = obj.Material}
                                obj.Transparency = 0.7
                            end
                        end
                    end
                end
            end
        end
    end
end

local clone,oldRoot,hip,animTrack,connection,characterConnection
local DEPTH_OFFSET = 0.09
local function toggleInvisible(state)
    local LocalPlayer = player
    local function removeFolders()
        local playerName = LocalPlayer.Name
        local playerFolder = workspace:FindFirstChild(playerName)
        if not playerFolder then return end
        local doubleRig = playerFolder:FindFirstChild("DoubleRig")
        if doubleRig then doubleRig:Destroy() end
        local constraints = playerFolder:FindFirstChild("Constraints")
        if constraints then constraints:Destroy() end
        local childAddedConn = playerFolder.ChildAdded:Connect(function(child)
            if child.Name == "DoubleRig" or child.Name == "Constraints" then child:Destroy() end
        end)
        table.insert(connections.SemiInvisible,childAddedConn)
    end
    local function doClone()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
            hip = LocalPlayer.Character.Humanoid.HipHeight
            oldRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not oldRoot or not oldRoot.Parent then return false end
            local tempParent = Instance.new("Model") tempParent.Parent = game
            LocalPlayer.Character.Parent = tempParent
            clone = oldRoot:Clone()
            clone.Parent = LocalPlayer.Character
            oldRoot.Parent = workspace.CurrentCamera
            clone.CFrame = oldRoot.CFrame
            LocalPlayer.Character.PrimaryPart = clone
            LocalPlayer.Character.Parent = workspace
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("Weld") or v:IsA("Motor6D") then
                    if v.Part0 == oldRoot then v.Part0 = clone end
                    if v.Part1 == oldRoot then v.Part1 = clone end
                end
            end
            tempParent:Destroy()
            return true
        end
        return false
    end
    local function revertClone()
        if not oldRoot or not oldRoot:IsDescendantOf(workspace) or not LocalPlayer.Character or LocalPlayer.Character.Humanoid.Health <= 0 then return false end
        local tempParent = Instance.new("Model") tempParent.Parent = game
        LocalPlayer.Character.Parent = tempParent
        oldRoot.Parent = LocalPlayer.Character
        LocalPlayer.Character.PrimaryPart = oldRoot
        LocalPlayer.Character.Parent = workspace
        oldRoot.CanCollide = true
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == clone then v.Part0 = oldRoot end
                if v.Part1 == clone then v.Part1 = oldRoot end
            end
        end
        if clone then
            local oldPos = clone.CFrame
            clone:Destroy()
            clone = nil
            oldRoot.CFrame = oldPos
        end
        oldRoot = nil
        if LocalPlayer.Character and LocalPlayer.Character.Humanoid then LocalPlayer.Character.Humanoid.HipHeight = hip end
    end
    local function animationTrickery()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
            local anim = Instance.new("Animation")
            anim.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
            local humanoid = LocalPlayer.Character.Humanoid
            local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator",humanoid)
            animTrack = animator:LoadAnimation(anim)
            animTrack.Priority = Enum.AnimationPriority.Action4
            animTrack:Play(0,1,0)
            anim:Destroy()
            local animStoppedConn = animTrack.Stopped:Connect(function()
                if isInvisible then animationTrickery() end
            end)
            table.insert(connections.SemiInvisible,animStoppedConn)
            task.delay(0,function()
                animTrack.TimePosition = 0.7
                task.delay(1,function() animTrack:AdjustSpeed(math.huge) end)
            end)
        end
    end
    local function enableInvisibility()
        if not LocalPlayer.Character or LocalPlayer.Character.Humanoid.Health <= 0 then return false end
        removeFolders()
        local success = doClone()
        if success then
            task.wait(0.1)
            animationTrickery()
            connection = RunService.PreSimulation:Connect(function(dt)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 and oldRoot then
                    local root = LocalPlayer.Character.PrimaryPart or LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local cf = root.CFrame - Vector3.new(0,LocalPlayer.Character.Humanoid.HipHeight + (root.Size.Y/2)-1 + DEPTH_OFFSET,0)
                        oldRoot.CFrame = cf * CFrame.Angles(math.rad(180),0,0)
                        oldRoot.Velocity = root.Velocity
                        oldRoot.CanCollide = false
                    end
                end
            end)
            table.insert(connections.SemiInvisible,connection)
            characterConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
                if isInvisible then
                    if animTrack then animTrack:Stop() animTrack:Destroy() animTrack = nil end
                    if connection then connection:Disconnect() end
                    revertClone()
                    removeFolders()
                    isInvisible = false
                    for _, conn in ipairs(connections.SemiInvisible) do if conn then conn:Disconnect() end end
                    connections.SemiInvisible = {}
                end
            end)
            table.insert(connections.SemiInvisible,characterConnection)
            return true
        end
        return false
    end
    local function disableInvisibility()
        if animTrack then animTrack:Stop() animTrack:Destroy() animTrack = nil end
        if connection then connection:Disconnect() end
        if characterConnection then characterConnection:Disconnect() end
        revertClone()
        removeFolders()
    end
    local function setupGodmode()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local mt = getrawmetatable(game)
        local oldNC = mt.__namecall
        local oldNI = mt.__newindex
        setreadonly(mt,false)
        mt.__namecall = newcclosure(function(self,...)
            local m = getnamecallmethod()
            if self == hum then
                if m == "ChangeState" and select(1,...) == Enum.HumanoidStateType.Dead then return end
                if m == "SetStateEnabled" then local st,en = ... if st == Enum.HumanoidStateType.Dead and en == true then return end end
                if m == "Destroy" then return end
            end
            if self == char and m == "BreakJoints" then return end
            return oldNC(self,...)
        end)
        mt.__newindex = newcclosure(function(self,k,v)
            if self == hum then
                if k == "Health" and type(v) == "number" and v <= 0 then return end
                if k == "MaxHealth" and type(v) == "number" and v < hum.MaxHealth then return end
                if k == "BreakJointsOnDeath" and v == true then return end
                if k == "Parent" and v == nil then return end
            end
            return oldNI(self,k,v)
        end)
        setreadonly(mt,true)
    end
    if state then
        removeFolders()
        setupGodmode()
        if enableInvisibility() then isInvisible = true end
    else
        disableInvisibility()
        isInvisible = false
        for _, conn in ipairs(connections.SemiInvisible) do if conn then conn:Disconnect() end end
        connections.SemiInvisible = {}
    end
end

local function toggleStealFloor(state)
    if state then
        local char = player.Character or player.CharacterAdded:Wait()
        stealFloorHRP = char:FindFirstChild('HumanoidRootPart')
        platform = Instance.new('Part')
        platform.Size = Vector3.new(5,0.6,5)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Material = Enum.Material.Metal
        platform.Color = Color3.fromRGB(220, 0, 0)
        platform.Name = 'LiftPlatform'
        platform.Parent = Workspace
        followConn = RunService.Heartbeat:Connect(function()
            if platform and stealFloorHRP then
                local targetPos = Vector3.new(stealFloorHRP.Position.X,stealFloorHRP.Position.Y-2.5,stealFloorHRP.Position.Z)
                platform.CFrame = CFrame.new(targetPos)
            end
        end)
        toggleXRay(true)
    else
        if followConn then followConn:Disconnect() followConn = nil end
        if platform then platform:Destroy() platform = nil end
        toggleXRay(false)
    end
end

player.CharacterAdded:Connect(function(char) stealFloorHRP = char:WaitForChild('HumanoidRootPart') end)

local RISE_SPEED_V2 = 15
local function safeDisconnectV2(conn) if conn and typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end end
local function getHumanoidV2() return player.Character and player.Character:FindFirstChildOfClass("Humanoid") end
local function getHRPV2() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end
local function setPlotsTransparencyV2(active)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    if active then
        originalPropsV2 = {}
        for _, plot in ipairs(plots:GetChildren()) do
            local containers = {plot:FindFirstChild("Decorations"),plot:FindFirstChild("AnimalPodiums")}
            for _, container in ipairs(containers) do
                if container then
                    for _, obj in ipairs(container:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            originalPropsV2[obj] = {Transparency = obj.Transparency,Material = obj.Material}
                            obj.Transparency = 0.7
                        end
                    end
                end
            end
        end
    else
        for part,props in pairs(originalPropsV2) do
            if part and part.Parent then part.Transparency = props.Transparency part.Material = props.Material end
        end
        originalPropsV2 = {}
    end
end
local function destroyPlatformV2()
    if platformV2 then pcall(function() platformV2:Destroy() end) platformV2 = nil end
    activeV2 = false
    isRisingV2 = false
    safeDisconnectV2(connectionV2)
    connectionV2 = nil
    setPlotsTransparencyV2(false)
end
local function canRiseV2()
    if not platformV2 then return false end
    local origin = platformV2.Position + Vector3.new(0,platformV2.Size.Y/2,0)
    local direction = Vector3.new(0,2,0)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {platformV2,player.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    return not workspace:Raycast(origin,direction,rayParams)
end
local function toggleStealFloorV2(state)
    if state then
        local hrp = getHRPV2()
        if not hrp then return end
        platformV2 = Instance.new("Part")
        platformV2.Size = Vector3.new(6,0.5,6)
        platformV2.Anchored = true
        platformV2.CanCollide = true
        platformV2.Transparency = 0
        platformV2.Material = Enum.Material.Plastic
        platformV2.Color = Color3.fromRGB(220, 0, 0)
        platformV2.Position = hrp.Position - Vector3.new(0,hrp.Size.Y/2 + platformV2.Size.Y/2,0)
        platformV2.Parent = workspace
        setPlotsTransparencyV2(true)
        isRisingV2 = true
        activeV2 = true
        safeDisconnectV2(connectionV2)
        connectionV2 = RunService.Heartbeat:Connect(function(dt)
            if platformV2 and activeV2 then
                local cur = platformV2.Position
                local newXZ = Vector3.new(hrp.Position.X,cur.Y,hrp.Position.Z)
                if isRisingV2 and canRiseV2() then
                    platformV2.Position = newXZ + Vector3.new(0,dt*RISE_SPEED_V2,0)
                else
                    isRisingV2 = false
                    platformV2.Position = newXZ
                end
            end
        end)
    else
        destroyPlatformV2()
    end
end

local STOP_PART_NAME = 'StopZone'
local FLY_SPEED = 50
local function getBestBrainrot()
    if not Workspace:FindFirstChild('Plots') then return nil end
    local bestValue = 0
    local bestPosition = nil
    for _, plot in pairs(Workspace.Plots:GetChildren()) do
        for _, obj in pairs(plot:GetDescendants()) do
            if obj:IsA('TextLabel') and obj.Text then
                local text = obj.Text
                if text:find('/s') then
                    local numberText = text:gsub('%$',''):gsub(',',''):gsub('/s','')
                    local numberStr = numberText:match('(%d+%.?%d*)')
                    local suffix = numberText:match('[KM]') or ''
                    local value = tonumber(numberStr) or 0
                    if suffix == 'K' then value = value*1000
                    elseif suffix == 'M' then value = value*1e6 end
                    if value > bestValue then
                        bestValue = value
                        local model = obj:FindFirstAncestorOfClass('Model')
                        if model then
                            local part = model.PrimaryPart or model:FindFirstChildWhichIsA('BasePart')
                            if part then bestPosition = part.Position + Vector3.new(0,3,0) end
                        end
                    end
                end
            end
        end
    end
    return bestPosition
end
local function startFlying(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass('Humanoid')
    local rootPart = character:FindFirstChild('HumanoidRootPart')
    if not humanoid or not rootPart then return end
    local attachment = Instance.new('Attachment',rootPart)
    attachment.Name = 'FlyAttachment'
    linearVelocity = Instance.new('LinearVelocity',rootPart)
    linearVelocity.Attachment0 = attachment
    linearVelocity.MaxForce = 200000
    linearVelocity.Enabled = true
    angularVelocity = Instance.new('AngularVelocity',rootPart)
    angularVelocity.Attachment0 = attachment
    angularVelocity.MaxTorque = 200000
    angularVelocity.AngularVelocity = Vector3.new(0,0,0)
    angularVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    angularVelocity.Enabled = true
    humanoid.PlatformStand = true
end
local function stopFlying(character)
    if character then
        local humanoid = character:FindFirstChildOfClass('Humanoid')
        if humanoid then humanoid.PlatformStand = false end
        if linearVelocity then linearVelocity:Destroy() linearVelocity = nil end
        if angularVelocity then angularVelocity:Destroy() angularVelocity = nil end
        local rootPart = character:FindFirstChild('HumanoidRootPart')
        if rootPart then
            local attachment = rootPart:FindFirstChild('FlyAttachment')
            if attachment then attachment:Destroy() end
        end
    end
end
local function flyToPosition(targetPosition)
    local character = player.Character
    if not character then return true end
    local rootPart = character:FindFirstChild('HumanoidRootPart')
    if not rootPart or not targetPosition then return true end
    local currentPos = rootPart.Position
    local direction = (targetPosition - currentPos)
    local distance = direction.Magnitude
    if distance < 10 then return true end
    if not linearVelocity then startFlying(character) end
    direction = direction.Unit
    local velocity = direction * FLY_SPEED
    local heightDiff = (targetPosition.Y - currentPos.Y)
    local verticalForce = math.clamp(heightDiff*3,-50,50)
    velocity = velocity + Vector3.new(0,verticalForce,0)
    if linearVelocity then linearVelocity.VectorVelocity = velocity end
    local humanoid = character:FindFirstChildOfClass('Humanoid')
    if humanoid then humanoid:MoveTo(targetPosition) end
    return false
end
local function useGrapple()
    local character = player.Character
    if character then
        local backpack = player:FindFirstChild('Backpack')
        if backpack then
            local grapple = backpack:FindFirstChild('Grapple Hook')
            if grapple and not character:FindFirstChild('Grapple Hook') then grapple.Parent = character end
        end
        local remote = ReplicatedStorage:WaitForChild('Packages'):WaitForChild('Net'):WaitForChild('RE/UseItem')
        local args = {0}
        remote:FireServer(unpack(args))
    end
end
local function toggleFlyToBest(state)
    flyToBestActive = state
    if mainConnection then mainConnection:Disconnect() mainConnection = nil end
    if touchConnection then touchConnection:Disconnect() touchConnection = nil end
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass('Humanoid')
        local rootPart = char:FindFirstChild('HumanoidRootPart')
        if humanoid then humanoid.PlatformStand = false end
        if linearVelocity then linearVelocity:Destroy() linearVelocity = nil end
        if angularVelocity then angularVelocity:Destroy() angularVelocity = nil end
        if rootPart then
            local attachment = rootPart:FindFirstChild('FlyAttachment')
            if attachment then attachment:Destroy() end
        end
    end
    if state then
        local char = player.Character or player.CharacterAdded:Wait()
        local function setupTouchStop(char)
            if touchConnection then touchConnection:Disconnect() end
            local rootPart = char:FindFirstChild('HumanoidRootPart')
            if not rootPart then return end
            local stopPart = Workspace:FindFirstChild(STOP_PART_NAME)
            if not stopPart then warn('STOP PART NOT FOUND: '..STOP_PART_NAME) return end
            touchConnection = rootPart.Touched:Connect(function(hit)
                if hit == stopPart or hit:IsDescendantOf(stopPart) then
                    if flyToBestActive then print('TOUCHED STOP PART â†’ SYSTEM STOPPED') flyToBestActive = false end
                end
            end)
        end
        setupTouchStop(char)
        player.CharacterAdded:Connect(setupTouchStop)
        mainConnection = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char and flyToBestActive then
                local targetPosition = getBestBrainrot()
                if targetPosition then
                    local reached = flyToPosition(targetPosition)
                    if reached then stopFlying(char) task.wait(1)
                    else useGrapple() end
                else stopFlying(char) end
            end
        end)
        player.CharacterAdded:Connect(function(newChar)
            task.wait(2)
            if flyToBestActive then
                print('Respawned â†’ Restarting system...')
                if mainConnection then mainConnection:Disconnect() mainConnection = nil end
                if touchConnection then touchConnection:Disconnect() touchConnection = nil end
                stopFlying(newChar)
                task.wait(1)
                setupTouchStop(newChar)
                mainConnection = RunService.Heartbeat:Connect(function()
                    local char = player.Character
                    if char and flyToBestActive then
                        local targetPosition = getBestBrainrot()
                        if targetPosition then
                            local reached = flyToPosition(targetPosition)
                            if reached then stopFlying(char) task.wait(1)
                            else useGrapple() end
                        else stopFlying(char) end
                    end
                end)
            end
        end)
    end
end

local function toggleUltraSpeed(state)
    if ultraSpeedGrappleConn then ultraSpeedGrappleConn:Disconnect() ultraSpeedGrappleConn = nil end
    if ultraSpeedBoostConn then ultraSpeedBoostConn:Disconnect() ultraSpeedBoostConn = nil end
    if state then
        local UseItemEvent = ReplicatedStorage:WaitForChild('Packages'):WaitForChild('Net'):WaitForChild('RE/UseItem')
        local function keepGrappleHook()
            local char = player.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass('Humanoid')
            local item = player.Backpack:FindFirstChild('Grapple Hook') or char:FindFirstChild('Grapple Hook')
            if not item then return end
            if item.Parent ~= char then humanoid:EquipTool(item) end
            if item.Parent == char then UseItemEvent:FireServer(0) end
        end
        ultraSpeedGrappleConn = RunService.RenderStepped:Connect(keepGrappleHook)
        local speedValue = 120
        ultraSpeedBoostConn = RunService.RenderStepped:Connect(function()
            local char = player.Character
            local humanoid = char and char:FindFirstChildOfClass('Humanoid')
            local hrp = char and char:FindFirstChild('HumanoidRootPart')
            if humanoid and hrp and humanoid.MoveDirection.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = humanoid.MoveDirection.Unit * speedValue + Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0)
            end
        end)
        player.CharacterAdded:Connect(function(newChar) local char = newChar end)
    end
end

local function toggleRejoin(state)
    if state then
        local Success,ErrorMessage = pcall(function() TeleportService:Teleport(game.PlaceId,player) end)
        if ErrorMessage and not Success then warn(ErrorMessage) end
    end
end

local function toggleServerHop(state)
    if state then pcall(function() TeleportService:Teleport(game.PlaceId,player) end) end
end

local function toggleAutoFish(state)
    if autoFishCastConn then autoFishCastConn:Disconnect() autoFishCastConn = nil end
    if autoFishClickConn then autoFishClickConn:Disconnect() autoFishClickConn = nil end
    if not state then return end
    local CastRemote = ReplicatedStorage:WaitForChild('Packages'):WaitForChild('Net'):FindFirstChild('RE/FishingRod.Cast')
    local ClickRemote = ReplicatedStorage:WaitForChild('Packages'):WaitForChild('Net'):FindFirstChild('RE/FishingRod.MinigameClick')
    if not CastRemote or not ClickRemote then return end
    local CAST_DELAY = 7
    local CLICK_DELAY = 0.1
    local CLICK_COUNT = 60
    local function equipRod()
        local char = player.Character
        if not char then return end
        local backpack = player:FindFirstChild('Backpack')
        if not backpack then return end
        local rod = backpack:FindFirstChild('Fishing Rod') or char:FindFirstChild('Fishing Rod')
        if rod and rod.Parent ~= char then rod.Parent = char end
    end
    equipRod()
    player.CharacterAdded:Connect(function(c) task.wait(1) if ToggleStates['Auto Fish'] then equipRod() end end)
    autoFishCastConn = RunService.Heartbeat:Connect(function()
        if not player.Character then return end
        CastRemote:FireServer(0)
        task.wait(CAST_DELAY)
        for i = 1, CLICK_COUNT do ClickRemote:FireServer() task.wait(CLICK_DELAY) end
        task.wait(2)
    end)
end

-- ADICIONAR TOGGLES E BOTÃ•ES Ã€ INTERFACE

-- MAIN TAB
MainSection:NewToggle({
    Title = "Auto Fish",
    Default = false,
    Callback = function(state)
        ToggleStates["Auto Fish"] = state
        save()
        toggleAutoFish(state)
        Notification.new({
            Title = "Auto Fish",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

MainSection:NewToggle({
    Title = "Invisible",
    Default = false,
    Callback = function(state)
        ToggleStates["Invisible"] = state
        save()
        toggleInvisible(state)
        Notification.new({
            Title = "Invisible",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

MovementSection:NewToggle({
    Title = "Inf Jump",
    Default = false,
    Callback = function(state)
        ToggleStates["Inf Jump"] = state
        save()
        toggleInfJump(state)
        Notification.new({
            Title = "Inf Jump",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

MovementSection:NewToggle({
    Title = "Slow Falling",
    Default = false,
    Callback = function(state)
        ToggleStates["Slow Falling"] = state
        save()
        toggleSlowFalling(state)
        Notification.new({
            Title = "Slow Falling",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

MovementSection:NewToggle({
    Title = "Fly to Best",
    Default = false,
    Callback = function(state)
        ToggleStates["Fly to Best"] = state
        save()
        toggleFlyToBest(state)
        Notification.new({
            Title = "Fly to Best",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

MovementSection:NewToggle({
    Title = "Steal Floor",
    Default = false,
    Callback = function(state)
        ToggleStates["Steal Floor"] = state
        save()
        toggleStealFloor(state)
        Notification.new({
            Title = "Steal Floor",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

MovementSection:NewToggle({
    Title = "Steal Floor V2",
    Default = false,
    Callback = function(state)
        ToggleStates["Steal Floor V2"] = state
        save()
        toggleStealFloorV2(state)
        Notification.new({
            Title = "Steal Floor V2",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

CombatSection:NewToggle({
    Title = "Aimbot",
    Default = false,
    Callback = function(state)
        ToggleStates["Aimbot"] = state
        save()
        toggleAimbot(state)
        Notification.new({
            Title = "Aimbot",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

CombatSection:NewToggle({
    Title = "Auto Destroy Sentry",
    Default = false,
    Callback = function(state)
        ToggleStates["Auto Destroy Sentry"] = state
        save()
        toggleAutoDestroySentry(state)
        Notification.new({
            Title = "Auto Destroy Sentry",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

CombatSection:NewToggle({
    Title = "Speed Boost Steal",
    Default = false,
    Callback = function(state)
        ToggleStates["Speed Boost Steal"] = state
        save()
        toggleSpeedBoostSteal(state)
        Notification.new({
            Title = "Speed Boost Steal",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

-- ESP TAB
PlayerESPSection:NewToggle({
    Title = "ESP Player",
    Default = false,
    Callback = function(state)
        ToggleStates["ESP Player"] = state
        save()
        togglePlayerESP(state)
        Notification.new({
            Title = "ESP Player",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

BaseESPSection:NewToggle({
    Title = "ESP Base Timer",
    Default = false,
    Callback = function(state)
        ToggleStates["ESP Base Timer"] = state
        save()
        toggleBaseTimerESP(state)
        Notification.new({
            Title = "ESP Base Timer",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

BaseESPSection:NewToggle({
    Title = "ESP Best Brainrot",
    Default = false,
    Callback = function(state)
        ToggleStates["ESP Best Brainrot"] = state
        save()
        toggleBestBrainrotESP(state)
        Notification.new({
            Title = "ESP Best Brainrot",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

BaseESPSection:NewToggle({
    Title = "X-Ray Base",
    Default = false,
    Callback = function(state)
        ToggleStates["X-Ray Base"] = state
        save()
        toggleXRay(state)
        Notification.new({
            Title = "X-Ray Base",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

BaseESPSection:NewToggle({
    Title = "Base ESP",
    Default = false,
    Callback = function(state)
        ToggleStates["Base ESP"] = state
        save()
        if state then
            enableBaseESP()
        else
            disableBaseESP()
        end
        Notification.new({
            Title = "Base ESP",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

-- MISC TAB
UtilitySection:NewToggle({
    Title = "Jump Boost",
    Default = false,
    Callback = function(state)
        ToggleStates["Jump Boost"] = state
        save()
        toggleJumpBoost(state)
        Notification.new({
            Title = "Jump Boost",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

UtilitySection:NewToggle({
    Title = "Ultra Speed",
    Default = false,
    Callback = function(state)
        ToggleStates["Ultra Speed"] = state
        save()
        toggleUltraSpeed(state)
        Notification.new({
            Title = "Ultra Speed",
            Description = state and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

ServerSection:NewButton({
    Title = "Rejoin",
    Callback = function()
        toggleRejoin(true)
        Notification.new({
            Title = "Rejoin",
            Description = "Rejoining game...",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

ServerSection:NewButton({
    Title = "Server Hop",
    Callback = function()
        toggleServerHop(true)
        Notification.new({
            Title = "Server Hop",
            Description = "Changing servers...",
            Duration = 3,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

-- CREDITS TAB
CreditsSection:NewTitle("Made By JS7 ðŸ‘‘")
CreditsSection:NewTitle("Big thanks to: Sr Perfect")
CreditsSection:NewTitle("Version: 1.0")
CreditsSection:NewTitle("Join our Discord for updates!")

CreditsSection:NewButton({
    Title = "Join Discord",
    Callback = function()
        local link = 'https://discord.gg/k5Cg4pGXn2'
        setclipboard(link)
        Notification.new({
            Title = "Discord",
            Description = "Link copied to clipboard!",
            Duration = 5,
            Icon = "rbxassetid://8997385628"
        })
    end,
})

InfoSection:NewTitle("UI by 4lpaca")
InfoSection:NewTitle("Credits Feito Por JS7 ðŸ‘‘")
InfoSection:NewTitle("Com ajuda de Sr Perfect")
InfoSection:NewTitle("Server nenhum")

Notification.new({
    Title = "-JS7 ðŸ‘‘ HUB --",
    Description = "All features loaded successfully!",
    Duration = 5,
    Icon = "rbxassetid://8997385628"
})

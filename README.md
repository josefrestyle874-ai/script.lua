-- ====================
-- SISTEMA DE KEY AUTH JS7
-- ====================
local KeySystem = {
    KeysTemporarias = {},  -- Chaves temporárias (1 uso)
    KeysPermanentes = {},  -- Chaves permanentes
    KeyUsada = false,      -- Se já usou uma key nesta sessão
    KeyAtual = nil,        -- Key atual sendo usada
    KeyTipo = nil,         -- Tipo da key (PERMANENTE/TEMPORARIA)
}

-- CONFIGURAÇÕES DAS KEYS (ALTERE AQUI)
KeySystem.KeysPermanentes = {
    ["JS7-PERMA-MASTER-2024"] = true,
    ["JS7-VIP-PERMANENTE"] = true,
    ["JS7-DEV-ACCESS"] = true,
}

-- KEYS TEMPORÁRIAS (Adicione aqui as keys que você gerar)
KeySystem.KeysTemporarias = {
    -- Exemplo: "JS7-TEMP-ABC123-1735432100"
    -- Formato: JS7-TEMP-XXXXXX-TIMESTAMP
}

-- FUNÇÃO PARA VERIFICAR KEY
function KeySystem:VerificarKey(key)
    -- Limpar espaços e maiúsculas
    key = string.upper(string.gsub(key, "%s+", ""))
    
    -- Verificar se já usou uma key
    if self.KeyUsada then
        return true, "JA_AUTENTICADO"
    end
    
    -- Verificar se é permanente (começa com JS7-PERMA)
    if string.find(key, "^JS7%-PERMA") then
        if self.KeysPermanentes[key] then
            self.KeyUsada = true
            self.KeyAtual = key
            self.KeyTipo = "PERMANENTE"
            return true, "PERMANENTE"
        end
    end
    
    -- Verificar se é temporária (começa com JS7-TEMP)
    if string.find(key, "^JS7%-TEMP") then
        for i, tempKey in pairs(self.KeysTemporarias) do
            if tempKey == key then
                table.remove(self.KeysTemporarias, i)
                self.KeyUsada = true
                self.KeyAtual = key
                self.KeyTipo = "TEMPORARIA"
                return true, "TEMPORARIA"
            end
        end
    end
    
    -- Verificar se é teste (JS7-TESTE)
    if key == "JS7-TESTE-ACESSO" then
        self.KeyUsada = true
        self.KeyAtual = key
        self.KeyTipo = "TESTE"
        return true, "TESTE"
    end
    
    return false, "INVALIDA"
end

-- FUNÇÃO PARA GERAR KEY TEMPORÁRIA JS7
function KeySystem:GerarKeyTemporaria()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomPart = ""
    
    for i = 1, 8 do
        local rand = math.random(1, #charset)
        randomPart = randomPart .. charset:sub(rand, rand)
    end
    
    local timestamp = os.time()
    local key = "JS7-TEMP-" .. randomPart .. "-" .. timestamp
    
    -- Adicionar à lista de keys temporárias
    table.insert(self.KeysTemporarias, key)
    
    -- Gerar informações
    local data = os.date("%d/%m/%Y %H:%M:%S")
    local link = "js7hub://activate?key=" .. key
    
    print("\n╔══════════════════════════════════════════════╗")
    print("║           KEY JS7 GERADA COM SUCESSO!         ║")
    print("╠══════════════════════════════════════════════╣")
    print("║ KEY: " .. key)
    print("╠══════════════════════════════════════════════╣")
    print("║ DATA GERADA: " .. data)
    print("║ TIPO: TEMPORÁRIA (1 USO)                     ║")
    print("║ LINK: " .. link)
    print("╠══════════════════════════════════════════════╣")
    print("║ COMO ADICIONAR AO SCRIPT:                    ║")
    print("║ Adicione esta linha em KeysTemporarias:      ║")
    print("║ [\"" .. key .. "\"] = true,                  ║")
    print("╚══════════════════════════════════════════════╝\n")
    
    -- Copiar para área de transferência
    if setclipboard then
        setclipboard(key)
        print("[INFO] Key copiada para área de transferência!")
    end
    
    return key, link, data
end

-- FUNÇÃO PARA GERAR KEY PERMANENTE JS7
function KeySystem:GerarKeyPermanente(tipo)
    tipo = tipo or "VIP"
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomPart = ""
    
    for i = 1, 10 do
        local rand = math.random(1, #charset)
        randomPart = randomPart .. charset:sub(rand, rand)
    end
    
    local key = "JS7-PERMA-" .. tipo .. "-" .. randomPart
    local data = os.date("%d/%m/%Y %H:%M:%S")
    
    print("\n╔══════════════════════════════════════════════╗")
    print("║         KEY PERMANENTE JS7 GERADA!           ║")
    print("╠══════════════════════════════════════════════╣")
    print("║ KEY: " .. key)
    print("╠══════════════════════════════════════════════╣")
    print("║ DATA GERADA: " .. data)
    print("║ TIPO: PERMANENTE                             ║")
    print("║ CATEGORIA: " .. tipo)
    print("╠══════════════════════════════════════════════╣")
    print("║ COMO ADICIONAR AO SCRIPT:                    ║")
    print("║ Adicione esta linha em KeysPermanentes:      ║")
    print("║ [\"" .. key .. "\"] = true,                  ║")
    print("╚══════════════════════════════════════════════╝\n")
    
    if setclipboard then
        setclipboard(key)
    end
    
    return key, data
end

-- ====================
-- TELA DE LOGIN JS7
-- ====================
local function CriarTelaLogin()
    local loginGui = Instance.new("ScreenGui")
    loginGui.Name = "JS7HubLogin"
    loginGui.ResetOnSpawn = false
    loginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loginGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Fundo escuro
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    background.Parent = loginGui
    
    -- Container principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 280)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = loginGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "JS7 HUB - AUTENTICAÇÃO"
    title.Font = Enum.Font.Arcade
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.Parent = mainFrame
    
    -- Sub-título
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 40)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Digite sua key de acesso"
    subtitle.Font = Enum.Font.SourceSans
    subtitle.TextSize = 14
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    subtitle.Parent = mainFrame
    
    -- Campo de input
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "InputFrame"
    inputFrame.Size = UDim2.new(0, 300, 0, 40)
    inputFrame.Position = UDim2.new(0.5, -150, 0.5, -20)
    inputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = mainFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "KeyInput"
    inputBox.Size = UDim2.new(1, -20, 1, 0)
    inputBox.Position = UDim2.new(0, 10, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.Text = ""
    inputBox.PlaceholderText = "Digite sua key JS7 aqui..."
    inputBox.Font = Enum.Font.Code
    inputBox.TextSize = 14
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = inputFrame
    
    -- Botão de entrar
    local enterButton = Instance.new("TextButton")
    enterButton.Name = "EnterButton"
    enterButton.Size = UDim2.new(0, 120, 0, 35)
    enterButton.Position = UDim2.new(0.5, -60, 0.7, 0)
    enterButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    enterButton.BorderSizePixel = 0
    enterButton.Text = "ENTRAR"
    enterButton.Font = Enum.Font.Arcade
    enterButton.TextSize = 16
    enterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    enterButton.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = enterButton
    
    -- Mensagem de status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 0.85, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Aguardando key..."
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 12
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextWrapped = true
    statusLabel.Parent = mainFrame
    
    -- Informações
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "Info"
    infoLabel.Size = UDim2.new(1, -40, 0, 40)
    infoLabel.Position = UDim2.new(0, 20, 0.9, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Formato: JS7-TEMP-XXXX ou JS7-PERMA-XXXX"
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 11
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    infoLabel.TextWrapped = true
    infoLabel.Parent = mainFrame
    
    -- Função de verificação
    enterButton.MouseButton1Click:Connect(function()
        local key = inputBox.Text
        if key == "" then
            statusLabel.Text = "Digite uma key!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        enterButton.Text = "VERIFICANDO..."
        enterButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        local sucesso, tipo = KeySystem:VerificarKey(key)
        
        if sucesso then
            if tipo == "JA_AUTENTICADO" then
                statusLabel.Text = "Você já está autenticado!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
                task.wait(1)
            else
                statusLabel.Text = "✓ KEY " .. tipo .. " ACEITA!"
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                enterButton.Text = "ACESSANDO..."
                enterButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                
                -- Efeito visual de sucesso
                for i = 1, 10 do
                    mainFrame.BackgroundTransparency = 0.1 + (i * 0.09)
                    task.wait(0.03)
                end
                
                -- Fechar tela de login
                task.wait(0.5)
                loginGui:Destroy()
                
                -- Iniciar o hub principal
                return true
            end
        else
            statusLabel.Text = "✗ KEY INVÁLIDA OU EXPIRADA"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            enterButton.Text = "ENTRAR"
            enterButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
            
            -- Efeito de erro
            inputFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(0.2)
            inputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        end
        
        enterButton.Text = "ENTRAR"
        enterButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        return false
    end)
    
    -- Foco automático no input
    inputBox:CaptureFocus()
    
    -- Retornar referências
    return {
        Gui = loginGui,
        Input = inputBox,
        Button = enterButton,
        Status = statusLabel
    }
end

-- ====================
-- PAINEL PRINCIPAL JS7
-- ====================
local function CriarPainelPrincipal()
    -- SERVIÇOS
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- PLAYER
    local LocalPlayer = Players.LocalPlayer

    -- CONTROLES
    local toggleStatus = {
        ESPBase = false,
        DesyncV3 = false,
        JumpBoost = false,
        Teleguiado = false,
    }

    -- GUI PRINCIPAL
    local gui = Instance.new("ScreenGui")
    gui.Name = "JS7HubV2"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- BOTÃO FLUTUANTE
    local float = Instance.new("ImageButton", gui)
    float.Size = UDim2.new(0, 55, 0, 55)
    float.Position = UDim2.new(0, 15, 0.5, -27)
    float.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    float.BackgroundTransparency = 0.4
    float.BorderSizePixel = 0
    float.Image = "rbxassetid://101332224741678"  -- Sua imagem
    float.ScaleType = Enum.ScaleType.Fit

    -- Deixar redondo
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)

    -- Arrastável
    do
        local drag, startPos, startUI
        float.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                drag = true
                startPos = i.Position
                startUI = float.Position
            end
        end)
        float.InputEnded:Connect(function() drag = false end)
        game:GetService("UserInputService").InputChanged:Connect(function(i)
            if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local delta = i.Position - startPos
                float.Position = UDim2.new(startUI.X.Scale, startUI.X.Offset + delta.X, startUI.Y.Scale, startUI.Y.Offset + delta.Y)
            end
        end)
    end

    -- PAINEL
    local menu = Instance.new("Frame", gui)
    menu.Size = UDim2.new(0, 144, 0, 208)
    menu.Position = UDim2.new(0.5, -72, 0.5, -104)
    menu.BackgroundColor3 = Color3.fromRGB(15,15,18)
    menu.BackgroundTransparency = 0.35
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.Active = true
    menu.Draggable = true
    Instance.new("UICorner", menu).CornerRadius = UDim.new(0,14)

    local title = Instance.new("TextLabel", menu)
    title.Size = UDim2.new(1,0,0,25)
    title.Position = UDim2.new(0,0,0,2)
    title.BackgroundTransparency = 1
    title.Text = "JS7 HUB"
    title.Font = Enum.Font.Arcade
    title.TextSize = 11
    title.TextColor3 = Color3.fromRGB(0,255,255)

    float.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)

    -- FUNÇÃO PARA CRIAR BOTÕES
    local function addBtn(text,size,pos,isAltColor,subText,callback)
        local b = Instance.new("TextButton", menu)
        b.Size = size
        b.Position = pos
        b.Text = text or ""
        b.Font = Enum.Font.Arcade
        b.TextSize = 8
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.TextWrapped = true
        b.BackgroundColor3 = isAltColor and Color3.fromRGB(0,255,255) or Color3.fromRGB(30,30,35)
        b.BackgroundTransparency = 0.6
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

        local s = Instance.new("UIStroke", b)
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Color = Color3.fromRGB(0,0,0)
        s.Thickness = 1.2
        s.Transparency = 0.2

        if subText then
            local sub = Instance.new("TextLabel", b)
                sub.Size = UDim2.new(1,0,0,8)
                sub.Position = UDim2.new(0,0,0.6,0)
                sub.BackgroundTransparency = 1
                sub.Text = subText
                sub.TextColor3 = Color3.fromRGB(0,255,255)
                sub.Font = Enum.Font.Arcade
                sub.TextSize = 4
        end

        if callback then
            b.MouseButton1Click:Connect(function()
                local active = callback()
                b.BackgroundColor3 = active and Color3.fromRGB(0,170,255) or (isAltColor and Color3.fromRGB(0,255,255) or Color3.fromRGB(30,30,35))
            end)
        end

        return b
    end

    -- POSIÇÕES
    local Y_START = 0.14
    local Y_GAP = 0.165
    local BTN_H = 31

    -- BOTÕES DO PAINEL
    local espBaseBtn = addBtn("ESP BASE", UDim2.new(0,64,0,BTN_H), UDim2.new(0.04,0,Y_START,0), false, nil, function()
        toggleStatus.ESPBase = not toggleStatus.ESPBase
        local active = toggleStatus.ESPBase

        -- ===========================
        -- FEATURE : BASE ESP
        -- ===========================
        if active then
            if not _G.SAB then _G.SAB = {} end
            if not _G.SAB.BigPlotTimers then
                _G.SAB.BigPlotTimers = {enabled=false,isRunning=false}
            end
            local plotTimers = _G.SAB.BigPlotTimers
            function plotTimers:Toggle(enable)
                if enable and not self.isRunning then
                    self.enabled = true
                elseif not enable and self.enabled then
                    self.enabled = false
                end
                self.isRunning = true
                task.spawn(function()
                    while task.wait() and self.enabled do
                        pcall(function()
                            for _, plot in Workspace.Plots:GetChildren() do
                                if plot:FindFirstChild("Purchases") and plot.Purchases:FindFirstChild("PlotBlock") then
                                    local plotBlock = plot.Purchases.PlotBlock
                                    if plotBlock:FindFirstChild("Main") then
                                        local main = plotBlock.Main
                                        if main:FindFirstChild("BillboardGui") then
                                            local billboard = main.BillboardGui
                                            billboard.AlwaysOnTop = true
                                            billboard.MaxDistance = 1000
                                            billboard.Size = UDim2.fromScale(35,50)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    pcall(function()
                        for _, plot in Workspace.Plots:GetChildren() do
                            if plot:FindFirstChild("Purchases") and plot.Purchases:FindFirstChild("PlotBlock") then
                                local plotBlock = plot.Purchases.PlotBlock
                                if plotBlock:FindFirstChild("Main") then
                                    local main = plotBlock.Main
                                    if main:FindFirstChild("BillboardGui") then
                                        local billboard = main.BillboardGui
                                        billboard.AlwaysOnTop = false
                                        billboard.MaxDistance = 60
                                        billboard.Size = UDim2.fromScale(7,10)
                                    end
                                end
                            end
                        end
                    end)
                    self.isRunning = false
                end)
            end
            plotTimers:Toggle(true)
        end

        return active
    end)

    local desyncBtn = addBtn("DESYNC V3", UDim2.new(0,64,0,BTN_H), UDim2.new(0.51,0,Y_START,0), false, nil, function()
        toggleStatus.DesyncV3 = not toggleStatus.DesyncV3
        local active = toggleStatus.DesyncV3

        if active then
           local FFlags = { GameNetPVHeaderRotationalVelocityZeroCutoffExponent=-5000,LargeReplicatorWrite5=true,LargeReplicatorEnabled9=true,AngularVelociryLimit=360,TimestepArbiterVelocityCriteriaThresholdTwoDt=2147483646,S2PhysicsSenderRate=15000,DisableDPIScale=true,MaxDataPacketPerSend=2147483647,PhysicsSenderMaxBandwidthBps=20000,TimestepArbiterHumanoidLinearVelThreshold=21,MaxMissedWorldStepsRemembered=-2147483648,PlayerHumanoidPropertyUpdateRestrict=true,SimDefaultHumanoidTimestepMultiplier=0,StreamJobNOUVolumeLengthCap=2147483647,DebugSendDistInSteps=-2147483648,GameNetDontSendRedundantNumTimes=1,CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent=1,CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth=1,LargeReplicatorSerializeRead3=true,ReplicationFocusNouExtentsSizeCutoffForPauseStuds=2147483647,CheckPVCachedVelThresholdPercent=10,CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth=1,GameNetDontSendRedundantDeltaPositionMillionth=1,InterpolationFrameVelocityThresholdMillionth=5,StreamJobNOUVolumeCap=2147483647,InterpolationFrameRotVelocityThresholdMillionth=5,CheckPVCachedRotVelThresholdPercent=10,WorldStepMax=30,InterpolationFramePositionThresholdMillionth=5,TimestepArbiterHumanoidTurningVelThreshold=1,SimOwnedNOUCountThresholdMillionth=2147483647,GameNetPVHeaderLinearVelocityZeroCutoffExponent=-5000,NextGenReplicatorEnabledWrite4=true,TimestepArbiterOmegaThou=1073741823,MaxAcceptableUpdateDelay=1,LargeReplicatorSerializeWrite4=true }
            local player = Players.LocalPlayer
            local function respawnar(plr)
                local rcdEnabled, wasHidden = false,false
                if gethidden then rcdEnabled,wasHidden=gethidden(workspace,'RejectCharacterDeletions')~=Enum.RejectCharacterDeletions.Disabled end
                if rcdEnabled and replicatesignal then
                    replicatesignal(plr.ConnectDiedSignalBackend)
                    task.wait(Players.RespawnTime-0.1)
                    replicatesignal(plr.Kill)
                else
                    local char = plr.Character
                    local hum = char:FindFirstChildWhichIsA('Humanoid')
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
                    char:ClearAllChildren()
                    local newChar = Instance.new('Model')
                    newChar.Parent = workspace
                    plr.Character = newChar
                    task.wait()
                    plr.Character = char
                    newChar:Destroy()
                end
            end
            for name,value in pairs(FFlags) do pcall(function() setfflag(tostring(name),tostring(value)) end) end
            respawnar(player)
        end

        return active
    end)

    local jumpBoostBtn = addBtn("JUMP BOOST", UDim2.new(0,133,0,BTN_H), UDim2.new(0.04,0,Y_START+Y_GAP,0), false, nil, function()
        toggleStatus.JumpBoost = not toggleStatus.JumpBoost
        local active = toggleStatus.JumpBoost

        if active then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = 65
                humanoid.UseJumpPower = true
            end
        else
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = 50
            end
        end

        return active
    end)

    local teleguiadoBtn = addBtn("TELEGUIADO", UDim2.new(0,133,0,BTN_H), UDim2.new(0.04,0,Y_START+Y_GAP*2,0), false, nil, function()
        toggleStatus.Teleguiado = not toggleStatus.Teleguiado
        local active = toggleStatus.Teleguiado

        if active then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if hrp and cam then
                RunService.Heartbeat:Connect(function()
                    if toggleStatus.Teleguiado then
                        local moveDir = cam.CFrame.LookVector * 22
                        hrp.AssemblyLinearVelocity = moveDir
                    end
                end)
            end
        else
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
            end
        end

        return active
    end)

    -- BOTÃO COM INFO DA KEY
    local keyInfoBtn = addBtn("KEY INFO", UDim2.new(0,64,0,20), UDim2.new(0.04,0,1, -30), true, nil, function()
        local keyType = KeySystem.KeyTipo or "NÃO IDENTIFICADA"
        local keyText = KeySystem.KeyAtual or "NENHUMA"
        
        -- Mostrar informações
        local message = "TIPO: " .. keyType .. "\nKEY: " .. keyText
        
        -- Criar popup de informações
        local popup = Instance.new("Frame", gui)
        popup.Size = UDim2.new(0, 250, 0, 120)
        popup.Position = UDim2.new(0.5, -125, 0.5, -60)
        popup.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        popup.BorderSizePixel = 0
        
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 10)
        
        local title = Instance.new("TextLabel", popup)
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Text = "INFORMAÇÕES DA KEY"
        title.Font = Enum.Font.Arcade
        title.TextSize = 14
        title.TextColor3 = Color3.fromRGB(0, 170, 255)
        title.BackgroundTransparency = 1
        
        local info = Instance.new("TextLabel", popup)
        info.Size = UDim2.new(1, -20, 0, 60)
        info.Position = UDim2.new(0, 10, 0, 35)
        info.Text = message
        info.Font = Enum.Font.Code
        info.TextSize = 12
        info.TextColor3 = Color3.fromRGB(255, 255, 255)
        info.BackgroundTransparency = 1
        info.TextWrapped = true
        
        local closeBtn = Instance.new("TextButton", popup)
        closeBtn.Size = UDim2.new(0, 80, 0, 25)
        closeBtn.Position = UDim2.new(0.5, -40, 1, -30)
        closeBtn.Text = "FECHAR"
        closeBtn.Font = Enum.Font.Arcade
        closeBtn.TextSize = 12
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
        
        closeBtn.MouseButton1Click:Connect(function()
            popup:Destroy()
        end)
        
        -- Fechar automaticamente após 5 segundos
        task.delay(5, function()
            if popup and popup.Parent then
                popup:Destroy()
            end
        end)
        
        return false
    end)
    keyInfoBtn.TextColor3 = Color3.fromRGB(0, 255, 255)

    -- BOTÃO DISCORD
    local discordBtn = addBtn("DISCORD", UDim2.new(0,64,0,20), UDim2.new(0.51,0,1, -30), true, nil, function()
        if setclipboard then
            setclipboard("https://discord.gg/55BBE7czB")
            
            -- Feedback visual
            discordBtn.Text = "COPIADO!"
            discordBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            task.wait(1)
            discordBtn.Text = "DISCORD"
            discordBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        end
        return false
    end)
    discordBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    
    return gui
end

-- ====================
-- INICIALIZAÇÃO
-- ====================
local function IniciarSistema()
    -- Verificar se já está autenticado
    if KeySystem.KeyUsada then
        print("[JS7 HUB] Já autenticado, iniciando painel...")
        CriarPainelPrincipal()
        return
    end
    
    -- Criar tela de login
    local telaLogin = CriarTelaLogin()
    
    -- Quando o usuário fechar a tela sem autenticar
    telaLogin.Gui.Destroying:Connect(function()
        if not KeySystem.KeyUsada then
            print("[JS7 HUB] Autenticação cancelada")
            -- Pode adicionar aqui uma mensagem ou ação
        end
    end)
    
    -- Configurar tecla Enter para confirmar
    telaLogin.Input:GetPropertyChangedSignal("Text"):Connect(function()
        if #telaLogin.Input.Text > 0 then
            telaLogin.Status.Text = "Pressione ENTER para verificar"
            telaLogin.Status.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    telaLogin.Input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            telaLogin.Button:Clone().MouseButton1Click:Connect(function() end)
            telaLogin.Button.MouseButton1Click:Wait()
        end
    end)
    
    -- Esperar autenticação bem-sucedida
    repeat
        task.wait()
    until not telaLogin.Gui or not telaLogin.Gui.Parent or KeySystem.KeyUsada
    
    if KeySystem.KeyUsada then
        print("[JS7 HUB] Autenticação bem-sucedida!")
        print("[JS7 HUB] Tipo: " .. (KeySystem.KeyTipo or "DESCONHECIDO"))
        print("[JS7 HUB] Key: " .. (KeySystem.KeyAtual or "NENHUMA"))
        
        -- Criar painel principal
        CriarPainelPrincipal()
    end
end

-- ====================
-- FUNÇÕES PARA O ADMIN
-- ====================
-- Para gerar uma key temporária (execute no console):
-- KeySystem:GerarKeyTemporaria()

-- Para gerar uma key permanente (execute no console):
-- KeySystem:GerarKeyPermanente("VIP") -- Pode ser "VIP", "MASTER", "DEV", etc.

-- ====================
-- EXECUTAR SISTEMA
-- ====================
-- Iniciar o sistema
IniciarSistema()

-- Exemplo de como gerar keys manualmente:
print("\n╔══════════════════════════════════════════════╗")
print("║          SISTEMA JS7 HUB CARREGADO!          ║")
print("╠══════════════════════════════════════════════╣")
print("║ COMANDOS DISPONÍVEIS:                        ║")
print("║ • KeySystem:GerarKeyTemporaria()             ║")
print("║ • KeySystem:GerarKeyPermanente(\"VIP\")      ║")
print("╚══════════════════════════════════════════════╝\n")

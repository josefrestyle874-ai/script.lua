-- ====================================================
-- JS7 HUB VIP - SISTEMA COMPLETO DE AUTENTICAÇÃO
-- Versão: 2.0 | Data: 29/12/2024
-- ====================================================

-- SERVIÇOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- PLAYER
local LocalPlayer = Players.LocalPlayer

-- ====================
-- SISTEMA DE KEYS JS7
-- ====================
local KeySystem = {
    -- SEU BANCO DE DADOS DE KEYS (ALTERE AQUI!)
    KeysDatabase = {
        -- KEYS PERMANENTES (Múltiplos usos)
        Permanentes = {
            ["JS7-PERMA-MASTER-2024"] = {
                tipo = "PERMANENTE",
                nome = "MASTER VIP",
                criador = "ADMIN",
                data = "29/12/2024",
                usos = 0,
                usos_max = 9999
            },
            ["JS7-PERMA-DEV"] = {
                tipo = "PERMANENTE", 
                nome = "DEVELOPER",
                criador = "ADMIN",
                data = "29/12/2024",
                usos = 0,
                usos_max = 9999
            }
        },
        
        -- KEYS TEMPORÁRIAS (1 USO CADA - ADICIONE AQUI AS QUE VOCÊ GERAR)
        Temporarias = {
            -- Exemplo: ["JS7-TEMP-ABC123XYZ"] = {tipo = "TEMPORARIA", usada = false, usuario = nil, data_uso = nil}
        },
        
        -- KEYS VIP (7 DIAS)
        VIP = {
            -- Exemplo: ["JS7-VIP7-ABC123"] = {tipo = "VIP_7DIAS", expira = os.time() + 604800, usada = false}
        },
        
        -- ESTATÍSTICAS
        Stats = {
            total_keys = 0,
            keys_usadas = 0,
            keys_ativas = 0,
            usuarios = {}
        }
    },
    
    -- CONTROLE DA SESSÃO
    Autenticado = false,
    KeyInfo = nil,
    KeyTipo = nil,
    
    -- CONFIGURAÇÕES
    SiteGerador = "https://sites.google.com/view/js7hub-keys", -- SEU SITE AQUI
    DiscordSuporte = "https://discord.gg/js7hub",
    Versao = "2.0"
}

-- ====================
-- FUNÇÕES DO SISTEMA
-- ====================

-- VERIFICAR SE UMA KEY JÁ FOI USADA
function KeySystem:KeyJaUsada(key)
    -- Verificar em temporárias
    if self.KeysDatabase.Temporarias[key] then
        return self.KeysDatabase.Temporarias[key].usada
    end
    
    -- Verificar em VIP
    if self.KeysDatabase.VIP[key] then
        return self.KeysDatabase.VIP[key].usada
    end
    
    return false
end

-- REGISTRAR USO DA KEY
function KeySystem:RegistrarUso(key, usuario)
    local keyData = nil
    
    -- Encontrar a key
    if self.KeysDatabase.Permanentes[key] then
        keyData = self.KeysDatabase.Permanentes[key]
        keyData.usos = (keyData.usos or 0) + 1
    elseif self.KeysDatabase.Temporarias[key] then
        keyData = self.KeysDatabase.Temporarias[key]
        keyData.usada = true
        keyData.usuario = usuario
        keyData.data_uso = os.date("%d/%m/%Y %H:%M:%S")
        self.KeysDatabase.Stats.keys_usadas = self.KeysDatabase.Stats.keys_usadas + 1
    elseif self.KeysDatabase.VIP[key] then
        keyData = self.KeysDatabase.VIP[key]
        keyData.usada = true
        keyData.usuario = usuario
        keyData.data_uso = os.date("%d/%m/%Y %H:%M:%S")
        self.KeysDatabase.Stats.keys_usadas = self.KeysDatabase.Stats.keys_usadas + 1
    end
    
    -- Registrar usuário
    if usuario and not self.KeysDatabase.Stats.usuarios[usuario] then
        self.KeysDatabase.Stats.usuarios[usuario] = {
            primeira_vez = os.date("%d/%m/%Y %H:%M:%S"),
            ultimo_acesso = os.date("%d/%m/%Y %H:%M:%S"),
            keys_usadas = 1
        }
    elseif usuario then
        self.KeysDatabase.Stats.usuarios[usuario].ultimo_acesso = os.date("%d/%m/%Y %H:%M:%S")
        self.KeysDatabase.Stats.usuarios[usuario].keys_usadas = 
            (self.KeysDatabase.Stats.usuarios[usuario].keys_usadas or 0) + 1
    end
    
    return keyData
end

-- VERIFICAR KEY
function KeySystem:VerificarKey(key)
    -- Limpar e formatar key
    key = string.upper(string.gsub(key, "%s+", ""))
    
    -- Verificar formato básico
    if not string.find(key, "^JS7%-") then
        return false, "FORMATO_INVALIDO", "Key deve começar com JS7-"
    end
    
    -- Verificar se é permanente
    if self.KeysDatabase.Permanentes[key] then
        local keyData = self.KeysDatabase.Permanentes[key]
        self:RegistrarUso(key, LocalPlayer.Name)
        
        self.KeyInfo = {
            key = key,
            tipo = keyData.tipo,
            nome = keyData.nome,
            criador = keyData.criador,
            usos = keyData.usos,
            usos_max = keyData.usos_max
        }
        self.KeyTipo = "PERMANENTE"
        
        return true, "PERMANENTE", "Key permanente aceita!"
    end
    
    -- Verificar se é temporária
    if self.KeysDatabase.Temporarias[key] then
        if self:KeyJaUsada(key) then
            return false, "JA_USADA", "Esta key já foi utilizada!"
        end
        
        local keyData = self:RegistrarUso(key, LocalPlayer.Name)
        self.KeyInfo = {
            key = key,
            tipo = keyData.tipo,
            usuario = keyData.usuario,
            data_uso = keyData.data_uso
        }
        self.KeyTipo = "TEMPORARIA"
        
        return true, "TEMPORARIA", "Key temporária aceita! (1 uso)"
    end
    
    -- Verificar se é VIP
    if self.KeysDatabase.VIP[key] then
        if self:KeyJaUsada(key) then
            return false, "JA_USADA", "Esta key VIP já foi utilizada!"
        end
        
        local keyData = self:RegistrarUso(key, LocalPlayer.Name)
        self.KeyInfo = {
            key = key,
            tipo = keyData.tipo,
            expira = keyData.expira,
            dias_restantes = math.floor((keyData.expira - os.time()) / 86400)
        }
        self.KeyTipo = "VIP"
        
        return true, "VIP", "Key VIP aceita! (" .. self.KeyInfo.dias_restantes .. " dias restantes)"
    end
    
    -- Key de teste (para desenvolvimento)
    if key == "JS7-TESTE-ACESSO" then
        self.KeyInfo = {
            key = key,
            tipo = "TESTE",
            nome = "MODO TESTE"
        }
        self.KeyTipo = "TESTE"
        return true, "TESTE", "Modo teste ativado!"
    end
    
    return false, "NAO_ENCONTRADA", "Key não encontrada no sistema!"
end

-- ====================
-- TELA DE LOGIN
-- ====================
local function CriarTelaLogin()
    local loginGui = Instance.new("ScreenGui")
    loginGui.Name = "JS7HubLogin"
    loginGui.ResetOnSpawn = false
    loginGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Fundo com blur
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.3
    bg.Parent = loginGui
    
    -- Container principal
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 380, 0, 350)
    main.Position = UDim2.new(0.5, -190, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    main.Parent = loginGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = main
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 2
    stroke.Parent = main
    
    -- Efeito gradiente
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 50, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    gradient.Rotation = 90
    gradient.Parent = main
    
    -- Logo/Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🔐 JS7 HUB VIP"
    title.Font = Enum.Font.Arcade
    title.TextSize = 28
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    title.Parent = main
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Sistema de Autenticação"
    subtitle.Font = Enum.Font.SourceSans
    subtitle.TextSize = 14
    subtitle.TextColor3 = Color3.fromRGB(150, 200, 255)
    subtitle.Parent = main
    
    -- Campo de input
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 320, 0, 50)
    inputFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
    inputFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    inputFrame.Parent = main
    
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 10)
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(0, 100, 200)
    inputStroke.Thickness = 2
    inputStroke.Parent = inputFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 1, 0)
    inputBox.Position = UDim2.new(0, 10, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.PlaceholderText = "Digite sua key JS7 aqui..."
    inputBox.Text = ""
    inputBox.Font = Enum.Font.Code
    inputBox.TextSize = 16
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = inputFrame
    
    -- Botão de verificar
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0, 160, 0, 45)
    verifyBtn.Position = UDim2.new(0.5, -80, 0.5, 0)
    verifyBtn.Text = "🔑 VERIFICAR KEY"
    verifyBtn.Font = Enum.Font.Arcade
    verifyBtn.TextSize = 18
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    verifyBtn.Parent = main
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = verifyBtn
    
    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
    })
    btnGradient.Rotation = 90
    btnGradient.Parent = verifyBtn
    
    -- Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 50)
    statusLabel.Position = UDim2.new(0, 20, 0.65, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Aguardando key..."
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 14
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    statusLabel.TextWrapped = true
    statusLabel.Parent = main
    
    -- Botão para obter key
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0, 200, 0, 40)
    getKeyBtn.Position = UDim2.new(0.5, -100, 0.8, 0)
    getKeyBtn.Text = "🌐 OBTER KEY NO SITE"
    getKeyBtn.Font = Enum.Font.Arcade
    getKeyBtn.TextSize = 14
    getKeyBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    getKeyBtn.Parent = main
    
    Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 8)
    
    -- Informações
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 40)
    infoLabel.Position = UDim2.new(0, 20, 0.9, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Cada key é única! 1 key = 1 usuário"
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 12
    infoLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    infoLabel.Parent = main
    
    -- FUNCIONALIDADES
    getKeyBtn.MouseButton1Click:Connect(function()
        statusLabel.Text = "📋 Link copiado! Cole no navegador:\n" .. KeySystem.SiteGerador
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
        
        if setclipboard then
            setclipboard(KeySystem.SiteGerador)
        end
    end)
    
    verifyBtn.MouseButton1Click:Connect(function()
        local key = inputBox.Text
        if key == "" then
            statusLabel.Text = "❌ Digite uma key!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        verifyBtn.Text = "⏳ VERIFICANDO..."
        verifyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
        
        local sucesso, tipo, mensagem = KeySystem:VerificarKey(key)
        
        if sucesso then
            KeySystem.Autenticado = true
            
            statusLabel.Text = "✅ " .. mensagem
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            verifyBtn.Text = "✓ ACESSO CONCEDIDO"
            verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            
            -- Efeito de transição
            for i = 1, 20 do
                main.BackgroundTransparency = i/20
                task.wait(0.02)
            end
            
            task.wait(0.5)
            loginGui:Destroy()
            return true
        else
            statusLabel.Text = "❌ " .. mensagem
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            verifyBtn.Text = "🔑 VERIFICAR KEY"
            verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            
            -- Efeito de erro
            inputFrame.UIStroke.Color = Color3.fromRGB(255, 50, 50)
            task.wait(0.3)
            inputFrame.UIStroke.Color = Color3.fromRGB(0, 100, 200)
        end
        
        return false
    end)
    
    -- Tecla Enter para confirmar
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            verifyBtn:Clone().MouseButton1Click:Connect(function() end)
            verifyBtn.MouseButton1Click:Wait()
        end
    end)
    
    -- Foco automático
    task.wait(0.5)
    inputBox:CaptureFocus()
    
    return loginGui
end

-- ====================
-- CONTROLES DO HUB
-- ====================
local toggleStatus = {
    ESPBase = false,
    DesyncV3 = false,
    JumpBoost = false,
    Teleguiado = false,
}

-- ====================
-- PAINEL PRINCIPAL
-- ====================
local function CriarPainelPrincipal()
    -- GUI PRINCIPAL
    local gui = Instance.new("ScreenGui")
    gui.Name = "JS7HubV2"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- BOTÃO FLUTUANTE
    local float = Instance.new("ImageButton", gui)
    float.Size = UDim2.new(0, 60, 0, 60)
    float.Position = UDim2.new(0, 20, 0.5, -30)
    float.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
    float.BackgroundTransparency = 0.3
    float.BorderSizePixel = 0
    float.Image = "rbxassetid://101332224741678"
    float.ScaleType = Enum.ScaleType.Fit

    -- Deixar redondo
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
    
    -- Brilho no botão
    local glow = Instance.new("UIStroke")
    glow.Color = Color3.fromRGB(0, 200, 255)
    glow.Thickness = 2
    glow.Transparency = 0.5
    glow.Parent = float

    -- Arrastável
    local drag, startPos, startUI
    float.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            startPos = i.Position
            startUI = float.Position
        end
    end)
    
    float.InputEnded:Connect(function() 
        drag = false 
    end)
    
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - startPos
            float.Position = UDim2.new(
                startUI.X.Scale, 
                startUI.X.Offset + delta.X,
                startUI.Y.Scale, 
                startUI.Y.Offset + delta.Y
            )
        end
    end)

    -- PAINEL PRINCIPAL
    local menu = Instance.new("Frame", gui)
    menu.Size = UDim2.new(0, 180, 0, 250)
    menu.Position = UDim2.new(0.5, -90, 0.5, -125)
    menu.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
    menu.BackgroundTransparency = 0.2
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.Active = true
    menu.Draggable = true
    
    local menuCorner = Instance.new("UICorner", menu)
    menuCorner.CornerRadius = UDim.new(0, 12)
    
    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color = Color3.fromRGB(0, 150, 255)
    menuStroke.Thickness = 2
    menuStroke.Parent = menu
    
    -- Gradiente do menu
    local menuGradient = Instance.new("UIGradient")
    menuGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 30, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 20))
    })
    menuGradient.Rotation = 45
    menuGradient.Parent = menu

    -- Título
    local title = Instance.new("TextLabel", menu)
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "⚡ JS7 HUB"
    title.Font = Enum.Font.Arcade
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.TextStrokeTransparency = 0.8
    
    -- Subtítulo (tipo da key)
    local keyTypeLabel = Instance.new("TextLabel", menu)
    keyTypeLabel.Size = UDim2.new(1, 0, 0, 15)
    keyTypeLabel.Position = UDim2.new(0, 0, 0, 35)
    keyTypeLabel.BackgroundTransparency = 1
    keyTypeLabel.Text = KeySystem.KeyInfo and KeySystem.KeyInfo.nome or "VIP"
    keyTypeLabel.Font = Enum.Font.SourceSans
    keyTypeLabel.TextSize = 11
    keyTypeLabel.TextColor3 = Color3.fromRGB(150, 255, 255)

    -- Botão flutuante abre/fecha menu
    float.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)

    -- FUNÇÃO PARA CRIAR BOTÕES
    local function addBtn(text, size, pos, isAltColor, subText, callback)
        local b = Instance.new("TextButton", menu)
        b.Size = size
        b.Position = pos
        b.Text = text or ""
        b.Font = Enum.Font.Arcade
        b.TextSize = 10
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextWrapped = true
        b.BackgroundColor3 = isAltColor and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(20, 30, 50)
        b.BackgroundTransparency = 0.3
        b.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner", b)
        btnCorner.CornerRadius = UDim.new(0, 8)
        
        local btnStroke = Instance.new("UIStroke", b)
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        btnStroke.Color = Color3.fromRGB(0, 0, 0)
        btnStroke.Thickness = 1.5
        btnStroke.Transparency = 0.3

        if subText then
            local sub = Instance.new("TextLabel", b)
            sub.Size = UDim2.new(1, 0, 0, 10)
            sub.Position = UDim2.new(0, 0, 0.7, 0)
            sub.BackgroundTransparency = 1
            sub.Text = subText
            sub.TextColor3 = Color3.fromRGB(0, 255, 255)
            sub.Font = Enum.Font.Arcade
            sub.TextSize = 6
        end

        if callback then
            b.MouseButton1Click:Connect(function()
                local active = callback()
                b.BackgroundColor3 = active and Color3.fromRGB(0, 150, 255) or 
                                     (isAltColor and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(20, 30, 50))
            end)
        end

        return b
    end

    -- POSIÇÕES DOS BOTÕES
    local Y_START = 0.22
    local Y_GAP = 0.165
    local BTN_H = 35

    -- BOTÃO ESP BASE
    local espBaseBtn = addBtn("ESP BASE", UDim2.new(0, 80, 0, BTN_H), UDim2.new(0.05, 0, Y_START, 0), false, nil, function()
        toggleStatus.ESPBase = not toggleStatus.ESPBase
        local active = toggleStatus.ESPBase

        -- FEATURE: BASE ESP
        if active then
            if not _G.SAB then _G.SAB = {} end
            if not _G.SAB.BigPlotTimers then
                _G.SAB.BigPlotTimers = {enabled = false, isRunning = false}
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
                            for _, plot in workspace.Plots:GetChildren() do
                                if plot:FindFirstChild("Purchases") and plot.Purchases:FindFirstChild("PlotBlock") then
                                    local plotBlock = plot.Purchases.PlotBlock
                                    if plotBlock:FindFirstChild("Main") then
                                        local main = plotBlock.Main
                                        if main:FindFirstChild("BillboardGui") then
                                            local billboard = main.BillboardGui
                                            billboard.AlwaysOnTop = true
                                            billboard.MaxDistance = 1000
                                            billboard.Size = UDim2.fromScale(35, 50)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    
                    pcall(function()
                        for _, plot in workspace.Plots:GetChildren() do
                            if plot:FindFirstChild("Purchases") and plot.Purchases:FindFirstChild("PlotBlock") then
                                local plotBlock = plot.Purchases.PlotBlock
                                if plotBlock:FindFirstChild("Main") then
                                    local main = plotBlock.Main
                                    if main:FindFirstChild("BillboardGui") then
                                        local billboard = main.BillboardGui
                                        billboard.AlwaysOnTop = false
                                        billboard.MaxDistance = 60
                                        billboard.Size = UDim2.fromScale(7, 10)
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

    -- BOTÃO DESYNC V3
    local desyncBtn = addBtn("DESYNC V3", UDim2.new(0, 80, 0, BTN_H), UDim2.new(0.55, 0, Y_START, 0), false, nil, function()
        toggleStatus.DesyncV3 = not toggleStatus.DesyncV3
        local active = toggleStatus.DesyncV3

        if active then
            local FFlags = {
                GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
                LargeReplicatorWrite5 = true,
                LargeReplicatorEnabled9 = true,
                AngularVelociryLimit = 360,
                TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646,
                S2PhysicsSenderRate = 15000,
                DisableDPIScale = true,
                MaxDataPacketPerSend = 2147483647,
                PhysicsSenderMaxBandwidthBps = 20000,
                TimestepArbiterHumanoidLinearVelThreshold = 21,
                MaxMissedWorldStepsRemembered = -2147483648,
                PlayerHumanoidPropertyUpdateRestrict = true,
                SimDefaultHumanoidTimestepMultiplier = 0,
                StreamJobNOUVolumeLengthCap = 2147483647,
                DebugSendDistInSteps = -2147483648,
                GameNetDontSendRedundantNumTimes = 1,
                CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
                CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
                LargeReplicatorSerializeRead3 = true,
                ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
                CheckPVCachedVelThresholdPercent = 10,
                CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
                GameNetDontSendRedundantDeltaPositionMillionth = 1,
                InterpolationFrameVelocityThresholdMillionth = 5,
                StreamJobNOUVolumeCap = 2147483647,
                InterpolationFrameRotVelocityThresholdMillionth = 5,
                CheckPVCachedRotVelThresholdPercent = 10,
                WorldStepMax = 30,
                InterpolationFramePositionThresholdMillionth = 5,
                TimestepArbiterHumanoidTurningVelThreshold = 1,
                SimOwnedNOUCountThresholdMillionth = 2147483647,
                GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
                NextGenReplicatorEnabledWrite4 = true,
                TimestepArbiterOmegaThou = 1073741823,
                MaxAcceptableUpdateDelay = 1,
                LargeReplicatorSerializeWrite4 = true
            }
            
            local player = Players.LocalPlayer
            
            local function respawnar(plr)
                local char = plr.Character
                if char then
                    local hum = char:FindFirstChildWhichIsA('Humanoid')
                    if hum then 
                        hum:ChangeState(Enum.HumanoidStateType.Dead) 
                    end
                end
            end
            
            for name, value in pairs(FFlags) do
                pcall(function() 
                    setfflag(tostring(name), tostring(value)) 
                end)
            end
            
            respawnar(player)
        end

        return active
    end)

    -- BOTÃO JUMP BOOST
    local jumpBoostBtn = addBtn("JUMP BOOST", UDim2.new(0, 160, 0, BTN_H), UDim2.new(0.05, 0, Y_START + Y_GAP, 0), false, nil, function()
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

    -- BOTÃO TELEGUIADO
    local teleguiadoBtn = addBtn("TELEGUIADO", UDim2.new(0, 160, 0, BTN_H), UDim2.new(0.05, 0, Y_START + Y_GAP * 2, 0), false, nil, function()
        toggleStatus.Teleguiado = not toggleStatus.Teleguiado
        local active = toggleStatus.Teleguiado

        if active then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            
            if hrp and cam then
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    if toggleStatus.Teleguiado then
                        local moveDir = cam.CFrame.LookVector * 22
                        hrp.AssemblyLinearVelocity = moveDir
                    else
                        if connection then
                            connection:Disconnect()
                        end
                    end
                end)
            end
        else
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end

        return active
    end)

    -- BOTÃO INFO DA KEY
    local keyInfoBtn = addBtn("INFO KEY", UDim2.new(0, 80, 0, 25), UDim2.new(0.05, 0, 0.85, 0), true, nil, function()
        local keyInfo = KeySystem.KeyInfo or {}
        local message = ""
        
        if keyInfo.key then
            message = "🔑 Key: " .. keyInfo.key .. "\n"
            message = message .. "📊 Tipo: " .. (keyInfo.tipo or KeySystem.KeyTipo or "N/A") .. "\n"
            
            if keyInfo.nome then
                message = message .. "⭐ Plano: " .. keyInfo.nome .. "\n"
            end
            
            if keyInfo.usos then
                message = message .. "🔢 Usos: " .. keyInfo.usos .. "/" .. (keyInfo.usos_max or "∞")
            end
            
            if keyInfo.dias_restantes then
                message = message .. "⏰ Dias restantes: " .. keyInfo.dias_restantes
            end
        else
            message = "Informações da key não disponíveis"
        end
        
        -- Criar popup
        local popup = Instance.new("Frame", gui)
        popup.Size = UDim2.new(0, 280, 0, 140)
        popup.Position = UDim2.new(0.5, -140, 0.5, -70)
        popup.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
        popup.BackgroundTransparency = 0.1
        
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 12)
        
        local popupStroke = Instance.new("UIStroke")
        popupStroke.Color = Color3.fromRGB(0, 200, 255)
        popupStroke.Thickness = 2
        popupStroke.Parent = popup
        
        local title = Instance.new("TextLabel", popup)
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Text = "🔐 INFORMAÇÕES DA KEY"
        title.Font = Enum.Font.Arcade
        title.TextSize = 16
        title.TextColor3 = Color3.fromRGB(0, 255, 255)
        title.BackgroundTransparency = 1
        
        local info = Instance.new("TextLabel", popup)
        info.Size = UDim2.new(1, -20, 0, 70)
        info.Position = UDim2.new(0, 10, 0, 35)
        info.Text = message
        info.Font = Enum.Font.Code
        info.TextSize = 12
        info.TextColor3 = Color3.fromRGB(255, 255, 255)
        info.BackgroundTransparency = 1
        info.TextWrapped = true
        
        local closeBtn = Instance.new("TextButton", popup)
        closeBtn.Size = UDim2.new(0, 100, 0, 30)
        closeBtn.Position = UDim2.new(0.5, -50, 1, -35)
        closeBtn.Text = "FECHAR"
        closeBtn.Font = Enum.Font.Arcade
        closeBtn.TextSize = 12
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
        
        closeBtn.MouseButton1Click:Connect(function()
            popup:Destroy()
        end)
        
        -- Fechar automaticamente
        task.delay(8, function()
            if popup and popup.Parent then
                popup:Destroy()
            end
        end)
        
        return false
    end)
    keyInfoBtn.TextColor3 = Color3.fromRGB(0, 255, 255)

    -- BOTÃO DISCORD
    local discordBtn = addBtn("DISCORD", UDim2.new(0, 80, 0, 25), UDim2.new(0.55, 0, 0.85, 0), true, nil, function()
        if setclipboard then
            setclipboard(KeySystem.DiscordSuporte)
            
            -- Feedback
            discordBtn.Text = "COPIADO!"
            discordBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            task.wait(1)
            discordBtn.Text = "DISCORD"
            discordBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
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
    print("\n" .. string.rep("=", 50))
    print("🚀 JS7 HUB VIP - Inicializando...")
    print("📅 Data: " .. os.date("%d/%m/%Y %H:%M:%S"))
    print("👤 Usuário: " .. LocalPlayer.Name)
    print(string.rep("=", 50))
    
    -- Verificar se já está autenticado
    if KeySystem.Autenticado then
        print("✅ Já autenticado, carregando painel...")
        CriarPainelPrincipal()
        return
    end
    
    -- Criar tela de login
    local telaLogin = CriarTelaLogin()
    
    -- Aguardar autenticação
    repeat
        task.wait()
    until not telaLogin or not telaLogin.Parent or KeySystem.Autenticado
    
    if KeySystem.Autenticado then
        print("✅ Autenticação bem-sucedida!")
        print("🔑 Tipo: " .. (KeySystem.KeyTipo or "N/A"))
        print("🎮 Iniciando painel principal...")
        
        -- Criar painel principal
        CriarPainelPrincipal()
        
        -- Mensagem de boas-vindas
        task.wait(1)
        print("\n" .. string.rep("=", 50))
        print("🎉 JS7 HUB VIP CARREGADO COM SUCESSO!")
        print("⭐ Aproveite todas as features!")
        print(string.rep("=", 50))
    else
        print("❌ Autenticação cancelada ou falhou")
    end
end

-- ====================
-- FUNÇÕES PARA ADMIN
-- ====================
function KeySystem:GerarKeyTemporaria()
    -- Verificar se é admin
    local adminKeys = {"JS7-PERMA-MASTER-2024", "JS7-PERMA-DEV"}
    local isAdmin = false
    
    for _, adminKey in ipairs(adminKeys) do
        if self.KeysDatabase.Permanentes[adminKey] then
            isAdmin = true
            break
        end
    end
    
    if not isAdmin then
        print("❌ Acesso negado! Apenas administradores podem gerar keys.")
        return nil
    end
    
    -- Gerar key única
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomPart = ""
    
    for i = 1, 10 do
        local rand = math.random(1, #charset)
        randomPart = randomPart .. charset:sub(rand, rand)
    end
    
    local timestamp = os.time()
    local key = "JS7-TEMP-" .. randomPart .. "-" .. timestamp
    
    -- Adicionar ao banco de dados
    self.KeysDatabase.Temporarias[key] = {
        tipo = "TEMPORARIA",
        usada = false,
        usuario = nil,
        data_gerada = os.date("%d/%m/%Y %H:%M:%S"),
        data_uso = nil
    }
    
    self.KeysDatabase.Stats.total_keys = self.KeysDatabase.Stats.total_keys + 1
    self.KeysDatabase.Stats.keys_ativas = self.KeysDatabase.Stats.keys_ativas + 1
    
    -- Mostrar informações
    print("\n" .. string.rep("=", 60))
    print("✅ KEY TEMPORÁRIA GERADA COM SUCESSO!")
    print(string.rep("=", 60))
    print("🔑 KEY: " .. key)
    print("📅 Data geração: " .. os.date("%d/%m/%Y %H:%M:%S"))
    print("🎯 Usos: 1 (Único)")
    print("👤 Status: NUNCA USADA")
    print(string.rep("=", 60))
    print("📋 COMO ADICIONAR AO SISTEMA:")
    print('Adicione esta linha em KeysDatabase.Temporarias:')
    print('["' .. key .. '"] = {tipo = "TEMPORARIA", usada = false},')
    print(string.rep("=", 60))
    
    -- Copiar para clipboard
    if setclipboard then
        setclipboard(key)
        print("📋 Key copiada para a área de transferência!")
    end
    
    return key
end

-- ====================
-- EXECUTAR SISTEMA
-- ====================
-- Iniciar o sistema
IniciarSistema()

-- Comandos disponíveis no console
print("\n💻 COMANDOS DISPONÍVEIS (digite no console):")
print("• KeySystem:GerarKeyTemporaria() - Gerar key temporária")
print("• KeySystem:VerificarKey(\"SUA_KEY\") - Verificar uma key")
print("\n🌐 Site para obter keys: " .. KeySystem.SiteGerador)
print("💬 Discord suporte: " .. KeySystem.DiscordSuporte)
print("\n" .. string.rep("=", 50))

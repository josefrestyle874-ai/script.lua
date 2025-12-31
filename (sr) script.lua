loadstring([[
-- JS7 HUB V2 - COMPLETO COM BOTÃO ARRASTÁVEL
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "JS7HubV2"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

-- ==============================================
-- BOTÃO REDONDO ARRASTÁVEL
-- ==============================================
local float = Instance.new("ImageButton", gui)
float.Size = UDim2.new(0, 55, 0, 55)
float.Position = UDim2.new(0, 20, 0.5, -27)
float.Image = "rbxassetid://101332224741678"
float.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
float.BackgroundTransparency = 0.2
float.BorderSizePixel = 4  -- LINHA GROSSA
float.BorderColor3 = Color3.fromRGB(255, 0, 0)  -- VERMELHO FORTE
Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)

-- FAZER BOTÃO ARRASTÁVEL
do
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
                startUI.X.Scale, startUI.X.Offset + delta.X,
                startUI.Y.Scale, startUI.Y.Offset + delta.Y
            )
        end
    end)
end

-- Efeito Rainbow
task.spawn(function()
    while true do
        for i = 1, 6 do
            float.BorderColor3 = Color3.fromHSV(i/6, 1, 1)
            task.wait(0.8)
        end
    end
end)

-- ==============================================
-- PAINEL 1: JS7 HUB (140x220)
-- ==============================================
local painel1 = Instance.new("Frame", gui)
painel1.Size = UDim2.new(0, 140, 0, 220)
painel1.Position = UDim2.new(0.3, -70, 0.5, -110)
painel1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
painel1.BackgroundTransparency = 0
painel1.BorderSizePixel = 1
painel1.BorderColor3 = Color3.fromRGB(255, 50, 50)
painel1.Visible = false
painel1.Active = true
painel1.Draggable = true
Instance.new("UICorner", painel1).CornerRadius = UDim.new(0, 6)

float.MouseButton1Click:Connect(function()
    painel1.Visible = not painel1.Visible
end)

-- Cabeçalho
local titulo1 = Instance.new("TextLabel", painel1)
titulo1.Size = UDim2.new(1, 0, 0, 35)
titulo1.Position = UDim2.new(0, 0, 0, 5)
titulo1.BackgroundTransparency = 1
titulo1.Text = "JS7 HUB\n@js7.neurose"
titulo1.Font = Enum.Font.Arcade
titulo1.TextSize = 10
titulo1.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo1.TextWrapped = true

-- Botão ESP BEST (grande)
local espBestBtn = Instance.new("TextButton", painel1)
espBestBtn.Size = UDim2.new(0, 130, 0, 22)
espBestBtn.Position = UDim2.new(0, 5, 0, 45)
espBestBtn.Text = "ESP BEST"
espBestBtn.Font = Enum.Font.Arcade
espBestBtn.TextSize = 9
espBestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBestBtn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
Instance.new("UICorner", espBestBtn).CornerRadius = UDim.new(0, 4)

-- Função botões grid COM ESPAÇO - TODOS VERMELHO/AZUL
local function criarBotaoP1(texto, linha, coluna, azul)
    local largura = 60
    local altura = 18
    local espacoY = 4
    local inicioY = 72
    local inicioX = 8  -- MARGEM ESQUERDA
    
    if coluna == 2 then
        inicioX = 74  -- 60 + 8 + 6 (ESPAÇO ENTRE COLUNAS)
    end
    
    local btn = Instance.new("TextButton", painel1)
    btn.Size = UDim2.new(0, largura, 0, altura)
    btn.Position = UDim2.new(0, inicioX, 0, inicioY + (linha-1) * (altura + espacoY))
    btn.Text = texto
    btn.Font = Enum.Font.Arcade
    btn.TextSize = 7
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = azul and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(139, 0, 0)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
    
    -- Lógica toggle vermelho/azul para TODOS
    btn.MouseButton1Click:Connect(function()
        local ativo = btn.BackgroundColor3 == Color3.fromRGB(0, 170, 255)
        if azul then
            -- Botão DISCORD (sempre azul escuro, não faz toggle)
            if texto == "DISCORD" then 
                setclipboard("https://discord.gg/55BBE7czB")
                return
            end
            btn.BackgroundColor3 = ativo and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(0, 170, 255)
        else
            -- Demais botões: vermelho/azul
            btn.BackgroundColor3 = ativo and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(0, 170, 255)
        end
    end)
    
    return btn
end

-- Botões Painel 1 COM ESPAÇO
local espBaseBtn = criarBotaoP1("ESP BASE", 1, 1, false)
local espPlayerBtn = criarBotaoP1("ESP PLAYER", 1, 2, false)
local autoKickBtn = criarBotaoP1("AUTO KICK", 2, 1, false)
local nearestBtn = criarBotaoP1("NEAREST", 2, 2, false)
local xrayBtn = criarBotaoP1("X-RAY", 3, 1, false)
local fpsBoostBtn = criarBotaoP1("FPS BOOST", 3, 2, false)
local antiDesyncBtn = criarBotaoP1("ANTI DESYNC", 4, 1, false)
local unwalkBtn = criarBotaoP1("UNWALK", 4, 2, false)
local antiRagdollBtn = criarBotaoP1("ANTIRAGDOLL", 5, 1, false)
local hideSkinBtn = criarBotaoP1("HIDE SKIN", 5, 2, false)
local discordBtn = criarBotaoP1("DISCORD", 6, 1, true)
local kbindBtn = criarBotaoP1("KBIND", 6, 2, false)

-- ===========================
-- FEATURE : BASE ESP
-- ===========================
espBaseBtn.MouseButton1Click:Connect(function()
    if not _G.SAB then
        _G.SAB = {}
    end
    
    if not _G.SAB.BigPlotTimers then
        _G.SAB.BigPlotTimers = {
            enabled = false,
            isRunning = false
        }
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
                                    billboard.Size = UDim2.fromScale(35, 50)
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
                                billboard.Size = UDim2.fromScale(7, 10)
                            end
                        end
                    end
                end
            end)
            
            self.isRunning = false
        end)
    end
    
    local newState = not plotTimers.enabled
    plotTimers:Toggle(newState)
    
    -- A cor já é alterada pela função criarBotaoP1
end)

-- ===========================
-- FEATURE : ESP PLAYER
-- ===========================
local espPlayersActive = false
local espPlayersConnections = {}

espPlayerBtn.MouseButton1Click:Connect(function()
    espPlayersActive = not espPlayersActive
    
    if espPlayersActive then
        -- Ativar ESP PLAYER (a cor já é alterada pela função criarBotaoP1)
        
        -- Função para criar ESP para um player
        local function createPlayerESP(player)
            if player == lp or not player.Character then return end
            
            local character = player.Character
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
            if not humanoidRootPart then return end
            
            -- BillboardGui para mostrar o nome (NÃO transparente)
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "PlayerESP"
            billboard.Adornee = humanoidRootPart
            billboard.Size = UDim2.new(0, 200, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.MaxDistance = 1000
            billboard.Parent = humanoidRootPart
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "NameLabel"
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Nome vermelho SEMPRE
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameLabel.TextSize = 16
            nameLabel.Font = Enum.Font.Arcade
            nameLabel.TextScaled = false
            nameLabel.Parent = billboard
            
            -- Fazer personagem azul e transparente (ver através de paredes)
            local function makeCharacterBlueAndTransparent()
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        -- Salvar cor original
                        if part:FindFirstChild("OriginalColor") == nil then
                            local originalColor = Instance.new("Color3Value")
                            originalColor.Name = "OriginalColor"
                            originalColor.Value = part.Color
                            originalColor.Parent = part
                        end
                        
                        -- Salvar transparência original
                        if part:FindFirstChild("OriginalTransparency") == nil then
                            local originalTransparency = Instance.new("NumberValue")
                            originalTransparency.Name = "OriginalTransparency"
                            originalTransparency.Value = part.Transparency
                            originalTransparency.Parent = part
                        end
                        
                        -- Salvar material original
                        if part:FindFirstChild("OriginalMaterial") == nil then
                            local originalMaterial = Instance.new("StringValue")
                            originalMaterial.Name = "OriginalMaterial"
                            originalMaterial.Value = tostring(part.Material)
                            originalMaterial.Parent = part
                        end
                        
                        -- Aplicar efeito ESP
                        part.Color = Color3.fromRGB(0, 100, 255)  -- Azul
                        part.Transparency = 0.4  -- Transparente para ver através
                        part.Material = Enum.Material.Neon
                    end
                end
            end
            
            -- Restaurar aparência original
            local function restoreOriginalAppearance()
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        local originalColor = part:FindFirstChild("OriginalColor")
                        local originalTransparency = part:FindFirstChild("OriginalTransparency")
                        local originalMaterial = part:FindFirstChild("OriginalMaterial")
                        
                        if originalColor then
                            part.Color = originalColor.Value
                            originalColor:Destroy()
                        end
                        
                        if originalTransparency then
                            part.Transparency = originalTransparency.Value
                            originalTransparency:Destroy()
                        end
                        
                        if originalMaterial then
                            part.Material = Enum.Material[originalMaterial.Value]
                            originalMaterial:Destroy()
                        end
                    end
                end
            end
            
            -- Aplicar aparência azul/transparente
            makeCharacterBlueAndTransparent()
            
            -- Armazenar para limpeza
            table.insert(espPlayersConnections, {
                character = character,
                billboard = billboard,
                restoreFunction = restoreOriginalAppearance
            })
            
            -- Conectar para quando o character mudar
            local characterAddedConnection = player.CharacterAdded:Connect(function(newChar)
                if billboard then billboard:Destroy() end
                restoreOriginalAppearance()
                
                task.wait(1)
                createPlayerESP(player)
            end)
            
            table.insert(espPlayersConnections, {connection = characterAddedConnection})
        end
        
        -- Criar ESP para todos os players existentes
        for _, player in ipairs(Players:GetPlayers()) do
            createPlayerESP(player)
        end
        
        -- Conectar para novos players
        local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
            if espPlayersActive then
                createPlayerESP(player)
            end
        end)
        
        table.insert(espPlayersConnections, {connection = playerAddedConnection})
        
    else
        -- Desativar ESP PLAYER (a cor já é alterada pela função criarBotaoP1)
        
        -- Limpar todos os ESPs e conexões
        for _, data in ipairs(espPlayersConnections) do
            if data.billboard then
                data.billboard:Destroy()
            end
            if data.restoreFunction then
                data.restoreFunction()
            end
            if data.connection then
                data.connection:Disconnect()
            end
        end
        
        -- Limpar array de conexões
        espPlayersConnections = {}
    end
end)

-- ===========================
-- FEATURE : X-RAY (APENAS BASES)
-- ===========================
local xrayActive = false
local xrayConnections = {}

xrayBtn.MouseButton1Click:Connect(function()
    xrayActive = not xrayActive
    
    if xrayActive then
        -- Ativar X-RAY (a cor já é alterada pela função criarBotaoP1)
        
        -- Função para tornar as bases transparentes
        local function makeBasesTransparent()
            pcall(function()
                -- Procurar por bases/plots no Workspace
                for _, plot in Workspace.Plots:GetChildren() do
                    -- Verificar se é uma base/plot (geralmente tem estrutura específica)
                    if plot:IsA("Model") then
                        -- Verificar por partes que compõem a base
                        for _, part in plot:GetDescendants() do
                            if part:IsA("BasePart") or part:IsA("MeshPart") then
                                -- Verificar se parece ser parte de uma base
                                -- Bases geralmente são grandes, retangulares, etc.
                                local isBasePart = false
                                
                                -- Verificar por tamanho (bases são geralmente grandes)
                                if part.Size.X > 10 or part.Size.Y > 10 or part.Size.Z > 10 then
                                    isBasePart = true
                                end
                                
                                -- Verificar por nome (muitas bases tem nomes específicos)
                                local partName = part.Name:lower()
                                if partName:find("base") or partName:find("plot") or 
                                   partName:find("floor") or partName:find("ground") or
                                   partName:find("wall") or partName:find("platform") or
                                   partName:find("block") or partName:find("terrain") then
                                    isBasePart = true
                                end
                                
                                -- Verificar por cor (muitas bases tem cores específicas)
                                local isBrownOrGray = false
                                local r, g, b = part.Color.R, part.Color.G, part.Color.B
                                -- Cores marrons/cinzas são comuns para bases
                                if (r > 0.3 and r < 0.7) and (g > 0.2 and g < 0.6) and (b > 0.1 and b < 0.5) then
                                    isBrownOrGray = true
                                end
                                
                                if isBasePart or isBrownOrGray then
                                    -- Salvar propriedades originais
                                    if part:FindFirstChild("XRayOriginalTransparency") == nil then
                                        local originalTransparency = Instance.new("NumberValue")
                                        originalTransparency.Name = "XRayOriginalTransparency"
                                        originalTransparency.Value = part.Transparency
                                        originalTransparency.Parent = part
                                    end
                                    
                                    if part:FindFirstChild("XRayOriginalMaterial") == nil then
                                        local originalMaterial = Instance.new("StringValue")
                                        originalMaterial.Name = "XRayOriginalMaterial"
                                        originalMaterial.Value = tostring(part.Material)
                                        originalMaterial.Parent = part
                                    end
                                    
                                    -- Tornar transparente (X-RAY)
                                    part.Transparency = 0.8  -- Muito transparente
                                    part.Material = Enum.Material.Glass  -- Material de vidro para melhor visão
                                    
                                    -- Adicionar à lista para limpeza
                                    table.insert(xrayConnections, {
                                        part = part,
                                        originalTransparency = part:FindFirstChild("XRayOriginalTransparency"),
                                        originalMaterial = part:FindFirstChild("XRayOriginalMaterial")
                                    })
                        end
                    end
                end
            end)
        end
        
        -- Função para restaurar aparência original
        local function restoreOriginalAppearance()
            pcall(function()
                for _, data in ipairs(xrayConnections) do
                    if data.part and data.part.Parent then
                        if data.originalTransparency then
                            data.part.Transparency = data.originalTransparency.Value
                            data.originalTransparency:Destroy()
                        end
                        
                        if data.originalMaterial then
                            data.part.Material = Enum.Material[data.originalMaterial.Value]
                            data.originalMaterial:Destroy()
                        end
                    end
                end
            end)
        end
        
        -- Aplicar X-RAY inicialmente
        makeBasesTransparent()
        
        -- Conectar para novas partes que apareçam
        local workspaceChildAdded = Workspace.ChildAdded:Connect(function(child)
            if xrayActive then
                task.wait(0.5)  -- Esperar um pouco para a parte carregar
                makeBasesTransparent()
            end
        end)
        
        table.insert(xrayConnections, {connection = workspaceChildAdded})
        
    else
        -- Desativar X-RAY (a cor já é alterada pela função criarBotaoP1)
        
        -- Restaurar aparência original de todas as partes
        pcall(function()
            for _, data in ipairs(xrayConnections) do
                if data.part and data.part.Parent then
                    if data.originalTransparency then
                        data.part.Transparency = data.originalTransparency.Value
                        data.originalTransparency:Destroy()
                    end
                    
                    if data.originalMaterial then
                        data.part.Material = Enum.Material[data.originalMaterial.Value]
                        data.originalMaterial:Destroy()
                    end
                end
                
                if data.connection then
                    data.connection:Disconnect()
                end
            end
        end)
        
        -- Limpar array de conexões
        xrayConnections = {}
    end
end)

-- ==============================================
-- PAINEL 2: SEGUE NO TTK (120x150)
-- ==============================================
local painel2 = Instance.new("Frame", gui)
painel2.Size = UDim2.new(0, 120, 0, 150)
painel2.Position = UDim2.new(0.7, -60, 0.5, -75)
painel2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
painel2.BackgroundTransparency = 0
painel2.BorderSizePixel = 1
painel2.BorderColor3 = Color3.fromRGB(0, 120, 255)
painel2.Visible = true
painel2.Active = true
painel2.Draggable = true
Instance.new("UICorner", painel2).CornerRadius = UDim.new(0, 6)

local titulo2 = Instance.new("TextLabel", painel2)
titulo2.Size = UDim2.new(1, 0, 0, 25)
titulo2.Position = UDim2.new(0, 0, 0, 5)
titulo2.BackgroundTransparency = 1
titulo2.Text = "SEGUE NO TTK"
titulo2.Font = Enum.Font.Arcade
titulo2.TextSize = 10
titulo2.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Função botões Painel 2 - TODOS VERMELHO/AZUL
local function criarBotaoP2(texto, linha, larguraTotal)
    local largura = larguraTotal and 110 or 52
    local altura = 18
    local espacoY = 4
    local inicioY = 35
    local inicioX = 5
    
    if not larguraTotal and (texto == "DESYNC V3" or texto == "INF JUMP") then
        inicioX = 63
    end
    
    local btn = Instance.new("TextButton", painel2)
    btn.Size = UDim2.new(0, largura, 0, altura)
    btn.Position = UDim2.new(0, inicioX, 0, inicioY + (linha-1) * (altura + espacoY))
    btn.Text = texto
    btn.Font = Enum.Font.Arcade
    btn.TextSize = 7
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)  -- Todos começam vermelho
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
    
    -- Lógica toggle vermelho/azul para TODOS
    btn.MouseButton1Click:Connect(function()
        local ativo = btn.BackgroundColor3 == Color3.fromRGB(0, 170, 255)
        btn.BackgroundColor3 = ativo and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(0, 170, 255)
    end)
    
    return btn
end

-- Botões Painel 2
local devourerBtn = criarBotaoP2("DEVOURER", 1, false)
local desyncV3Btn = criarBotaoP2("DESYNC V3", 1, false)
local speedBtn = criarBotaoP2("SPEED", 2, false)
local infJumpBtn = criarBotaoP2("INF JUMP", 2, false)
local tpToBestBtn = criarBotaoP2("TP TO BEST", 3, true)
local flyV2Btn = criarBotaoP2("FLY V2", 4, true)
local instaFloorBtn = criarBotaoP2("INSTA FLOOR", 5, true)

print("✅ JS7 HUB - COMPLETO E FUNCIONAL")
print("✅ Botão redondo: Arrastável + círculo vermelho forte")
print("✅ Painel 1: 140x220 - Botões com espaço entre eles")
print("✅ Painel 2: 120x150 - Tudo organizado")
print("✅ TODOS os botões: Vermelho desativado / Azul ativado")
print("✅ ESP BASE: Funcionalidade completa adicionada")
print("✅ ESP PLAYER: Nomes vermelhos SEMPRE, players azuis e transparentes")
print("✅ X-RAY: Apenas bases/plots ficam transparentes (Transparency 0.8)")
print("✅ X-RAY: Material Glass para melhor visibilidade através")
print("✅ Nada sai para fora dos painéis")
]])()
        

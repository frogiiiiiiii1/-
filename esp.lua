local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Настройки Highlight (можешь менять)
local HIGHLIGHT_FILL_COLOR = Color3.fromRGB(255, 0, 0)  -- цвет заливки
local HIGHLIGHT_FILL_TRANSPARENCY = 0.5                 -- прозрачность заливки (0 = полностью видимая)
local HIGHLIGHT_OUTLINE_COLOR = Color3.fromRGB(255, 0, 0)
local HIGHLIGHT_OUTLINE_TRANSPARENCY = 0
local HIGHLIGHT_DEPTH_MODE = Enum.HighlightDepthMode.AlwaysOnTop   -- ✅ ключевой параметр – видно сквозь стены

local activeHighlights = {}

local function addHighlight(player)
    if player == LocalPlayer then return end
    local function onCharacterAdded(character)
        -- удаляем старый, если был
        if activeHighlights[player] then
            activeHighlights[player]:Destroy()
        end
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = HIGHLIGHT_FILL_COLOR
        highlight.FillTransparency = HIGHLIGHT_FILL_TRANSPARENCY
        highlight.OutlineColor = HIGHLIGHT_OUTLINE_COLOR
        highlight.OutlineTransparency = HIGHLIGHT_OUTLINE_TRANSPARENCY
        highlight.DepthMode = HIGHLIGHT_DEPTH_MODE
        highlight.Parent = character
        activeHighlights[player] = highlight
    end
    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

local function removeHighlight(player)
    if activeHighlights[player] then
        activeHighlights[player]:Destroy()
        activeHighlights[player] = nil
    end
end

-- Обрабатываем всех игроков
for _, player in ipairs(Players:GetPlayers()) do
    addHighlight(player)
end
Players.PlayerAdded:Connect(addHighlight)
Players.PlayerRemoving:Connect(removeHighlight)

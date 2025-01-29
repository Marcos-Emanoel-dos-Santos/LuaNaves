Poder1 = {}
TabelaPoderes = {}

function Poder1:new()
    local novo_poder = {}
    novo_poder.X = math.random(0, love.graphics.getWidth()-32)
    novo_poder.Y = math.random(0, love.graphics.getHeight()-32)
    novo_poder.W, novo_poder.H = 32, 32
    novo_poder.Cooldown = 5

    setmetatable(novo_poder, {__index = Poder1})

    return novo_poder
end

return Poder1
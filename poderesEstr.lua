Poder1 = {}
Poder2 = {}

function Poder1:new(x, y)
    -- DEFINE AMONTOADO DE VARIÁVEL
    local novo_poder = {}
    novo_poder.X = x
    novo_poder.Y = y
    novo_poder.W, novo_poder.H = 32, 32
    novo_poder.Id = 1
    novo_poder.duracao = nil

    -- PODER DE VÁRIOS TIROS
    novo_poder.Ativar = function (player)
        for i=0, 359, 22.5 do
            local spdX = math.cos(math.rad(i))*player.SkillSpd
            local spdY = math.sin(math.rad(i))*player.SkillSpd
            if not (spdX == 0 and spdY == 0) then
                table.insert(player.Skills_Ativas, Skill:new(spdX, spdY, player.X, player.Y, player.W, player.H))
            end
        end
    end

    setmetatable(novo_poder, {__index = Poder1})
    return novo_poder
end

function Poder2:new(x, y)
    -- DEFINE AMONTOADO DE VARIÁVEL
    local novo_poder = {}
    novo_poder.X = x
    novo_poder.Y = y
    novo_poder.W, novo_poder.H = 32, 32
    novo_poder.Id = 2

    -- PODER DE DISPARO RÁPIDO
    novo_poder.Ativar = function (player)
        table.insert(player.Buffs, {
            function ()
                player.Cd, player.R, player.G, player.B = 0.2, 255/255, 180/255, 180/255
         end, tempo = 3.5})
    end


    setmetatable(novo_poder, {__index = Poder2})
    return novo_poder
end


return Poder1, Poder2
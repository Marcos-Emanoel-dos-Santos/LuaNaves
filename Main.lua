_G.love = require("love")
_G.Classe = require("PlayerEstr")
_G.Power = require("poderesEstr")
_G.Reset = require("Set")

function love.load()
    math.randomseed(os.time())

    dofile("ProjetosAula/proj10/Set.lua")

    Fullscreen = true
    love.window.setFullscreen(Fullscreen, "desktop")

    Titulo = love.graphics.newImage("img/GuerraDeNaves.png")
    Poder1Art = love.graphics.newImage("img/Poder1Img.png")
    Poder2Art = love.graphics.newImage("img/PowerUpImg.png")
    AnimacaoPlayer = {
        [1] = love.graphics.newImage("img/naveC.png"),
        [2] = love.graphics.newImage("img/naveDC.png"),
        [3] = love.graphics.newImage("img/naveD.png"),
        [4] = love.graphics.newImage("img/naveDB.png"),
        [5] = love.graphics.newImage("img/naveB.png"),
        [6] = love.graphics.newImage("img/naveEB.png"),
        [7] = love.graphics.newImage("img/naveE.png"),
        [8] = love.graphics.newImage("img/naveEC.png")
    }
end


function love.update(dt)
    if Gamemode == 1 then

    elseif Gamemode == 2 then
        Tempo = Tempo + dt
        if math.floor(Tempo)%5 == 0 and Tempo > UltimoTempo + 4 then
            local n = math.random(1, 2)
            if n == 1 then
                table.insert(TabelaPoderes, Poder1:new(math.random(0, WinW-32), math.random(0, love.graphics.getHeight()-32)))
            elseif n == 2 then
                table.insert(TabelaPoderes, Poder2:new(math.random(0, WinW-32), math.random(0, love.graphics.getHeight()-32)))
            end
            UltimoTempo = Tempo
        end


        if Players.Player ~= nil then
            Players.Player:update(dt)
            Players.Player:inputTeclado("w", "a", "s", "d", "f", Players.Player2)

            for i, poder in ipairs(TabelaPoderes) do
                if Players.Player:colisao(poder) then
                    Players.Player:coletaPoder(poder, poder.Duracao, dt)
                    table.remove(TabelaPoderes, i)
                end
            end

            for i, skill in pairs(Players.Player.Skills_Ativas) do
                skill:MoveSkill()
                if skill:KillCond(Players.Player2) then
                    table.remove(Players.Player.Skills_Ativas, i)
                end
            end
        end

        if Players.Player2 ~= nil then
            Players.Player2:update(dt)
            Players.Player2:inputTeclado("up", "left", "down", "right", "l", Players.Player)

            for i, poder in ipairs(TabelaPoderes) do
                if Players.Player2:colisao(poder) then
                    Players.Player2:coletaPoder(poder, poder.duracao)
                    table.remove(TabelaPoderes, i)
                end
            end

            for i, skill in pairs(Players.Player2.Skills_Ativas) do
                skill:MoveSkill()
                if skill:KillCond(Players.Player) then
                    table.remove(Players.Player2.Skills_Ativas, i)
                end
            end
        end

        for i, player in pairs(Players) do
            if player.HP < 1 then
                Players[i] = nil
                dofile("ProjetosAula/proj10/Set.lua")
            end
        end
    end
end


function love.draw()
    if Gamemode == 1 then
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.draw(Titulo, love.graphics.getWidth()/2-180, love.graphics.getHeight()/6, 0, 4)

        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", love.graphics.getWidth()/2-100, love.graphics.getHeight()/2, 200, 100)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print("Jogar", love.graphics.getWidth()/2-30, love.graphics.getHeight()/2+35, 0, 2)

        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", love.graphics.getWidth()/2-100, love.graphics.getHeight()/2+125, 200, 100)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print("Opções", love.graphics.getWidth()/2-43, love.graphics.getHeight()/2+160, 0, 2)

    elseif Gamemode == 2 then
        love.graphics.setBackgroundColor(0, 0, 0)

        -- CRIA SKILLS
        if Players.Player ~= nil then
            for _, skill in ipairs(Players.Player.Skills_Ativas) do
                love.graphics.setLineWidth(2)
                love.graphics.setColor(255/255, 0/255, 0/255)
                love.graphics.circle("line", skill.X, skill.Y, skill.Raio)

                love.graphics.setColor(skill.R, skill.G, skill.B)
                love.graphics.circle("fill", skill.X, skill.Y, skill.Raio)
            end
        end
        if Players.Player2 ~= nil then
            for _, skill in ipairs(Players.Player2.Skills_Ativas) do
                love.graphics.setLineWidth(2)
                love.graphics.setColor(255/255, 0/255, 0/255)
                love.graphics.circle("line", skill.X, skill.Y, skill.Raio)

                love.graphics.setColor(skill.R, skill.G, skill.B)
                love.graphics.circle("fill", skill.X, skill.Y, skill.Raio)
            end
        end


        -- CRIA JOGADORES
        if Players.Player ~= nil then
            love.graphics.setColor(Players.Player.R, Players.Player.G, Players.Player.B)
            love.graphics.draw(AnimacaoPlayer[Players.Player.Rotacao], Players.Player.X, Players.Player.Y)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(Players.Player.HP, 0, 0, 0, 3)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("0", 0, 0, 0, 3)
        end

        if Players.Player2 ~= nil then
            love.graphics.setColor(Players.Player2.R, Players.Player2.G, Players.Player2.B)
            love.graphics.draw(AnimacaoPlayer[Players.Player2.Rotacao], Players.Player2.X, Players.Player2.Y)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(Players.Player2.HP, WinW - 30, 0, 0, 3)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("0", WinW - 30, 0, 0, 3)
        end


        --CRIA PODERES
        love.graphics.setColor(255/255, 255/255, 255/255)
        for _, poder in ipairs(TabelaPoderes) do
            if poder.Id == 1 then
                love.graphics.draw(Poder1Art, poder.X, poder.Y)
            elseif poder.Id == 2 then
                love.graphics.draw(Poder2Art, poder.X, poder.Y)
            end
        end

    end
end


function love.keypressed(k)
    if k == "escape" then
        Fullscreen = not Fullscreen
        love.window.setFullscreen(Fullscreen, "desktop")
    elseif k == "backspace" and Fullscreen then
        love.event.push("quit")
    end
end


function love.mousepressed(x, y, k)
    if Gamemode == 1 and k == 1 then
        if
        x > love.graphics.getWidth()/2-100 and
        x < love.graphics.getWidth()/2+100 and
        y > love.graphics.getHeight()/2 and
        y < love.graphics.getHeight()/2+100
        then
            Gamemode = 2
            Tempo = 0
        elseif
        x > love.graphics.getWidth()/2-100 and
        x < love.graphics.getWidth()/2+100 and
        y > love.graphics.getHeight()/2+125 and
        y < love.graphics.getHeight()/2+225
        then
            Gamemode = 2
            Tempo = 0
        end
    end
end

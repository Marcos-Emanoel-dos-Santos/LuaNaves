_G.love = require("love")
_G.Classe = require("PlayerEstr")
_G.Power = require("poderesEstr")
_G.Reset = require("Set")

function love.load()
    -- Para que as coisas aleatórias funcionem
    math.randomseed(os.time())

    dofile("ProjetosAula/proj10/Set.lua")

    -- Por padrão o jogo é em fullscreen
    Fullscreen = true
    love.window.setFullscreen(Fullscreen, "desktop")

    -- Config básicas
    Titulo = love.graphics.newImage("img/GuerraDeNaves.png")
    Poder1Art = love.graphics.newImage("img/Poder1Img.png")
    Poder2Art = love.graphics.newImage("img/PowerUpImg.png")

    P_Up, P_Left, P_Down, P_Right, P_Atk = "w", "a", "s", "d", "f"
    P2_Up, P2_Left, P2_Down, P2_Right, P2_Atk = "up", "left", "down", "right", "l"

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
        -- dt é o tempo a cada frame. Define a passagem do tempo
        Tempo = Tempo + dt
        -- Na primeira vez, UltimoTempo = nil
        if math.floor(Tempo)%5 == 0 and Tempo > UltimoTempo + 4 then
            -- Cria um num aleatório e, dependendo dele, coloca um poder diferente no mapa
            local n = math.random(1, 2)
            if n == 1 then
                table.insert(TabelaPoderes, Poder1:new(math.random(0, WinW-32), math.random(0, love.graphics.getHeight()-32)))
            elseif n == 2 then
                table.insert(TabelaPoderes, Poder2:new(math.random(0, WinW-32), math.random(0, love.graphics.getHeight()-32)))
            end
            UltimoTempo = Tempo
        end


        -- SE JOGADOR1 EXISTE
        if Players.Player ~= nil then
            -- UPDATE COM BASE EM TEMPO PASSADO
            Players.Player:update(dt)
            -- CRIA INPUT TECLADO, DEFINTE P2S INIMIGO
            Players.Player:inputTeclado(P_Up, P_Left, P_Down, P_Right, P_Atk, Players.Player2)

            -- COLETA PODER
            for i, poder in ipairs(TabelaPoderes) do
                if Players.Player:colisao(poder) then
                    Players.Player:coletaPoder(poder, poder.Duracao, dt)
                    table.remove(TabelaPoderes, i)
                end
            end

            -- CONFIG CADA SKILL
            for i, skill in pairs(Players.Player.Skills_Ativas) do
                skill:MoveSkill()
                if skill:KillCond(Players.Player2) then
                    table.remove(Players.Player.Skills_Ativas, i)
                end
            end
        end

        -- SE JOGADOR2 EXISTE
        if Players.Player2 ~= nil then
            -- UPDATE COM BASE EM TEMPO PASSADO
            Players.Player2:update(dt)
            -- CRIA INPUT TECLADO, DEFINTE P1 INIMIGO
            Players.Player2:inputTeclado(P2_Up, P2_Left, P2_Down, P2_Right, P2_Atk, Players.Player)

            -- COLETA PODER
            for i, poder in ipairs(TabelaPoderes) do
                if Players.Player2:colisao(poder) then
                    Players.Player2:coletaPoder(poder, poder.duracao)
                    table.remove(TabelaPoderes, i)
                end
            end

            -- CONFIG CADA SKILL
            for i, skill in pairs(Players.Player2.Skills_Ativas) do
                skill:MoveSkill()
                if skill:KillCond(Players.Player) then
                    table.remove(Players.Player2.Skills_Ativas, i)
                end
            end
        end

        -- SE NÃO HP, MORRE. MUDA DE TELA
        for i, player in pairs(Players) do
            if player.HP < 1 then
                Players[i] = nil
                dofile("ProjetosAula/proj10/Set.lua")
            end
        end
    end
end


function love.draw()
    -- GAMEMODE MAIN SCREEN
    if Gamemode == 1 then
        -- IMAGEM "GUERRA DE NAVES" NA TELA
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.draw(Titulo, love.graphics.getWidth()/2-180, love.graphics.getHeight()/6, 0, 4)

        -- CRIA BOTÃO DE JOGAR
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", love.graphics.getWidth()/2-100, love.graphics.getHeight()/2, 200, 100)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print("Jogar", love.graphics.getWidth()/2-30, love.graphics.getHeight()/2+35, 0, 2)

        -- CRIA BOTÃO DE OPÇÕES
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", love.graphics.getWidth()/2-100, love.graphics.getHeight()/2+125, 200, 100)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print("Opções", love.graphics.getWidth()/2-43, love.graphics.getHeight()/2+160, 0, 2)

        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", 5, 5, 30, 30)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print("X", 11, 5, 0, 2)
    -- GAMEMODE JOGO
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

    elseif Gamemode == 99 then
        -- GAMEMODE CONFIG
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", 5, 5, 30, 30)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print("<-", 9, 9, 0, 1.5)

        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", love.graphics.getWidth()/2-100, love.graphics.getHeight()/2, 200, 100)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print("Alterar teclas", love.graphics.getWidth()/2-81, love.graphics.getHeight()/2+38, 0 , 2)
    end
end


-- SE TECLADO CLICADO
function love.keypressed(k)
    if k == "escape" then
        Fullscreen = not Fullscreen
        love.window.setFullscreen(Fullscreen, "desktop")
    elseif k == "backspace" and Fullscreen then
        love.event.push("quit")
    end
end


-- SE MOUSE CLICADO
function love.mousepressed(x, y, k)
    if Gamemode == 1 and k == 1 then
        -- CLICOU EM "JOGAR"
        if
        x > love.graphics.getWidth()/2-100 and
        x < love.graphics.getWidth()/2+100 and
        y > love.graphics.getHeight()/2 and
        y < love.graphics.getHeight()/2+100
        then
            Gamemode = 2
            Tempo = 0
        elseif
        -- CLICOU EM "OPÇÕES"
        x > love.graphics.getWidth()/2-100 and
        x < love.graphics.getWidth()/2+100 and
        y > love.graphics.getHeight()/2+125 and
        y < love.graphics.getHeight()/2+225
        then
            Gamemode = 99
            Tempo = 0
        elseif
        -- CLICOU EM "X"
        x > 5 and x < 30 and y > 5 and y < 30 then
            love.event.push("quit")
        end
    end
    if Gamemode == 99 and k == 1 then
        -- CLICOU EM "<-""
        if x > 5 and x < 30 and y > 5 and y < 30 then
            Gamemode = 1
        end
    end
end

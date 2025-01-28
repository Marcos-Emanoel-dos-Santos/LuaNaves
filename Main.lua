_G.love = require("love")
_G.Classe = require("Classes")

function love.load()
    Gamemode = 1
    Fullscreen = true
    love.window.setFullscreen(Fullscreen, "desktop")
    love.graphics.setBackgroundColor(55/255, 55/255, 55/255)

    Players = {
        Player = Classe1:new(100, 100),
        Player2 = Classe1:new(400, 400)
    }

    WindowW = love.graphics.getWidth()
    Titulo = love.graphics.newImage("img/GuerraDeNaves.png")

    Skills_Ativas = {}
end

function love.update(dt)
    WindowW = love.graphics.getWidth()
    if Gamemode == 1 then

    elseif Gamemode == 2 then

        if Players.Player ~= nil then
            Players.Player:inputTeclado("w", "a", "s", "d", "f", Players.Player2)
            Players.Player:cooldown(dt)
            for _, skill in ipairs(Players.Player.Skills_Ativas) do
                skill:MoveSkill()
                skill:Kill(Players.Player)
                skill:Hit(Players.Player, Players.Player2)
            end
        end

        if Players.Player2 ~= nil then
            Players.Player2:inputTeclado("up", "left", "down", "right", "l", Players.Player)
            Players.Player2:cooldown(dt)

            for _, skill in ipairs(Players.Player2.Skills_Ativas) do
                skill:MoveSkill()
                skill:Kill(Players.Player2)
                skill:Hit(Players.Player2, Players.Player)
            end

            for i, player in pairs(Players) do
                if player.HP < 1 then
                    Players[i] = nil
                end
            end
        end
    end

end


function love.draw()
    if Gamemode == 1 then
        --love.graphics.print("Batalha de Naves", love.graphics.getWidth()/2-220, love.graphics.getHeight()/6, 0, 4)
        love.graphics.draw(Titulo, love.graphics.getWidth()/2-180, love.graphics.getHeight()/6, 0, 4)
        love.graphics.setColor(255/255, 255/255, 255/255)

        love.graphics.rectangle("fill", love.graphics.getWidth()/2-100, love.graphics.getHeight()/2, 200, 100)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print("Jogar", love.graphics.getWidth()/2-30, love.graphics.getHeight()/2+35, 0, 2)
    elseif Gamemode == 2 then
        love.graphics.setBackgroundColor(0, 0, 0)

        if Players.Player ~= nil then
            love.graphics.setColor(Players.Player.R, Players.Player.G, Players.Player.B)
            love.graphics.rectangle("fill", Players.Player.X, Players.Player.Y, Players.Player.W, Players.Player.H)
            love.graphics.print(Players.Player.HP, 0, 0, 0, 3)
        else
            love.graphics.print("0", 0, 0, 0, 3)
        end


        if Players.Player2 ~= nil then
            love.graphics.setColor(Players.Player2.R, Players.Player2.G, Players.Player2.B)
            love.graphics.rectangle("fill", Players.Player2.X, Players.Player2.Y, Players.Player2.W, Players.Player2.H)
            love.graphics.print(Players.Player2.HP, WindowW - 30, 0, 0, 3)
        else
            love.graphics.print("0", WindowW - 30, 0, 0, 3)
        end


        if Players.Player  ~= nil then
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
        if x > love.graphics.getWidth()/2-100 and
        x < love.graphics.getWidth()/2+100 and
        y > love.graphics.getHeight()/2 and
        y < love.graphics.getHeight()/2+100
        then
            Gamemode = 2
        end
    end
end

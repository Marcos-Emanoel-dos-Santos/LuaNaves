if Players then
    for i=#Players, 1, -1 do
        table.remove(Players, i)
    end
end

Players = {
    Player = Classe1:new(50, 50),
    Player2 = Classe1:new(love.graphics.getWidth()-150, love.graphics.getHeight()-150)
}


Gamemode = 1
Tempo = 0
UltimoTempo = 0
TabelaPoderes = {}
WinW = love.graphics.getWidth()
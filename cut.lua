_G.love = require("love")
local cut = {}

function cut.getImgQuads(image, w, h)
    local listaQuads = {}
    local imgWidth, imgHeight = image:getDimensions()

    for j=0, imgHeight-h, h do
        for i=0, imgWidth-w, w do
            table.insert(listaQuads, love.graphics.newQuad(i, j, w, h, imgWidth, imgHeight))
        end
    end
    return listaQuads
end

function cut.escrever(image, listaQuads, x, y, ...)
    local Coordenadas = {...}
    local offsetX = 0
    local offsetY = 0
    for _, i in ipairs(Coordenadas) do
        local _, _, W, H = listaQuads[i]:getViewport()

        if x+(offsetX+1)*W > love.graphics.getWidth() then
            offsetY = offsetY + 1
            offsetX = 0
        end
            love.graphics.draw(image, listaQuads[i], x+offsetX*W, y+offsetY*H)
            offsetX = offsetX + 1
    end
end

return cut
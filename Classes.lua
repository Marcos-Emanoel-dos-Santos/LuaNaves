Classe1 = {}
Skill = {}

function Classe1:new(pX, pY)
    local Obj = {}

    -- DEFINE AMONTOADO DE VARIÁVEL
    Obj.X, Obj.Y = pX, pY
    Obj.Spd = 5
    Obj.W, Obj.H = 100, 100
    Obj.HP = 3
    Obj.R, Obj.G, Obj.B = 255/255, 255/255, 255/255
    Obj.OrientacaoX, Obj.OrientacaoY = 0, 0
    Obj.teclasApertadas = {}

    Obj.Cd = 0.5
    Obj.SkillCooldown = 0
    Obj.Skills_Ativas = {}

    -- O QUE PRESSIONAR CADA TECLA FAZ
    Obj.K = {
        [1] = function (self, colidir) self:Mover(0, -self.Spd, colidir) end, -- w
        [2] = function (self, colidir) self:Mover(-self.Spd, 0, colidir) end, -- a
        [3] = function (self, colidir) self:Mover(0, self.Spd, colidir) end, -- s
        [4] = function (self, colidir) self:Mover(self.Spd, 0, colidir) end, -- d
        [5] = function (self, colidir)
            -- DEFINE A ORIENTAÇÃO DA SKILL QUANDO SOLTAR ELA
            self.OrientacaoX, self.OrientacaoY = 0, 0
                for _, tecla in ipairs(self.teclasApertadas) do
                    if tecla == 1 then self.OrientacaoY = -1 end
                    if tecla == 3 then self.OrientacaoY = 1 end
                    if tecla == 2 then self.OrientacaoX = -1 end
                    if tecla == 4 then self.OrientacaoX = 1 end
                end
            if self.SkillCooldown <= 0 then
                self.SkillCooldown = self.Cd
                -- CRIA A SKILL
                table.insert(self.Skills_Ativas, Skill:new(self.OrientacaoX, self.OrientacaoY, self.X, self.Y, self.W, self.H))
                -- LIMPA A TABELA DE TECLAS APERTADAS
                self.teclasApertadas = {}
            end
        end
    }

    setmetatable(Obj, {__index = Classe1})

    function Classe1:cooldown(dt)
        if self.SkillCooldown > 0 then -- SE O COOLDOWN NÃO ACABOU
            self.SkillCooldown = self.SkillCooldown - dt
            if self.SkillCooldown < 0 then -- SE O COOLDOWN JÁ ACABOU
                self.SkillCooldown = 0
            end
        end
    end

    function Classe1:Mover(dx, dy, ...)
        local novoX = self.X
        local novoY = self.Y

        self.X = self.X + dx
        for _, v in ipairs({...}) do
            if self:colisao(v) then
                self.X = novoX
                break
            end
        end

        self.Y = self.Y + dy
        for _, v in ipairs({...}) do
            if self:colisao(v) then
                self.Y = novoY
                break
            end
        end
    end

    function Classe1:inputTeclado(a, b, c, d, e, colidir)
        local keys = {a, b, c, d, e}
        for i, v in ipairs(keys) do
            if love.keyboard.isDown(v) then
                table.insert(self.teclasApertadas, i) -- DEFINE AS TECLAS APERTADAS
                self.K[i](self, colidir)
            end
        end
    end

    function Classe1:colisao(obj)
        local x, y, w, h = GetPosX(self), GetPosY(self), GetW(self), GetH(self)
        local objX, objY, objW, objH = GetPosX(obj), GetPosY(obj), GetW(obj), GetH(obj)

        return x+w > objX and  x < objX+objW and  y+h > objY and  y < objY+objH
    end

    return Obj
end


function Skill:new(dirX, dirY, x, y, w, h)
    local nova_skill = {}

    -- AMONTOADO DE VARIÁVEL
    nova_skill.Spd = 10
    nova_skill.Raio = 10
    nova_skill.X, nova_skill.Y = x + w / 2, y + h / 2
    nova_skill.R, nova_skill.G, nova_skill.B = 255/255, 255/255, 255/255
    nova_skill.DirX, nova_skill.DirY = dirX, dirY


    setmetatable(nova_skill, {__index = Skill})

    function Skill:MoveSkill()
        self.X = self.X + self.DirX * self.Spd
        self.Y = self.Y + self.DirY * self.Spd
    end

    function Skill:Kill(P)
        if self.X > love.graphics.getWidth() or self.Y > love.graphics.getHeight() or
        self.X < 0 or self.Y < 0
        then
            table.remove(P.Skills_Ativas, 1)
        end
        if (self.DirX == 0 and self.DirY == 0) then
            table.remove(P.Skills_Ativas, #P.Skills_Ativas)
        end
    end

    function Skill:Hit(P, ...)
        for _, v in ipairs({...}) do
            if self.X+self.R > v.X and
            self.X-self.R < v.X+v.W and
            self.Y+self.R > v.Y and
            self.Y-self.R < v.Y+v.H
            then
                if v.HP then
                    if v.HP > 0 then
                        v.HP = v.HP - 1
                    end
                    table.remove(P.Skills_Ativas, 1)
                end
            end
        end
    end

    return nova_skill
end

function GetPosX(obj)
    return obj.X
end
function GetPosY(obj)
    return obj.Y
end
function GetW(obj)
    return obj.W
end
function GetH(obj)
    return obj.H
end
function GetSpd(obj)
    return obj.Spd
end

return Classe1, Skill
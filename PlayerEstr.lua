Classe1 = {}
Skill = {}

function Classe1:new(pX, pY)
    local Obj = {}

    -- DEFINE AMONTOADO DE VARIÁVEL
    Obj.X, Obj.Y = pX, pY
    Obj.Spd = 5
    Obj.SkillSpd = 10
    Obj.W, Obj.H = 80, 80
    Obj.HP = 5
    Obj.R, Obj.G, Obj.B = 255/255, 255/255, 255/255
    Obj.OrientacaoX, Obj.OrientacaoY = 0, 1
    Obj.Rotacao = 1
    Obj.UltimoMovimento = "c"
    Obj.teclasApertadas = {}

    Obj.Cd = 0.8
    Obj.SkillCooldown = 0
    Obj.Skills_Ativas = {}
    Obj.Buffs = {}


    setmetatable(Obj, {__index = Classe1})

    return Obj
end

function Classe1:update(dt)
    -- COOLDOWN DA SKILL
    if self.SkillCooldown > 0 then -- SE O COOLDOWN NÃO ACABOU
        self.SkillCooldown = self.SkillCooldown - dt
        if self.SkillCooldown < 0 then -- SE O COOLDOWN JÁ ACABOU
            self.SkillCooldown = 0
        end
    end

    for i, v in ipairs(self.Buffs) do
        -- FAZ EFEITO DO PODER
        v[1]()
        v.tempo = v.tempo - dt
        if v.tempo <= 0 then
            self.Cd = 0.5
            self.R, self.G, self.B = 255/255, 255/255, 255/255
            table.remove(self.Buffs, i)
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

local function teclasAtivas(teclas)
    for _, tecla in ipairs(teclas) do
        if not love.keyboard.isDown(tecla) then
            return false
        end
    end
    return true
end

function Classe1:inputTeclado(a, b, c, d, e, colidir)
    local dir = {
        {"ec", {-self.SkillSpd, -self.SkillSpd}},
        {"eb", {-self.SkillSpd, self.SkillSpd}},
        {"dc", {self.SkillSpd, -self.SkillSpd}},
        {"db", {self.SkillSpd, self.SkillSpd}},
        {"e", {-self.SkillSpd, 0}},
        {"c", {0, -self.SkillSpd}},
        {"b", {0, self.SkillSpd}},
        {"d", {self.SkillSpd, 0}}
    }
    local Comb = {
        {{b, c}, function (self, colidir) self:Mover(-self.Spd, self.Spd, colidir) end, "eb"},
        {{b, a}, function (self, colidir) self:Mover(-self.Spd, -self.Spd, colidir) end, "ec"},
        {{d, a}, function (self, colidir) self:Mover(self.Spd, -self.Spd, colidir) end, "dc"},
        {{d, c}, function (self, colidir) self:Mover(self.Spd, self.Spd, colidir) end, "db"},
        {{b}, function (self, colidir) self:Mover(-self.Spd, 0, colidir) end, "e"},
        {{a}, function (self, colidir) self:Mover(0, -self.Spd, colidir) end, "c"},
        {{c}, function (self, colidir) self:Mover(0, self.Spd, colidir) end, "b"},
        {{d}, function (self, colidir) self:Mover(self.Spd, 0, colidir) end, "d"}
    }
    for _, combo in ipairs(Comb) do
        if teclasAtivas(combo[1]) then
            combo[2](self, colidir) -- MOVER
            self.UltimoMovimento = combo[3]
            self:rotacao()
            break
        end
    end
    if love.keyboard.isDown(e) then
        -- PRA CADA DIREÇÃO, DEFINE A ORIENTAÇÃO DA NAVE DEPENDENDO DA ULTIMA TECLA PRESSIONADA
        for _, v in ipairs(dir) do
            if v[1] == self.UltimoMovimento then
                self.OrientacaoX = v[2][1]
                self.OrientacaoY = v[2][2]
            end
        end
        if self.SkillCooldown <= 0 then
            self.SkillCooldown = self.Cd
            -- CRIA A SKILL
            table.insert(self.Skills_Ativas, Skill:new(self.OrientacaoX, self.OrientacaoY, self.X, self.Y, self.W, self.H))
        end
    end
end

function Classe1:colisao(obj)
    local x, y, w, h = GetPosX(self), GetPosY(self), GetW(self), GetH(self)
    local objX, objY, objW, objH = GetPosX(obj), GetPosY(obj), GetW(obj), GetH(obj)

    return x+w > objX and  x < objX+objW and  y+h > objY and  y < objY+objH
end

function Classe1:coletaPoder(poder, duracao, dt)
    poder.Ativar(self, duracao, dt)
end

function Classe1:rotacao()
    if self.UltimoMovimento == "c" then self.Rotacao = 1
    elseif self.UltimoMovimento == "dc" then self.Rotacao = 2
    elseif self.UltimoMovimento == "d" then self.Rotacao = 3
    elseif self.UltimoMovimento == "db" then self.Rotacao = 4
    elseif self.UltimoMovimento == "b" then self.Rotacao = 5
    elseif self.UltimoMovimento == "eb" then self.Rotacao = 6
    elseif self.UltimoMovimento == "e" then self.Rotacao = 7
    elseif self.UltimoMovimento == "ec" then self.Rotacao = 8
    end
end


-- HABILIDADE PRINCIPAL
function Skill:new(spdX, spdY, x, y, w, h)
    local nova_skill = {}

    -- AMONTOADO DE VARIÁVEL
    nova_skill.Raio = 10
    nova_skill.X, nova_skill.Y = x + w/2, y + h/2
    nova_skill.R, nova_skill.G, nova_skill.B = 255/255, 255/255, 255/255
    nova_skill.SpdX, nova_skill.SpdY = spdX, spdY


    setmetatable(nova_skill, {__index = Skill})
    return nova_skill
end

function Skill:MoveSkill()
    self.X = self.X + self.SpdX
    self.Y = self.Y + self.SpdY
end

function Skill:KillCond(...)
    for _, v in ipairs({...}) do
        if (self.X+self.Raio > v.X and
        self.X-self.Raio < v.X+v.W and
        self.Y+self.Raio > v.Y and
        self.Y-self.Raio < v.Y+v.H)
        then
            self:Hit(v)
            return true
        end
    end
    if self.X > love.graphics.getWidth() or
    self.Y > love.graphics.getHeight() or
    self.X < 0 or self.Y < 0 or
    self.DirX == 0 and self.DirY == 0 then
        return true
    end
end

function Skill:Hit(...)
    for _, v in ipairs({...}) do
        if v.HP then
            if v.HP > 0 then
                v.HP = v.HP - 1
            end
        end
    end
end


function GetPosX(obj) return obj.X end
function GetPosY(obj) return obj.Y end
function GetW(obj) return obj.W end
function GetH(obj) return obj.H end
function GetSpd(obj) return obj.Spd end

return Classe1, Skill
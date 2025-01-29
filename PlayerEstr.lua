Classe1 = {}
Skill = {}

function Classe1:new(pX, pY)
    local Obj = {}

    -- DEFINE AMONTOADO DE VARIÁVEL
    Obj.X, Obj.Y = pX, pY
    Obj.Spd = 5
    Obj.W, Obj.H = 100, 100
    Obj.HP = 5
    Obj.R, Obj.G, Obj.B = 255/255, 255/255, 255/255
    Obj.OrientacaoX, Obj.OrientacaoY = 0, 1
    Obj.UltimoMovimento = "c"
    Obj.teclasApertadas = {}

    Obj.Cd = 0.5
    Obj.SkillCooldown = 0
    Obj.Skills_Ativas = {}


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
            {"ec",{-self.Spd, self.Spd}},
            {"eb",{-self.Spd, -self.Spd}},
            {"dc",{self.Spd, -self.Spd}},
            {"db",{self.Spd, self.Spd}},
            {"e",{-self.Spd, 0}},
            {"c",{0, -self.Spd}},
            {"b",{0, self.Spd}},
            {"d",{self.Spd, 0}}
        }
        local Comb = {
            {{b, c}, function (self, colidir) self:Mover(-self.Spd, self.Spd, colidir) end, "ec"},
            {{b, a}, function (self, colidir) self:Mover(-self.Spd, -self.Spd, colidir) end, "eb"},
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
                break
            end
        end
        if love.keyboard.isDown(e) then
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

    return Obj
end


function Skill:new(dirX, dirY, x, y, w, h)
    local nova_skill = {}

    -- AMONTOADO DE VARIÁVEL
    nova_skill.Viva = true
    nova_skill.Spd = 10
    nova_skill.Raio = 10
    nova_skill.X, nova_skill.Y = x + w/2, y + h/2
    nova_skill.R, nova_skill.G, nova_skill.B = 255/255, 255/255, 255/255
    nova_skill.DirX, nova_skill.DirY = dirX, dirY


    setmetatable(nova_skill, {__index = Skill})

    function Skill:MoveSkill()
        self.X = self.X + self.DirX
        self.Y = self.Y + self.DirY
    end

    function Skill:KillCond(...)
        for _, v in ipairs({...}) do
            return self.X+self.Raio > v.X and
            self.X-self.Raio < v.X+v.W and
            self.Y+self.Raio > v.Y and
            self.Y-self.Raio < v.Y+v.H
        end
        return self.X > love.graphics.getWidth() or
        self.Y > love.graphics.getHeight() or
        self.X < 0 or self.Y < 0 or
        self.DirX == 0 and self.DirY == 0
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

    return nova_skill
end

function GetPosX(obj) return obj.X end
function GetPosY(obj) return obj.Y end
function GetW(obj) return obj.W end
function GetH(obj) return obj.H end
function GetSpd(obj) return obj.Spd end

return Classe1, Skill
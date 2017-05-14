io.stdout:setvbuf('no')

local L,A
local objetos = {}
local tempoNascimento = 3
local temporizador
local objLargura =  50
local objAltura = 50

local macacos = {}
local macacoLargura = 150
local macacoAltura = 200

function loadMacaco()
  for i=0,2 do --vai criar cada um dos 3 macacos
    local px = i*L/3 + L/6 --raia de cada macaco
    local macaco = {
      x = px - macacoLargura/2,
      y = A - macacoAltura,
      largura = macacoLargura,
      altura = macacoAltura
    }
    table.insert(macacos,macaco)
  end
end

function love.load()
  L,A = love.graphics.getDimensions()
  temporizador = 0
  loadMacaco()
end

function moverObjetos(dt)
  local obj
  for i=1,#objetos do
    obj = objetos[i]
    obj.y = obj.y + 80*dt
  end
end

function nascerObjeto(dt)
  temporizador = temporizador + dt
  if temporizador >= tempoNascimento then
    temporizador = 0
    local px = love.math.random(0,2)*L/3 + L/6 --pega a posicao da raia
    local obj = {
      x = px-objLargura/2,  --posicao x
      y = -objAltura,       --posicao y
      largura = objLargura, --largura
      altura = objAltura,   --altura
      tipo = love.math.random(1,2) --aleatorio, 1 é banana, 2 é bomba
    }
    table.insert(objetos,obj)
  end
end

function verificarContato(dt)
  local obj
  for i=#objetos,1,-1 do
    obj = objetos[i]
    if obj.y >= A then  --verifica se o objeto passou do fim da tela
      table.remove(objetos,i)
    end
  end
end

function love.update(dt)
  moverObjetos(dt)
  nascerObjeto(dt)
  verificarContato(dt)
end

function love.draw()
  local obj,mac
  --Desenha macaco
  love.graphics.setColor(123,80,200)
  for i=1,#macacos do
    mac = macacos[i]
    love.graphics.rectangle('fill',mac.x,mac.y,mac.largura,mac.altura)
  end
  
  --Desenha objetos
  for i=1,#objetos do
    obj = objetos[i]
    if obj.tipo == 1 then --se for banana, pinta de verde
      love.graphics.setColor(0,255,0)
    else --se for bomba pinta de vermelho
      love.graphics.setColor(255,0,0)
    end
    love.graphics.rectangle('fill',obj.x,obj.y,obj.largura,obj.altura)
  end
  love.graphics.setColor(255,255,255)
end
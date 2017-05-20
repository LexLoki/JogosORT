io.stdout:setvbuf('no')

local L,A
local objetos = {}
local tempoNascimento = 0.8
local temporizador
local objLargura =  50
local objAltura = 50

local macacos = {}
local macacoLargura = 150
local macacoAltura = 200

--tabelas de imagens
local macacoPega = {}
local macacoAbaixa = {}
local banana = {}
local bomba = {}

local function carregarImagens(caminho,quantidade)
  local imgs = {}
  for i=1,quantidade do
    imgs[i] = love.graphics.newImage(caminho .. i-1 .. '.png')
  end
  return imgs
end

function loadMacaco()
  macacoPega = carregarImagens('imagens/monkey_catching_',4)
  macacoPega.duracao = 0.3
  macacoAbaixa = carregarImagens('imagens/monkey_idle',2)
  macacoAbaixa.duracao = 0.75
  
  for i=0,2 do --vai criar cada um dos 3 macacos
    local px = i*L/3 + L/6 --raia de cada macaco
    local macaco = {
      x = px - macacoLargura/2,
      y = A - macacoAltura,
      largura = macacoLargura,
      altura = macacoAltura,
      estado = macacoAbaixa,
      temporizador = 0,
      quadro = 1
    }
    table.insert(macacos,macaco)
  end
end

function love.load()
  love.graphics.setDefaultFilter('nearest','nearest',1)
  L,A = love.graphics.getDimensions()
  temporizador = 0
  loadMacaco()
end

function moverObjetos(dt)
  local obj
  for i=1,#objetos do
    obj = objetos[i]
    obj.y = obj.y + 200*dt
  end
end

function nascerObjeto(dt)
  temporizador = temporizador + dt
  if temporizador >= tempoNascimento then
    temporizador = 0
    local rand = love.math.random(0,2)
    local px = rand*L/3 + L/6 --pega a posicao da raia
    local obj = {
      x = px-objLargura/2,  --posicao x
      y = -objAltura,       --posicao y
      largura = objLargura, --largura
      altura = objAltura,   --altura
      tipo = love.math.random(1,2), --aleatorio, 1 é banana, 2 é bomba
      raia = rand+1
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

function animarMacacos(dt)
  local mac
  for i=1, #macacos do
    mac = macacos[i]
    mac.temporizador = mac.temporizador + dt
    if mac.temporizador > mac.estado.duracao then
      mac.temporizador = 0
      mac.quadro = mac.quadro + 1
      if mac.quadro > #mac.estado then
        mac.quadro = 1
      end
    end
  end
end

function objetosContato(dt)
  local obj, raia, mac
  for i=#objetos, 1, -1 do
    obj = objetos[i]
    raia = obj.raia
    mac = macacos[raia]
    if mac.estado == macacoPega and mac.y > obj.y and mac.y < obj.y + obj.largura then
      table.remove(objetos,i)
    end
  end
end

function trocaEstado(macaco)
  macaco.quadro = 1
  if macaco.estado == macacoAbaixa then
    macaco.estado = macacoPega
  else
    macaco.estado = macacoAbaixa
  end
end

function love.update(dt)
  moverObjetos(dt)
  nascerObjeto(dt)
  verificarContato(dt)
  animarMacacos(dt)
  objetosContato(dt)
end

function love.mousepressed(x,y,button)
  local mac
  for i=1,#macacos do
    mac = macacos[i]
    if x > mac.x and x < mac.x+mac.largura and y > mac.y and y < mac.y+mac.altura then
      trocaEstado(mac)
    end
  end
end

function love.draw()
  local obj,mac
  --Desenha macaco
  love.graphics.setColor(255,255,255)
  for i=1,#macacos do
    mac = macacos[i]
    --love.graphics.rectangle('fill',mac.x,mac.y,mac.largura,mac.altura)
    love.graphics.draw(mac.estado[mac.quadro],mac.x,mac.y,0,2,2)
    --love.graphics.rectangle('fill',mac.x,mac.y,mac.largura,mac.altura)
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
io.stdout:setvbuf('no')

local L,A
local objetos = {}
local tempoNascimento = 0.8
local temporizador
local temporizadorProgressao
local velocidadeInicial = 200
local velocidade = velocidadeInicial
local objLargura =  50
local objAltura = 50
local macacos = {}
local macacoLargura = 150
local macacoAltura = 200

--tabelas de imagens
local macacoPega = {}
local macacoAbaixa = {}
local banana
local bomba
local fundo

local bombaSom
local bananaSom

local pontos
local nivel
local vidas
local gameover = false

local sx,sy = 2,2
local ox,oy = 1.5,1.5
local bx,by = 0.5,0.5


local function loadProporcional()
  local dw,dh = 800,600
  local w,h = love.graphics.getDimensions()
  macacoAltura = macacoAltura * h/dh
  macacoLargura = macacoLargura * w/dw
  objAltura = objAltura * h/dh
  objLargura = objLargura * w/dw
  velocidade = velocidade * h/dh
  sx = math.min(sx * w/dw, sy * h/dh)
  sy = sx
  ox = math.min(ox * w/dw, oy * h/dh)
  oy = ox
  bx = bx * w/dw
  by = by * h/dh
end

local function carregarImagens(caminho,quantidade)
  local imgs = {}
  for i=1,quantidade do
    imgs[i] = love.graphics.newImage(caminho .. i-1 .. '.png')
  end
  return imgs
end

function loadMacaco()
  macacoPega = carregarImagens('imagens/monkey_catching_',4)
  --[[
  local len = #macacoPega
  for i=1,len do
    macacoPega[len+i] = macacoPega[len+1-i]
  end]]
  macacoPega.duracao = 0.15
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
  loadProporcional()
  love.graphics.setDefaultFilter('nearest','nearest',1)
  L,A = love.graphics.getDimensions()
  temporizador = 0
  temporizadorProgressao = 0
  loadMacaco()
  banana = love.graphics.newImage('imagens/banana.png')
  bomba = love.graphics.newImage('imagens/bomb_0.png')
  fundo = love.graphics.newImage('imagens/background.png')
  pontos = 0
  local fonte = love.graphics.newFont(30)
  love.graphics.setFont(fonte)
  
  vidas = 3
  
  bombaSom = love.audio.newSource('bomb.mp3')
  bananaSom = love.audio.newSource('pick.mp3')
  nivel = 1
end

function moverObjetos(dt)
  local obj
  for i=1,#objetos do
    obj = objetos[i]
    obj.y = obj.y + velocidade*dt
  end
end

function nascerObjeto(dt)
  temporizador = temporizador + dt
  temporizadorProgressao = temporizadorProgressao + dt
  if temporizadorProgressao > 10 then
    nivel = nivel+1
    temporizadorProgressao = 0
    tempoNascimento = tempoNascimento*0.9
    velocidade = velocidade*1.1
  end
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
    if mac.estado == macacoAbaixa or mac.on then
      mac.temporizador = mac.temporizador + dt
      if mac.temporizador > mac.estado.duracao then
        mac.temporizador = 0
        mac.quadro = mac.quadro + 1
        if mac.quadro > #mac.estado then
          if mac.estado == macacoPega then
            mac.quadro = 3
            mac.on = false
          else
            mac.quadro = 1
          end
        end
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
    local mao = mac.y + mac.altura*0.15
    if mac.estado == macacoPega and mao > obj.y and mao < obj.y + obj.largura then
      --Pegou banana ou bomba
      table.remove(objetos,i)
      if obj.tipo == 1 then
        bananaSom:rewind()
        bananaSom:play()
        pontos = pontos + 1
        mac.quadro = 4
        mac.on = true
        mac.temporizador = 0
      else
        bombaSom:rewind()
        bombaSom:play()
        vidas = vidas - 1
        if vidas==0 then
          gameover = true
        end
      end
    end
  end
end

function trocaEstado(macaco)
  macaco.quadro = 1
  if macaco.estado == macacoAbaixa then
    macaco.estado = macacoPega
    macaco.quadro = 3
  else
    macaco.estado = macacoAbaixa
  end
end

function love.update(dt)
  if not gameover then
    moverObjetos(dt)
    nascerObjeto(dt)
    verificarContato(dt)
    animarMacacos(dt)
    objetosContato(dt)
  end
end

function love.keypressed(key)
  if gameover then
    if key=='return' then
      velocidade = velocidadeInicial
      gameover = false
      temporizador = 0
      temporizadorProgressao = 0
      nivel = 1
      pontos = 0
      vidas = 3
      objetos = {}
    end
  end
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

function love.touchpressed(id,x,y)
  print(x,y)
  --love.mousepressed(x,y,1)
end

function love.draw()
  local obj,mac
  love.graphics.setColor(255,255,255)
  love.graphics.draw(fundo,0,0,0,bx,by)
  --Desenha macaco
  for i=1,#macacos do
    mac = macacos[i]
    --love.graphics.rectangle('fill',mac.x,mac.y,mac.largura,mac.altura)
    love.graphics.draw(mac.estado[mac.quadro],mac.x,mac.y,0,sx,sy)
    --love.graphics.rectangle('line',mac.x,mac.y+0.1*mac.altura,mac.largura,mac.altura)
  end
  
  --Desenha objetos
  for i=1,#objetos do
    obj = objetos[i]
    local imagem
    if obj.tipo == 1 then --se for banana, pinta de verde
      imagem = banana
    else --se for bomba pinta de vermelho
      imagem = bomba
    end
    --love.graphics.rectangle('fill',obj.x,obj.y,obj.largura,obj.altura)
    love.graphics.draw(imagem,obj.x,obj.y,0,ox,oy)
  end
  
  love.graphics.setColor(255,255,255)
  love.graphics.print('Pontos: '..pontos)
  love.graphics.printf('Vidas: '..vidas,0,0,L,'right')
  love.graphics.printf('Nivel\n'..nivel,0,0,L,'center')
  if gameover then
    love.graphics.printf('Fim de Jogo\nPressione enter para tentar novamente',0,200,L,'center')
  end
end
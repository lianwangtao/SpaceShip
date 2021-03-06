enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('enemy.png')
spawntimer = 2




-- check if the enemies is hit by a bullet
function checkCollisons(enemies, bullets)
  for i, e in ipairs(enemies) do
    for _, b in pairs(bullets) do
      if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
        table.remove(enemies, i)
      end
    end
  end
end


-- load elements before game start
function love.load()
  local music = love.audio.newSource('backtrack.mp3')
  music:setLooping(true)
  love.audio.play(music)
 
  game_over = false

  game_over_img = love.graphics.newImage('gameover.jpg')
  
  background_image = love.graphics.newImage('Background.jpg')
  
  
  player = {}
  player.x = 0
  player.y = 500
  player.bullets = {}
  player.cooldown = 15
  player.speed = 3
  player.image = love.graphics.newImage('spaceship.png')
  player.fire_sound = love.audio.newSource('laser.mp3')
  player.fire = function()
    
    
    if player.cooldown <= 0 then
      love.audio.play(player.fire_sound)
      player.cooldown = 20
      bullet = {}
      bullet.x = player.x + 35
      bullet.y = player.y
      bullet.image = love.graphics.newImage('bullet.png')
      table.insert(player.bullets, bullet)
    end
  end
  
  
end

-- spawn enemy with certain number and speed
function enemies_controller:spawnEnemy(x, y)
  enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.height = 30
  enemy.width = 100
  enemy.bullets = {}
  enemy.cooldown = 15
  enemy.speed = 13
  table.insert(self.enemies, enemy)
end


function enemy:fire()
  if self.cooldown <= 0 then
    self.cooldown = 20
    bullet = {}
    bullet.x = player.x + 35
    bullet.y = player.y
    table.insert(self.bullets, bullet)
  end

end


function love.update(dt)
  
  player.cooldown = player.cooldown - 1
  
  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed
  elseif  love.keyboard.isDown("left") then
    player.x = player.x - player.speed
  end

  if love.keyboard.isDown(" ") then
    player.fire()
  end
  for i,b in ipairs(player.bullets) do
    if b.y < -10 then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 10
  end

  

  for _,e in pairs(enemies_controller.enemies) do
    -- check if enemies reached the end of the screen 
    if e.y >= love.graphics.getHeight() then
      game_over = true
    end
    e.y = e.y + 1
  end

  --spawn enemies at a certain rate
  spawntimer = spawntimer - dt
  if spawntimer <= 0 then
    enemies_controller:spawnEnemy(love.math.random(500), 0)
    local leftover = math.abs(spawntimer)
    spawntimer = 2 - leftover
  end

  checkCollisons(enemies_controller.enemies, player.bullets) 

end


function love.draw()
  
  if game_over then
    
    love.graphics.draw(game_over_img)
    love.audio.stop()
    return
  elseif game_win then
    love.graphics.print("You Won!")
  end
  
  
  love.graphics.draw(background_image)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(player.image, player.x, player.y, 0, 0.5)
  
  
  --draw bullets
  for _,v in pairs(player.bullets) do
    love.graphics.draw(bullet.image, v.x, v.y, 8, 0.1)
  end


  --draw enemies
  for _,e in pairs(enemies_controller.enemies) do
    love.graphics.draw(enemies_controller.image, e.x, e.y, 0, 0.5)
  end


end
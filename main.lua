local AdvTiledLoader = require("AdvTiledLoader.Loader")
require("camera")
require("menu")
require("player")
require("ANal")

function love.load()
	--Window Dimesions
	WindowHeight = love.graphics.getHeight()
	WindowWidth = love.graphics.getWidth()
	--Initial Loading
	MenuFont = love.graphics.newFont("textures/Assasin.ttf", 24)
	love.graphics.setBackgroundColor( 255, 255, 255)
	ImageBackground = love.graphics.newImage("textures/background.png")
	ImageMenu = love.graphics.newImage("textures/MenuImageBrown.jpg")
	gamestate = "menu"
	--Maps
	AdvTiledLoader.path = "maps/"
	map = AdvTiledLoader.load("map.tmx")
	map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)
	camera:setBounds(0, 0, map.width * map.tileWidth - love.graphics.getWidth(), map.height * map.tileHeight - love.graphics.getHeight() )
	--Menu
		--Buttons
		button_spawn(WindowWidth / 2 - WindowWidth / 20, WindowHeight / 3, "Start", "start")
		button_spawn(WindowWidth / 2 - WindowWidth / 20 + 5, WindowHeight / 3 * 2, "Quit", "quit")
		button_spawn( WindowWidth - WindowWidth / 10, 0, "Pause", "playingpause")
		button_spawn(WindowWidth / 2 - WindowWidth / 16, WindowHeight / 3, "Resume", "pauseplaying")
	--Player
	
end

function love.draw()
	if gamestate == "playing" then
		camera:set()
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.draw(ImageBackground, 0, 0, 0, 1, 1, 0, 0)
		player:draw()
		map:draw()
		camera:unset()
		button_draw()
	elseif gamestate == "menu" then
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.draw(ImageMenu, 0, 0, 0, 1, 1, 0, 0)
		button_draw()
	elseif gamestate == "paused" then
		love.graphics.setColor( 255, 255, 255)
		love.graphics.draw(ImageMenu, 0, 0, 0, 1, 1, 0, 0)
		button_draw()
	end
end

function love.update(dt)
	fps = love.timer.getFPS()
	if dt > 0.05 then
		dt = 0.02
	end
	if gamestate == "paused" then
		return end
	if love.keyboard.isDown("d") then
		Ddown = true
		player:right(dt)
	end
	if love.keyboard.isDown("a") then
		Adown = true
		player:left(dt)
	end
	if love.keyboard.isDown(" ") and not(hasJumped) then
		player:jump(dt)
	end
	if love.keyboard.isDown("f3") then
		debug = true
		print("FPS:" .. fps .. "")
	end
	player:update(dt)
	camera:setPosition( player.x - (WindowWidth/2), player.y - (WindowHeight/2))
end


function love.keyreleased(key)
	if (key == "a") or (key == "d") then
		player.x_vel = 1
	end
	if key == "a" then 
		Adown = false
		lastKey = "a"
	end
	if key == "d" then
		Ddown = false
		lastKey = "d"
	end
end

function love.focus(f)--used for auto pause    
	if not f then
	 	print("Focus Lost")
	else
		print("Focus Gained")
	end
end

function love.mousepressed(x, y)
	button_click(x, y)
end

function love.keypressed(key)
	if key == "d" then
		if Adown == true then 
			Adown = false
			print("A was down")
		end
	end
	if key == "a" then
		if Ddown == true then 
			Ddown = false
			print("D was down")
		end
	end
	if key == " " then
		if lastKey == "d" then
			Ddown = true
		elseif lastKey =="a" then
			Adown = true
		end
	end
end

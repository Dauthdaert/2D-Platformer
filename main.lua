local AdvTiledLoader = require("libs/AdvTiledLoader.Loader")
require("Ancilliary/camera")
require("Ancilliary/menu")
require("Ancilliary/player")
require("Ancilliary/FileManagement")
require("Ancilliary/ImageManagement")
require("libs/ANal")

math.randomseed(os.time())
math.random()
math.random()
math.random()

function love.load(args)
	--Coroutine Making
	local FileLoadCo = coroutine.create(File.load)
	print("" .. coroutine.status(FileLoadCo).. "")
	local ImageLoadCo = coroutine.create(Image.load)
	print("" .. coroutine.status(ImageLoadCo).. "")
	local FontLoadCo = coroutine.create(Font.load)
	print("" .. coroutine.status(FontLoadCo).. "")
	FileQuitCo = coroutine.create(File.quit)
	print("" .. coroutine.status(FileQuitCo).. "")
	local ButtonSpawnCo = coroutine.create(button.define)
	print("" .. coroutine.status(ButtonSpawnCo).. "")
	--Window Dimesions
	WindowHeight = love.graphics.getHeight()
	WindowWidth = love.graphics.getWidth()
	--Initial Loading(Images and Fonts)
	coroutine.resume(ImageLoadCo)
	coroutine.resume(FontLoadCo)
	gamestate = "menu"
	--Initial Loading(Savegames and Configs)
	coroutine.resume(FileLoadCo)
	--Folder Enum
	filesString = recursiveEnumerate("", "")
	print(filesString)
	--Maps
	AdvTiledLoader.path = "textures/maps/"
	map = AdvTiledLoader.load("map.tmx")
	map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)
	camera:setBounds(0, 0, map.width * map.tileWidth - love.graphics.getWidth(), map.height * map.tileHeight - love.graphics.getHeight() )
	--Menu
		--Buttons
		coroutine.resume(ButtonSpawnCo)
	--Player
	--Parralax Settings
	camera.layers = {}
		--Parralax Test Features
		for i = .5, 3, .5 do
			local rectangles = {}

			for j = 1, math.random(2, 15) do
					table.insert(rectangles, {
				math.random(0, 1600),
				math.random(0, 1600),
					math.random(50, 400),
				math.random(50, 400),
				color = { math.random(0, 255), math.random(0, 255), math.random(0, 255) }
				})
			end

			camera:newLayer(i, function()
				for _, v in ipairs(rectangles) do
					love.graphics.setColor(v.color)
					love.graphics.rectangle('fill', unpack(v))
					love.graphics.setColor(255, 255, 255)
				end
			end)
		end
end

-- This function will return a string filetree of all files in the folder and files in all subfolders
function recursiveEnumerate(folder, fileTree)
    local lfs = love.filesystem
    local filesTable = lfs.enumerate(folder)
    for i,v in ipairs(filesTable) do
        local file = folder.."/"..v
        if lfs.isFile(file) then
            fileTree = fileTree.."\n"..file
        elseif lfs.isDirectory(file) then
            fileTree = fileTree.."\n"..file.." (DIR)"
            fileTree = recursiveEnumerate(file, fileTree)
        end
    end
    return fileTree
end

function love.draw()
	--Playing Draw
	if gamestate == "playing" then
		camera:draw()
		button_draw()
	--Menu Draw
	elseif gamestate == "menu" then
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.draw(ImageMenu, 0, 0, 0, 1, 1, 0, 0)
		button_draw()
	--Paused Menu Draw
	elseif gamestate == "paused" then
		love.graphics.setColor( 255, 255, 255)
		love.graphics.draw(ImageMenu, 0, 0, 0, 1, 1, 0, 0)
		button_draw()
	elseif gamestate == "options" then
		love.graphics.setColor( 255, 255, 255)
		love.graphics.draw(ImageMenu, 0, 0, 0, 1, 1, 0, 0)
		button_draw()
	end
end

function love.update(dt)
	--Anim Normalisation
	if dt > 0.05 then
		dt = 0.02
	end
	--Game Pausing
	if gamestate == "paused" then
		return end
	--Movement
		if love.keyboard.isDown("d") then
			Ddown = true
			player:right(dt)
			if Adown then
				Adown = false
				lastKey = "a"
			end
		end
		if love.keyboard.isDown("a") then
			Adown = true
			player:left(dt)
			if Ddown then
				Ddown = false
				lastKey = "d"
			end
		end
		if love.keyboard.isDown(" ") and not hasJumped then
			player:jump(dt)
		end
	--End Movement
	--Debug
	if love.keyboard.isDown("f3") then
		debug = true
		local fps = love.timer.getFPS()
		print("FPS:" .. fps .. "")
	end
	--Player and Camera Updates
	player:update(dt)
	camera:setPosition( player.x - (WindowWidth/2), player.y - (WindowHeight/2))
end


function love.keyreleased(key)
	if (key == "a") or (key == "d") then
		player.x_vel = 1
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
	--Animation reset(On jump)
	if key == " " then
		if lastKey == "d" then
			Ddown = true
		elseif lastKey =="a" then
			Adown = true
		end
	end
end

function love.quit()
	coroutine.resume(FileQuitCo)
end
File = {}

function File.load()
	local filepresent = love.filesystem.enumerate(love.filesystem.getSaveDirectory())
	local savedirpresent = love.filesystem.exists("savegames")
		if not savedirpresent then
			love.filesystem.mkdir("savegames")
		end
	local configdirpresent = love.filesystem.exists("Config")
		if not savedirpresent then
			love.filesystem.mkdir("Config")
		end
	local savepresent = love.filesystem.exists("savegames/save.txt")
	print(savepresent)
	local configpresent = love.filesystem.exists("Config/config.txt")
	print(configpresent)
	lvlstate = "lvl1"
	savebitsize = 4
	BaseConfig = "lvl1"
	configbitsize = 4
		if not savepresent then
			love.filesystem.write( "savegames/save.txt", "" .. lvlstate .. "", savebitsize)
			print("Save not present")
		elseif savepresent then
			savecontent, savebitsize = love.filesystem.read("savegames/save.txt")
			print("" .. savecontent .. "")
			print("" .. savebitsize .. "")
		end
		if not configpresent then
			love.filesystem.write( "Config/config.txt", "" .. BaseConfig .. "", configbitsize)
			print("Config not present")
		elseif configpresent then
			configcontent, configbitsize = love.filesystem.read("Config/config.txt")
			print("" .. configcontent .. "")
			print("" .. configbitsize .. "")
		end
end

function File.Update()

end

function File.quit()
	savebitsize = savebitsize
	love.filesystem.write( "savegames/save.txt", "" .. lvlstate .. "", savebitsize)
	configbitsize = configbitsize
	love.filesystem.write( "Config/config.txt", "" .. UpdatedConfig .. "", configbitsize)
end
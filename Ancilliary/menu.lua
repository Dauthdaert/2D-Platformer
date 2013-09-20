button = {}

function button_spawn(x, y, text, id)
	table.insert(button, {x = x, y = y, text = text, id = id})
end

function button.define()
	button_spawn(WindowWidth / 2 - WindowWidth / 20, WindowHeight / 3, "Start", "start")
	button_spawn(WindowWidth / 2 - WindowWidth / 20 + 5, WindowHeight / 3 * 2, "Quit", "quit")
	button_spawn(WindowWidth - WindowWidth / 10, 0, "Pause", "playingpause")
	button_spawn(WindowWidth / 2 - WindowWidth / 16, WindowHeight / 3, "Resume", "pauseplaying")
	button_spawn(0, 0, "Options", "options")
	button_spawn(WindowWidth / 2 - WindowWidth / 20, WindowHeight / 3 * 3, "Config", "configupdate")
end

function button_draw()
	for i,v in ipairs(button) do
		love.graphics.setColor( 77, 81, 68)
		if gamestate == "menu" then
			if v.id == "start" then
				love.graphics.rectangle("fill", WindowWidth / 2 - WindowWidth / 15, WindowHeight / 3, MenuFont:getWidth(v.text)*1.5, MenuFont:getHeight(v.text))
			elseif v.id == "quit" then
				love.graphics.rectangle("fill", WindowWidth / 2 - WindowWidth / 15+ 10, WindowHeight / 3 * 2, MenuFont:getWidth(v.text)*1.5,MenuFont:getHeight(v.text))
			elseif v.id == "options" then
				love.graphics.rectangle("fill", 0, 0, MenuFont:getWidth(v.text)*1.5,MenuFont:getHeight(v.text))
			end
		elseif gamestate == "paused" then
			if v.id == "pauseplaying" then
				love.graphics.rectangle("fill", WindowWidth / 2 - WindowWidth / 13, WindowHeight / 3, MenuFont:getWidth(v.text)*1.3, MenuFont:getHeight(v.text))
			elseif v.id == "quit" then
				love.graphics.rectangle("fill", WindowWidth / 2 - WindowWidth / 15 + 10, WindowHeight / 3 * 2, MenuFont:getWidth(v.text)*1.5, MenuFont:getHeight(v.text))
			elseif v.id == "options" then
				love.graphics.rectangle("fill", 0, 0, MenuFont:getWidth(v.text)*1.5,MenuFont:getHeight(v.text))
			end
		end
		love.graphics.setColor( 0, 0, 0)
		love.graphics.setFont(MenuFont)
		if v.id == "start" and gamestate == "menu" then
			love.graphics.print(v.text, v.x, v.y)
		elseif v.id == "quit" and gamestate == "menu" then
			love.graphics.print(v.text, v.x, v.y)
		elseif v.id == "playingpause" and gamestate == "playing" then
			love.graphics.print(v.text, v.x, v.y)
		elseif v.id == "pauseplaying" and gamestate == "paused" then
			love.graphics.print(v.text, v.x, v.y)
		elseif v.id == "quit" and gamestate == "paused" then
			love.graphics.print(v.text, v.x, v.y)
		elseif v.id == "options" and gamestate == "menu" or gamestate == "paused" then
			love.graphics.print(v.text, v.x, v.y)
		elseif v.id == "configupdate" and gamestate == "options" then
			love.graphics.print(v.text, v.x, v.y)
		end
	end
end

function button_click(x, y)
	for i,v in ipairs(button) do
		if x > v.x and
		 x < v.x + MenuFont:getWidth(v.text) and
		 y > v.y and
		 y < v.y + MenuFont:getHeight(v.text) then
		 	if gamestate == "menu" then
		 		if v.id == "quit" then
		 			love.event.push("quit")
		 		elseif v.id == "start" then
		 			gamestate = "playing"
		 		elseif v.id == "options" then
		 			gamestate = "options"
		 		end
		 	end
		 	if gamestate == "playing" then
		 		if v.id == "playingpause" then
		 			gamestate = "paused"
		 		end
		 	end
		 	if gamestate == "paused" then
		 		if v.id == "pauseplaying" then
		 			gamestate = "playing"
		 		elseif v.id == "quit" then
		 			love.event.push("quit")
				elseif v.id == "options" then
					gamestate = "options"
				end
			end
		end
	end
end
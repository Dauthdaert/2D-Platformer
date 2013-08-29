require("camera")
require("ANal")
local AdvTiledLoader = require("AdvTiledLoader.Loader")
player = {}


local WarriorR = love.graphics.newImage("textures/Animations/WarriorR.png")
WarriorRAnim = newAnimation(WarriorR, 28, 37, 0.2, 4)
local WarriorL = love.graphics.newImage("textures/Animations/WarriorL.png")
WarriorLAnim = newAnimation(WarriorL, 28, 37, 0.2, 4)
local RRestAnim = love.graphics.newImage("textures/Animations/WarriorRRest.png")
local LRestAnim = love.graphics.newImage("textures/Animations/WarriorLRest.png")

	world = 	{
				gravity = 1536,
				ground = 512,
				}

	player = 	{
				x = 256,
				y = 256,
				x_vel = 0,
				y_vel = 0,
				jump_vel = -768,
				speed = 386,
				flySpeed = 525,
				state = "",
				h = 32, 
				w = 32,
				standing = false,
				health = 100,
				}
	function player:jump()
		if self.standing then
			self.y_vel = self.jump_vel
			self.standing = false
		end
	end

	function player:right(dt)
		self.x_vel = self.speed
		WarriorRAnim:update(dt)
	end

	function player:left(dt)
		self.x_vel = -1 * (self.speed)
		WarriorLAnim:update(dt)
	end

	function player:stop()
		self.x_vel = 0
	end

	function player:collide(event)
		if event == "floor" then
			self.y_vel = 0 
			--player.health = player.health - 1
			self.standing = true
		end
		if event == "cieling" then
			self.y_vel = 0
		end
	end

	function player:update(dt)
		local halfX = self.w / 2
		local halfY = self.h / 2

		self.y_vel = self.y_vel + (world.gravity * dt)

		self.x_vel = math.clamp(self.x_vel, -self.speed, self.speed)
		self.y_vel = math.clamp(self.y_vel, -self.flySpeed, self.flySpeed)

		local nextY = self.y + (self.y_vel*dt)
		if self.y_vel < 0 then
			if not (self:isColliding(map, self.x - halfX, nextY - halfY))
				and not (self:isColliding(map, self.x + halfX - 1, nextY - halfY)) then
				self.y = nextY
				self.standing = false
			else
				self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
				self:collide("cieling")
			end
		end
		if self.y_vel > 0 then
			if not (self:isColliding(map, self.x-halfX, nextY + halfY))
				and not(self:isColliding(map, self.x + halfX - 1, nextY + halfY)) then
					self.y = nextY
					self.standing = false
			else
				self.y = nextY - ((nextY + halfY) % map.tileHeight)
				self:collide("floor")
			end
		end

		local nextX = self.x + (self.x_vel * dt)
		if self.x_vel > 0 then
			if not(self:isColliding(map, nextX + halfX, self.y - halfY))
				and not(self:isColliding(map, nextX + halfX, self.y + halfY - 1)) then
				self.x = nextX
			else
				self.x = nextX - ((nextX + halfX) % map.tileWidth)
			end
		elseif self.x_vel < 0 then
			if not(self:isColliding(map, nextX - halfX, self.y - halfY))
				and not(self:isColliding(map, nextX - halfX, self.y + halfY - 1)) then
				self.x = nextX
			else
				self.x = nextX + map.tileWidth - ((nextX - halfX) % map.tileWidth)
			end
		end
		self.state = self:getState()
	end

	function player:isColliding(map, x, y)
		local layer = map.tl["Solid"]
		local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
		local tile = layer.tileData(tileX, tileY)
		return not(tile == nil)
	end

	function player:getState()
		local tempState = ""
		if self.standing then
			if self.x_vel > 0 then
				tempState = "right"
			elseif self.x_vel < 0 then
				tempState = "left"
			else
				tampState = "stand"
			end
		end
		if self.y_vel > 0 then
			tempState = "fall"
		elseif self.y_vel < 0 then
			tempState = "jump"
		end
		return tempState
	end

	function player:draw()
	love.graphics.setColor( 255, 255, 255)
		if lastKey == " " then
			love.graphics.draw(RRestAnim, player.x - player.w/2, player.y - player.h/2, 0, 1, 1, 0, 0)
		elseif not lastKey and not Ddown and not Adown then
			love.graphics.draw(RRestAnim, player.x - player.w/2, player.y - player.h/2, 0, 1, 1, 0, 0)
		elseif lastKey == "d" and not Ddown and not Adown then
			love.graphics.draw(RRestAnim, player.x - player.w/2, player.y - player.h/2, 0, 1, 1, 0, 0)
		elseif lastKey == "a" and not Ddown and not Adown then
			love.graphics.draw(LRestAnim, player.x - player.w/2, player.y - player.h/2, 0, 1, 1, 0, 0)	
		elseif Ddown then
			WarriorRAnim:draw( player.x - player.w/2, player.y - player.h/2)
		elseif Adown then
			WarriorLAnim:draw( player.x - player.w/2, player.y - player.h/2)
		end
	print("" .. player.health .. "")
	end
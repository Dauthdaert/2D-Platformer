Image = {}
Font = {}

function Image.load()
	love.graphics.setBackgroundColor( 255, 255, 255)
	ImageBackgroundLev1 = love.graphics.newImage("textures/background.png")
	ImageMenu = love.graphics.newImage("textures/MenuImageBrown.jpg")
end

function Font.load()
	MenuFont = love.graphics.newFont("textures/Fonts/Assasin.ttf", 24)
end
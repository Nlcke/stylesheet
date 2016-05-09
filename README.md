# Stylesheet
This Gideros library gives you new way of coding similar to Qt stylesheets:
```lua
stage {
	TextField {
		description = "Black text, standard font.", -- custom field
		new = {nil, "Hello, Gideros"},
		x = 100,
		y = 100,
		scale = 3,
		Path2D {
			svgPath = "M8.64,223.948c0,0,143.468,3.431,185.777-181.808c2.673-11.702-1.23-20.154,1.316-33.146h16.287c0,0-3.14,17.248,1.095,30.848c21.392,68.692-4.179,242.343-204.227,196.59L8.64,223.948z",
			scale = 0.25,
			lineThickness = 5,
			fillColor_ = {0xFFFF80, 0.5},
			position_ = {30, 30},
			enterFrame = function(self)
				self:setRotation(self:getRotation()+1)
			end,
		},
		TextField {
			text = "stylesheets",
			textColor = 0xFF0000,
			x = 0,
			y = 10,
			alpha = 0.4,
			rotation = 30,
			mouseDown = function(self)
				self:setRotation(math.random(0, 360))
			end,
		}
	}
}
```

It also allows to name, add, access and remove child elements through `._.name` or `._[name]`:
```lua
stage._.sprite = Sprite.new()
stage._.sprite._.hello = TextField.new(nil, "hello")
stage._.sprite._.hello:setPosition(300, 200)
stage._.sprite._.world = TextField.new(nil, "world")
stage._.sprite._.world:setPosition(300, 220)
 
stage._[1] = TextField.new(nil, "index")
stage._[1]:setPosition(300, 300)
stage._[1] = nil
 
stage._.sprite._.subsprite = Sprite.new()
stage._.sprite._.subsprite:setPosition(100, 100)
stage._.sprite._.subsprite._.text = TextField.new(nil, "text")
stage._.sprite._.subsprite._.text:setScale(3)
 
stage._.sprite { -- update sprite
	new = false, -- indicates this sprite is not new one
	position_ = {40, 60},
	alpha = 0.7,
	rotation = 45,
}
```
Rewritten Gideros 'Getting Started' code with the Stylesheet library looks like this:
```lua
stage {
	Bitmap {
		new = {Texture.new "field.png"},
	},
	Bitmap {
		new = {Texture.new "ball.png"},
		xdirection = 1,
		ydirection = 1,
		xspeed = 2.5,
		yspeed = 4.3,
		enterFrame = function(ball)
			local x = ball:getX() + (ball.xspeed * ball.xdirection)
			local y = ball:getY() + (ball.yspeed * ball.ydirection)
 
			if x < 0 then ball.xdirection = 1 end
			if x > 320 - ball:getWidth() then ball.xdirection = -1 end
			if y < 0 then ball.ydirection = 1 end
			if y > 480 - ball:getHeight() then ball.ydirection = -1 end
 
			ball:setPosition(x, y)		
		end
	}
}
```
## Installation
Just add `Stylesheet.lua` file to your Gideros project without the need to require it.

## Custom classes
To enable Stylesheet support inside custom classes add `self:improve()` at the top of your `init` method:
```lua
Rectangle = Core.class(Sprite)
 
function Rectangle:init(w, h, c, a)
	self:improve()
	self._.mesh = Mesh {
		indexArray_ = {1, 2, 3, 1, 3, 4},
		vertices_ = {1,0,0, 2,w,0, 3,w,h, 4,0,h},
		colorArray_ = {c, a, c, a, c, a, c, a}
	}
end
```
## The API:
```lua
parent._.child           -- access child sprite
parent._.child = sprite  -- add (or replace old) child sprite
parent._[index] = sprite -- add (or replace old) child at index
parent._.child = nil     -- remove child sprite
parent{child{...}, ...}  -- add child sprites
parent{new = {...}}      -- pass arguments to 'new' method
parent{id = value}       -- assign a name to the sprite
parent{event = function} -- add event listeners
parent{setter = value}   -- call one-arg setters
parent{setter_ = {...}}  -- call multi-arg setters
parent{field = value}    -- add custom fields
parent{new = false, ...} -- update sprite
```
## Discussion on Gideros forum
http://giderosmobile.com/forum/discussion/6436/stylesheet-library

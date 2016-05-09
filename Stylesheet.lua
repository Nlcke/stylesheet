---------------------------------API---------------------------------
-- parent._.child           -- access child sprite                 --
-- parent._.child = sprite  -- add (or replace old) child sprite   --
-- parent._[index] = sprite -- add (or replace old) child at index --
-- parent._.child = nil     -- remove child sprite                 --
-- parent{child{...}, ...}  -- add child sprites                   --
-- parent{new = {...}, ...} -- pass arguments to 'new' method      --
-- parent{id = value}       -- assign a name to the sprite         --
-- parent{event = function} -- add event listeners                 --
-- parent{setter = value}   -- call one-arg setters                --
-- parent{setter_ = {...}}  -- call multi-arg setters              --
-- parent{field = value}    -- add custom fields                   --
-- parent{new = false, ...} -- update sprite                       --
---------------------------------------------------------------------

-- create stylesheets
local function __call(t, p)
	local s = nil
	if p.new == false or t == stage or t == layout then s = t
	elseif p.new then s = t.new(unpack(p.new))
	else s = t.new() end
	for k,v in ipairs(p) do
		if v.id ~= nil then
			if s.__[v.id] then s.__[v.id]:removeFromParent() end
			s.__[v.id] = v
		end
		s:addChild(v)
	end
	for k,v in pairs(p) do
		if tonumber(k) ~= k then
			local f = "set"..k:sub(1,1):upper()..k:sub(2)
			if s[f] then
				s[f](s, v)
			elseif f:sub(-1) == "_" then
				f = f:sub(1, -2)
				if s[f] then s[f](s, unpack(v)) end
			elseif type(v) == "function" then
				s:addEventListener(k, v, s)
			elseif k ~= "new" then
				s[k] = v
			end
		end
	end
	return s
end

-- access sprites by their names
local function __newindex(t, k, v)
	local sprite = t.__sprite
	if v ~= nil then
		if tonumber(k) == k then
			sprite:addChildAt(v, k)
		else
			sprite:addChild(v)
		end
		if sprite.__[k] then
			sprite.__[k]:removeFromParent()
		end
		sprite.__[k] = v
	else
		sprite.__[k]:removeFromParent()
		sprite.__[k] = nil
	end
end

-- improve sprite to support in stylesheets
function Sprite.improve(sprite)
	getmetatable(sprite).__call = __call
	if not rawget(sprite, "_") then
		sprite._ = {__sprite = sprite}
		sprite.__ = {}
		setmetatable(sprite._, {
			__newindex = __newindex,
			__index = sprite.__
		})
	end
end

-- patch all sprite classes
for k,v in pairs(_G) do
	if type(v) == "table" and v.__classname then
		Sprite.improve(v)
		v._new = v.new
		v.new = function(...)
			local s = v._new(...)
			Sprite.improve(s)
			return s
		end
	end
end
import "CoreLibs/sprites"

Tile = {}
class("Tile").extends(Graphics.sprite)

local floor = playdate.graphics.image.new("assets/images/floor")

function Tile:init(__x, __y)
	Tile.super.init(self)

    self:setImage(floor)
	self:setCollideRect(0,0,32,32)
    self:moveTo(__x, __y)

    -- self:add();
end

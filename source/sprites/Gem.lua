Gem = {}
class("Gem").extends(NobleSprite)

function Gem:init(entity)
	Hero.super.init(self, "assets/images/gem", true)
    
	self.animation:addState("sparkling", 1, 6, nil, nil, nil, 6)
    
	self:setZIndex(entity.zIndex)
	self:moveTo(entity.position.x, entity.position.y)
	self:setCenter(entity.center.x, entity.center.y)
    self:setSize(16, 16)
	self:setCollideRect(3, 2, 12, 14)
end

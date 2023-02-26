Hero = {}
class("Hero").extends(NobleSprite)

function Hero:init(entity)
	Hero.super.init(self, "assets/images/hero", true)
    
	self.animation:addState("idle", 12, 18, nil, nil, nil, 3)
	self.animation:addState("walk", 1, 11, nil, nil, nil, 3)

	self:setZIndex(entity.zIndex)
	self:moveTo(entity.position.x, entity.position.y)
	self:setCenter(entity.center.x, entity.center.y)
    
    self:setSize(16, 16)

    self.downwardSpeed = 4

    self.direction = 0

    if entity.fields.EntranceDirection == Utilities.EAST then
        self.animation.direction = Noble.Animation.DIRECTION_RIGHT
    else
        self.animation.direction = Noble.Animation.DIRECTION_LEFT
    end

    self.speed = 2
    self.jumping = false
    self.airTime = 0

	self:setCollideRect(0, 0, 16, 16)
end

function Hero:update()
    Hero.super.update(self)

    if(self.jumping) then
        self.airTime += 1
    end
    if (self.airTime > 10) then
        self.downwardSpeed = 4
    end

    self:moveWithCollisions(self.x + (self.speed * self.direction) , self.y + self.downwardSpeed)
end


function Hero:collisionResponse(other)
    if self.jumping then
        self.jumping = false
        self.airTime = 0
    end
    
    return Graphics.sprite.kCollisionTypeSlide
end

function Hero:jump()
    self.downwardSpeed = -4
    self.jumping = true
end

function Hero:goRight()
    self.direction = 1
    self.animation.direction = Noble.Animation.DIRECTION_RIGHT
    self.animation:setState("walk")
end
function Hero:goLeft()
    self.direction = -1
    self.animation.direction = Noble.Animation.DIRECTION_LEFT
    self.animation:setState("walk")
end

function Hero:stopMoving()
    self.direction = 0
    self.animation:setState("idle")
end


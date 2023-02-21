Hero = {}
class("Hero").extends(NobleSprite)

function Hero:init()
	Hero.super.init(self, "assets/images/hero", true)
    
	self.animation:addState("idle", 13, 23)
	self.animation:addState("walk", 1, 12)

    self:moveTo(100,100)
    self:setSize(32,32)

    self.downwardSpeed = 2

    self.direction = 0

    self.speed = 2

	self:setCollideRect(0,0,32,32)
end

function Hero:update()
    Hero.super.update(self)

    self:moveWithCollisions(self.x + (self.speed * self.direction) , self.y + self.downwardSpeed)
end


function Hero:collisionResponse(other)
    return Graphics.sprite.kCollisionTypeSlide
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


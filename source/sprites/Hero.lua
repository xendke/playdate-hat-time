Hero = {}
class("Hero").extends(NobleSprite)

function Hero:init()
	Hero.super.init(self, "assets/images/hero", true)
    
	self.animation:addState("idle", 13, 23)
	self.animation:addState("walk", 1, 12)

    self:moveTo(100,100)
    self:setSize(32,32)

    self.downwardSpeed = 4

    self.direction = 0

    self.speed = 2
    self.jumping = false
    self.airTime = 0

	self:setCollideRect(0,0,32,32)
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
    if other:isa(Tile) and self.jumping then
        self.jumping = false
        self.airTime = 0
        print("jumping and tile hit")
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


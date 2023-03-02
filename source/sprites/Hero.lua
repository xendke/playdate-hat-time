import "utilities/Stack"

Hero = {}
class("Hero").extends(NobleSprite)

local live = {
	player_speed = 5,
	player_acc = 1,
	player_ground_friction = 0.8,
	player_air_friction = 0.3,

	jump_grace = 0.1,
	jump_buffer = 0.1,
	jump_long_press = 0.12,
	jump_velocity = -15,

	gravity_up = 80,
	gravity_down = 130,
	player_max_gravity = 40,
}

function Hero:init(entity)
	Hero.super.init(self, "assets/images/hero", true)
    
	self.animation:addState("idle", 12, 18, nil, nil, nil, 3)
	self.animation:addState("walk", 1, 11, nil, nil, nil, 3)

    if entity.fields.EntranceDirection == Utilities.EAST then
        self.animation.direction = Noble.Animation.DIRECTION_RIGHT
    else
        self.animation.direction = Noble.Animation.DIRECTION_LEFT
    end

	self:setZIndex(entity.zIndex)
	self:moveTo(entity.position.x, entity.position.y)
	self:setCenter(entity.center.x, entity.center.y)
    self:setSize(16, 16)
	self:setCollideRect(0, 0, 16, 16)

	self.isGrounded = false
	self.justLanded = false
	self.bangCeiling = false
	self.groundedLast = 0
	self.lastJumpPress = live.jump_buffer
	self.jumpPressDuration = 0

	self.velocity = playdate.geometry.vector2D.new(0,0)

	self.previousCoords = HeroStack:Create()
end

function Hero:update()
    Hero.super.update(self)

	if not playdate.isCrankDocked() then return end
    
	local dt = 1 / playdate.display.getRefreshRate()

	-- Friction
	if self.isGrounded then
		if not playdate.buttonIsPressed( playdate.kButtonLeft | playdate.kButtonRight ) then
			self.velocity.x = Utilities.approach(self.velocity.x, 0, live.player_ground_friction)
		end
		self.velocity.y = 0
	else
		if not playdate.buttonIsPressed( playdate.kButtonLeft | playdate.kButtonRight ) then
			self.velocity.x = Utilities.approach(self.velocity.x, 0, live.player_air_friction)
		end

		if self.bangCeiling then
			self.velocity.y = 0
		end
	end

	-- move left/right
	if playdate.buttonIsPressed( playdate.kButtonLeft ) then
		self.velocity.x = Utilities.approach(self.velocity.x, -live.player_speed, live.player_acc)
        self.animation.direction = Noble.Animation.DIRECTION_LEFT
	end
	if playdate.buttonIsPressed( playdate.kButtonRight ) then
		self.velocity.x = Utilities.approach(self.velocity.x, live.player_speed, live.player_acc) 
        self.animation.direction = Noble.Animation.DIRECTION_RIGHT
	end

	-- Jump
	self.groundedLast = self.groundedLast + dt
	if self.isGrounded then
		self.groundedLast = 0
	end

	self.lastJumpPress = self.lastJumpPress + dt
	if playdate.buttonJustPressed( playdate.kButtonA ) then
		self.lastJumpPress = 0
	end

	if self.jumpPressDuration>0 then
		if playdate.buttonIsPressed( playdate.kButtonA ) then
			self.velocity.y = live.jump_velocity
			self.jumpPressDuration = self.jumpPressDuration - dt
		else
			self.jumpPressDuration = 0
		end
	end

	if self.lastJumpPress < live.jump_buffer and self.groundedLast < live.jump_grace then
		self.velocity.y = live.jump_velocity
		self.isGrounded = false

		self.lastJumpPress = live.jump_buffer
		self.groundedLast = live.jump_grace
		self.jumpPressDuration = live.jump_long_press
	end

	-- Gravity	
	if self.velocity.y >= 0 then
		self.velocity.y = math.min( self.velocity.y + live.gravity_down * dt, live.player_max_gravity)
	else
		self.velocity.y = self.velocity.y + live.gravity_up * dt
	end

	local goalX = self.x + self.velocity.x
	local goalY = self.y + self.velocity.y

	local _, my = self:moveWithCollisions( self.x, goalY)
	local mx, _ = self:moveWithCollisions( goalX, self.y)

	local isGrounded = my~=goalY and self.velocity.y>0
	self.justLanded = isGrounded and not self.isGrounded
	self.isGrounded = isGrounded
	self.bangCeiling = my~=goalY and self.velocity.y<0

	-- save to stack
	self.previousCoords:addCoords(self.x, self.y)
end


-- function Hero:collisionResponse(other)
--     if self.jumping then
--         self.jumping = false
--         self.airTime = 0
--     end
    
--     return Graphics.sprite.kCollisionTypeSlide
-- end

function Hero:jump()
	printTable(self.previousCoords)
end

function Hero:goRight()
    self.animation:setState("walk")
end
function Hero:goLeft()
    self.animation:setState("walk")
end

function Hero:stopMoving()
    self.animation:setState("idle")
end

function Hero:timeTravel()
	local pos = self.previousCoords:getCoords()
	print("time travel")
	printTable(pos)
	if pos then
		self:moveTo(pos.x, pos.y)
	end
end

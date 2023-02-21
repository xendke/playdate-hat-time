import "sprites/Hero"
import "sprites/Tile"

GameScene = {}
class("GameScene").extends(NobleScene)

local hero = Hero()

function GameScene:init()
	GameScene.super.init(self)

	for tile = 0,13,1
	do
		self:addSprite(Tile(tile*32, 225))
	end

	self:addSprite(hero)
end

function GameScene:update()
	GameScene.super.update(self)
end

GameScene.inputHandler = {
	AButtonDown = function()
		hero:jump()
	end,
	leftButtonDown = function()
		hero:goLeft()
	end,
	leftButtonHold = function()
		hero:goLeft()
	end,
	leftButtonUp = function()
		hero:stopMoving()
	end,
	rightButtonDown = function()
		hero:goRight()
	end,
	rightButtonHold = function()
		hero:goRight()
	end,
	rightButtonUp = function()
		hero:stopMoving()
	end
}

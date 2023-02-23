import "sprites/Hero"
import "sprites/Tile"

GameScene = {}
class("GameScene").extends(NobleScene)

local hero = Hero()

function GameScene:init()
	GameScene.super.init(self)
	local tilemap = LDtk.create_tilemap("Level_0", "Tiles")
	Graphics.sprite.addWallSprites( tilemap, LDtk.get_empty_tileIDs( "Level_0", "Solid", "Tiles") )

	local layerSprite = Graphics.sprite.new()
	layerSprite:setTilemap( tilemap )
	layerSprite:moveTo(0, 0)
	layerSprite:setCenter(0, 0)
	layerSprite:add()

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

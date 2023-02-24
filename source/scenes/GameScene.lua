import "sprites/Hero"
import "sprites/Tile"

GameScene = {}
class("GameScene").extends(NobleScene)

local hero
local transitioning

GameScene.backgroundColor = Graphics.kColorBlack

local function loadMap(gameScene, level)
	local tilemap = LDtk.create_tilemap(level, "Tiles")
	local decorTilemap = LDtk.create_tilemap(level, "Decoration")

	Graphics.sprite.addWallSprites(tilemap, LDtk.get_empty_tileIDs(level, "Solid", "Tiles"))

	local tilesSprite = Graphics.sprite.new()
	tilesSprite:setTilemap(tilemap)
	tilesSprite:moveTo(0, 0)
	tilesSprite:setCenter(0, 0)
	gameScene:addSprite(tilesSprite)


	local decorationSprite = Graphics.sprite.new()
	decorationSprite:setTilemap(decorTilemap)
	decorationSprite:moveTo(0, 0)
	decorationSprite:setCenter(0, 0)
	gameScene:addSprite(decorationSprite)
	
	local entities = LDtk.get_entities(level)

	if not entities then return end
	for _, entity in ipairs(entities) do
		if entity.name == "Hero" then
			hero = Hero(entity)
			gameScene:addSprite(hero)
			-- if entity.fields.EntranceDirection == direction then
			-- end
		end
	end
end

function GameScene:init()
	GameScene.super.init(self)
	transitioning = false

	loadMap(self, "Level_0")
end

function GameScene:update()
	GameScene.super.update(self)
	if hero.x > 400 and not transitioning then
		transitioning = true
		Noble.transition(MenuScene, 1, Noble.TransitionType.DIP_TO_BLACK)
	end
end


function GameScene:finish()
	GameScene.super.finish(self)
	transitioning = false
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

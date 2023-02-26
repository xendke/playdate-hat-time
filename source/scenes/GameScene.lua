import "sprites/Hero"
import "sprites/Tile"

GameScene = {}
class("GameScene").extends(NobleScene)

local hero
local wallSprites

GameScene.backgroundColor = Graphics.kColorBlack

local function loadMap(gameScene, level)
	local tilemap = LDtk.create_tilemap(level, "Tiles")
	local decorTilemap = LDtk.create_tilemap(level, "Decoration")

	wallSprites = Graphics.sprite.addWallSprites(tilemap, LDtk.get_empty_tileIDs(level, "Solid", "Tiles"))

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
	loadMap(self, Utilities.getLevel())
end

function GameScene:update()
	GameScene.super.update(self)

	local left = hero.x
	local right = hero.x + hero.width
	if left < 0 then
		self:moveScene("west")
	end
	if right > 400  then
		self:moveScene("east")
	end
end

function GameScene:moveScene(direction)
	local nextLevel = LDtk.get_neighbours( Utilities.getLevel(), direction)[1]
	if not nextLevel then return end -- should error instead maybe
	
	for _, sprite in ipairs(wallSprites) do
		if sprite then
			sprite:remove()
		end
	end
	Utilities.setLevel(nextLevel)
	Noble.transition(GameScene, 1, Noble.TransitionType.DIP_TO_BLACK)
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

import "sprites/Hero"
import "sprites/Gem"

import "utilities/GemTracker"

GameScene = {}
class("GameScene").extends(NobleScene)

local hero
local wallSprites
local gemGui

GameScene.backgroundColor = Graphics.kColorBlack

local function loadMap(gameScene, level, entranceDirection)
	local entranceDirection = entranceDirection or Utilities.DEFAULT_DIRECTION
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
		if entity.name == "Hero" and entranceDirection == entity.fields.EntranceDirection then
			hero = Hero(entity)
			gameScene:addSprite(hero)
		end
		
		if entity.name == "Gem" then
			if not GemTracker.alreadyCollected(level, entity.position.x, entity.position.y) then
				local gem = Gem(entity)
				gameScene:addSprite(gem)
			end
		end
	end
end

function GameScene:init()
	GameScene.super.init(self)
	gemGui = Graphics.image.new("assets/images/gemcontainer")
	loadMap(self, Utilities.getLevel(), Utilities.getEntranceDirection())
end

function GameScene:update()
	GameScene.super.update(self)

	gemGui:draw(8, 220)
	Noble.Text.draw(GemTracker.getCount(), 34, 224, Noble.Text.ALIGN_RIGHT, false, Noble.Text.FONT_SMALL)

	-- collision
	local collisions = Graphics.sprite.allOverlappingSprites()
	self:handleCollisions(collisions)

	local left = hero.x
	local right = hero.x + hero.width
	if left < 0 then
		self:moveScene(Utilities.WEST)
	end
	if right > 400  then
		self:moveScene(Utilities.EAST)
	end
end


function GameScene:handleCollisions(collisions)
	for i = 1, #collisions do
		local collisionPair = collisions[i]
        local sprite1 = collisionPair[1]
        local sprite2 = collisionPair[2]
		local gem = nil
		if sprite1.className == "Gem" and sprite2.className == "Hero" then
			gem = sprite1
		end
		if sprite2.className == "Gem" and sprite1.className == "Hero" then
			gem = sprite2
		end

		if gem then
			GemTracker.collectGem(Utilities.getLevel(), gem.x, gem.y)
			gem:remove()
		end
	end
end

function GameScene:moveScene(direction)
	local nextLevel = LDtk.get_neighbours(Utilities.getLevel(), direction)[1]
	if not nextLevel then return end
	
	for _, sprite in ipairs(wallSprites) do
		if sprite then
			sprite:remove()
		end
	end
	Utilities.setLevel(nextLevel)
	Utilities.setEntranceDirection(direction)
	if Noble.isTransitioning then return end
	Noble.transition(GameScene, 0.5, Noble.TransitionType.DIP_TO_BLACK)
end


function GameScene:finish()
	GameScene.super.finish(self)
end

GameScene.inputHandler = {
	AButtonDown = function()
		local tr = GemTracker.getTracker()
		printTable(tr)
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
	end,
	cranked = function()
		hero:timeTravel()
	end
}

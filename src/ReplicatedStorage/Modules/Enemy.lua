---@type PathingService
local PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
---@type StandardEnemy
local StandardEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyStandard)
local FastEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyFast)
local SlowEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyFast)
local EnemyStats = require(game.ReplicatedStorage.Configs.EnemyStats)

local EnemyModels = game.ReplicatedStorage.Enemies

local module = {}


local function newEnemyType(name, class)
	local t = setmetatable({
		name = name, class = class
	},
	{
		__tostring = function(t) return t.name end,
		__index = function(t, k) return t.class[k] end
	})
	
	return t
end

local str = "Hello world, today I'm trying to learn Vim!"
local CONSTANT_VARIABLE = "this is a value"

---@class Enemy
local Enemy = {}
Enemy.__index = Enemy

Enemy.Type, Enemy._TypeMetatable = {
	Standard = newEnemyType("Standard", StandardEnemy),
	Fast = newEnemyType("Fast", FastEnemy),
	Slow = newEnemyType("Slow", SlowEnemy),
}, {
	__index = function(t, k)
		error(k .. " is not a valid enemy type")
	end
}
setmetatable(Enemy.Type, Enemy._TypeMetatable)

--[[
---@return Enemy
function Enemy.new(enemyClass)
	
	local self = setmetatable(enemyClass.new(), Enemy)
	
	return self
end

function Enemy:_getMovePart()
	local movePart
	if self.model:IsA("BasePart") then
		movePart = self.model
	else
		movePart = self.model.PrimaryPart or self.model:FindFirstChild("HumanoidRootPart")
	end
	
	return movePart
end

function Enemy:SetPosition(position, lookAt)
	self.movePart.CFrame = CFrame.new(unpack({position, lookAt}))
end
]]

---@class EnemyFactory
local EnemyFactory = {}

---@return EnemyFactory
function EnemyFactory.SpawnEnemy(enemyType)
	return enemyType.new()
end

module.Enemy = Enemy
module.EnemyFactory = EnemyFactory

return module
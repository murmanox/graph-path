---@type StandardEnemy
local StandardEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyStandard)
local FastEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyFast)
local SlowEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyFast)

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


---@class Enemy
local Enemy = {}
Enemy.__index = Enemy
Enemy.Pool = {}

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


function Enemy.GetEnemyFromInstance(instance)
	return Enemy.Pool[instance]
end

function Enemy.RemoveEnemyFromPool(enemy)
	Enemy.Pool[enemy.model] = nil
end

---@class EnemyFactory
local EnemyFactory = {}

---@return EnemyFactory
function EnemyFactory.SpawnEnemy(enemyType)
	local e = enemyType.new()
	Enemy.Pool[e.model] = e
	local diedEvent
	diedEvent = e.Died:Connect(function()
		Enemy.RemoveEnemyFromPool(e)
		diedEvent:Disconnect()
	end)
	return e
end

module.Enemy = Enemy
module.EnemyFactory = EnemyFactory

return module
---@type StandardEnemy
local StandardEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyStandard)
local FastEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyFast)
local SlowEnemy = require(game.ReplicatedStorage.Modules.Enemies.EnemyFast)


---@class Enemy
local Enemy = {}
Enemy.__index = Enemy

Enemy.Type, Enemy._TypeMetatable = {
	Standard = StandardEnemy,
	Fast = FastEnemy,
	Slow = SlowEnemy,
}, {
	__index = function(t, k)
		error(k .. " is not a valid enemy type")
	end
}
setmetatable(Enemy.Type, Enemy._TypeMetatable)

function Enemy.new()
	-- base class for all enemies ??
	local self = setmetatable({}, Enemy)
	
	return self
end

return Enemy
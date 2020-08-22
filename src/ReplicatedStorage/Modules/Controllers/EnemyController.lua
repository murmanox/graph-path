-- local ConnectionManager = require(game.ReplicatedStorage.Modules.Utility.ConnectionManager)

---@class EnemyController
local EnemyController = {}
EnemyController.__index = EnemyController

local EnemyPool = {
	_count = 0,
	_pool = {},
	_events = {
		enemy_added = Instance.new("BindableEvent"),
		enemy_removed = Instance.new("BindableEvent"),
	},
}

function EnemyPool.Add(enemy)
	assert(enemy, "EnemyPool.Add was called with a nil value")
	assert(enemy.model, "Passed enemy has no model property" .. (", " .. tostring(enemy.ClassName) or ""))
	EnemyPool._pool[enemy.model] = enemy
	EnemyPool._count += 1
	EnemyPool._events.enemy_added:Fire(EnemyPool._count)
end

function EnemyPool.Remove(enemy)
	local index -- = (EnemyPool[enemy] and enemy or (EnemyPool[enemy.model] and enemy.model or nil))
	if EnemyPool._pool[enemy] then
		index = enemy
	elseif EnemyPool._pool[enemy.model] then
		index = enemy.model
	end
	if index then
		EnemyPool._pool[index] = nil
		EnemyPool._count -= 1
	end
	EnemyPool._events.enemy_removed:Fire(EnemyPool._count)
end


---@return EnemyController
function EnemyController.new()
	---@type EnemyController
	local self = setmetatable({
		-- _connections = ConnectionManager.new()
		_events = {},
	}, EnemyController)
	
	self.EnemyAdded = EnemyPool._events.enemy_added.Event
	self.EnemyRemoved = EnemyPool._events.enemy_removed.Event
	
	return self
end

function EnemyController.SpawnEnemy(enemyType)
	local enemy = enemyType.new()
	EnemyPool.Add(enemy)
	
	local died_connection
	died_connection = enemy.Died:Connect(function()
		died_connection:Disconnect()
		EnemyPool.Remove(enemy)
	end)
	
	return enemy
end

function EnemyController.GetEnemyFromInstance(instance)
	return EnemyPool._pool[instance]
end

EnemyController.EnemyPool = EnemyPool

return EnemyController.new()
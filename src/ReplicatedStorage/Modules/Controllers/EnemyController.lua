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
	GetCount = function(self)
		return self._count
	end,
}

function EnemyPool.Add(enemy)
	assert(enemy, "EnemyPool.Add was called with a nil value")
	assert(enemy.model, "Passed enemy has no model property" .. (", " .. tostring(enemy.ClassName) or ""))
	EnemyPool._pool[enemy.model] = enemy
	EnemyPool._count += 1
	EnemyPool._events.enemy_added:Fire(enemy)
end

function EnemyPool.Remove(enemy)
	local index
	if EnemyPool._pool[enemy] then
		index = enemy
	elseif EnemyPool._pool[enemy.model] then
		index = enemy.model
	end
	if index then
		local removedEnemy = EnemyPool._pool[index]
		EnemyPool._pool[index] = nil
		EnemyPool._count -= 1
		EnemyPool._events.enemy_removed:Fire(removedEnemy)
	end
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

function EnemyController.SpawnEnemy(enemyType: Enemy, waveNumber: number)
	local enemy = enemyType.new({wave = waveNumber})
	EnemyPool.Add(enemy)
	
	local died_connection
	local path_finished_connection
	local function onEnemyRemove()
		died_connection:Disconnect()
		path_finished_connection:Disconnect()
		EnemyPool.Remove(enemy)
	end
	
	died_connection = enemy.Died:Connect(onEnemyRemove)
	path_finished_connection = enemy.FollowPathFinished:Connect(onEnemyRemove)
	
	return enemy
end

function EnemyController.GetEnemyFromInstance(instance: Model | BasePart)
	return EnemyPool._pool[instance]
end

EnemyController.EnemyPool = EnemyPool
EnemyController.Pool = EnemyController.EnemyPool

return EnemyController.new()
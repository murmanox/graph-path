---@type BaseEnemy
local BaseEnemy = require(game.ReplicatedStorage.Modules.Enemies.BaseEnemy)
---@type PathingService
local PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
local EnemyStats = require(game.ReplicatedStorage.Configs.EnemyStats)

---@class SlowEnemy
local SlowEnemy = {}
SlowEnemy.__index = SlowEnemy
setmetatable(SlowEnemy, BaseEnemy)

---@return SlowEnemy
function SlowEnemy.new()	
	---@type SlowEnemy
	local self = BaseEnemy.new(EnemyStats.Slow)
	setmetatable(self, SlowEnemy)
	
	self.path = PathingService:GetNextPath()
	self.currentWaypoint = self.path[1]
	self.nextWaypoint = self.path[2]
	
	self.model.Position = self.currentWaypoint.Position
	self.model.Parent = workspace.Level.Enemies
	
	self:FollowPath()
	
	return self
end


return SlowEnemy
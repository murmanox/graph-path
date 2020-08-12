---@type BaseEnemy
local BaseEnemy = require(game.ReplicatedStorage.Modules.Enemies.BaseEnemy)
---@type PathingService
local PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
local EnemyStats = require(game.ReplicatedStorage.Configs.EnemyStats)

---@class FastEnemy
local FastEnemy = {}
FastEnemy.__index = FastEnemy
setmetatable(FastEnemy, BaseEnemy)

---@return FastEnemy
function FastEnemy.new()	
	---@type FastEnemy
	local self = BaseEnemy.new(EnemyStats.Fast)
	setmetatable(self, FastEnemy)
	
	self.path = PathingService:GetNextPath()
	self.currentWaypoint = self.path[1]
	self.nextWaypoint = self.path[2]
	
	self.model.Position = self.currentWaypoint.Position
	self.model.Parent = workspace.Level.Enemies
	
	self:FollowPath()
	
	return self
end


return FastEnemy
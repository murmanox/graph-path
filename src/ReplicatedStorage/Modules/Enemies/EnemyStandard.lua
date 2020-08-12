---@type BaseEnemy
local BaseEnemy = require(game.ReplicatedStorage.Modules.Enemies.BaseEnemy)
---@type PathingService
local PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
local EnemyStats = require(game.ReplicatedStorage.Configs.EnemyStats)

---@class StandardEnemy
local StandardEnemy = {}
StandardEnemy.__index = StandardEnemy
setmetatable(StandardEnemy, BaseEnemy)

---@return StandardEnemy
function StandardEnemy.new()	
	---@type StandardEnemy
	local self = BaseEnemy.new(EnemyStats.Standard)
	setmetatable(self, StandardEnemy)
	
	self.path = PathingService:GetNextPath()
	self.currentWaypoint = self.path[1]
	self.nextWaypoint = self.path[2]
	
	self.model.Position = self.currentWaypoint.Position
	self.model.Parent = workspace.Level.Enemies
	
	self:FollowPath()
	
	return self
end


return StandardEnemy
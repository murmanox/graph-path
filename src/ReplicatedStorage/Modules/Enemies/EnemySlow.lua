local BaseEnemy: BaseEnemy = require(game.ReplicatedStorage.Modules.Enemies.BaseEnemy)
local PathingService: PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
local EnemyStats = require(game.ReplicatedStorage.Configs.EnemyStats)
local Table = require(game.ReplicatedStorage.Modules.Utility.Table)

---@class SlowEnemy
local SlowEnemy = {
	ClassName = "Slow",
}
SlowEnemy.__index = SlowEnemy
setmetatable(SlowEnemy, BaseEnemy)

---@return SlowEnemy
function SlowEnemy.new(stats)	
	local stats = Table.Merge(EnemyStats.Standard, stats)
	local self: SlowEnemy = BaseEnemy.new(stats)
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
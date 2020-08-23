local BaseEnemy: BaseEnemy = require(game.ReplicatedStorage.Modules.Enemies.BaseEnemy)
local PathingService: PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
local EnemyStats = require(game.ReplicatedStorage.Configs.EnemyStats)
local Table = require(game.ReplicatedStorage.Modules.Utility.Table)

---@class StandardEnemy
local StandardEnemy = {
	ClassName = "Standard",
}
StandardEnemy.__index = StandardEnemy
setmetatable(StandardEnemy, BaseEnemy)

---@return StandardEnemy
function StandardEnemy.new(stats)	
	local stats = Table.Merge(EnemyStats.Standard, stats)
	local self: StandardEnemy = BaseEnemy.new(stats)
	setmetatable(self, StandardEnemy)
	
	self.path = PathingService:GetNextPath()
	self.currentWaypoint = self.path[1]
	self.nextWaypoint = self.path[2]
	
	self.model.Position = self.currentWaypoint.Position
	self.model.Parent = workspace.Level.Enemies
	
	coroutine.wrap(function()
		self:FollowPath()
	end)()
	
	return self
end


return StandardEnemy
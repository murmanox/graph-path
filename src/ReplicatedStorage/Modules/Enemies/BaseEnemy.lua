---@class BaseEnemy
local BaseEnemy = {}
BaseEnemy.__index = BaseEnemy

---@return BaseEnemy
function BaseEnemy.new(stats)
	---@type BaseEnemy
	local self = setmetatable({}, BaseEnemy)
	
	self.model = stats.model
	self.health = stats.health
	self.speed = stats.speed
	self.movePart = self.model.PrimaryPart
	self.currentWaypoint = nil
	
	return self
end


return BaseEnemy
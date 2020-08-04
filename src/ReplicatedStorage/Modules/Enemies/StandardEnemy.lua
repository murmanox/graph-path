---@type BaseEnemy
local BaseEnemy = require(game.ReplicatedStorage.Modules.Enemies.BaseEnemy)

---@class StandardEnemy
local StandardEnemy = {}
StandardEnemy.__index = StandardEnemy

---@return StandardEnemy
function StandardEnemy.new(stats)
	---@type StandardEnemy
	local self = BaseEnemy.new(stats)
	setmetatable(self, StandardEnemy)
	
	
	
	return self
end


return StandardEnemy
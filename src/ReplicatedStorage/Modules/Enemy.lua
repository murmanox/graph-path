---@type PathingService
local PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
---@type StandardEnemy
local StandardEnemy = require(game.ReplicatedStorage.Modules.Enemies.StandardEnemy)

local EnemyModels = game.ReplicatedStorage.Enemies

---@class Enemy
local Enemy = {}
Enemy.__index = Enemy

Enemy.Type, Enemy._TypeMetatable = {
	Standard = StandardEnemy,
	Fast = EnemyModels.Fast,
}, {
	__index = function(t, k)
		error(k .. " is not a valid enemy type")
	end
}
setmetatable(Enemy.Type, Enemy._TypeMetatable)

---@return Enemy
function Enemy.new(name, stats)
	--local enemyModel = 
end

function Enemy:_getMovePart()
	local movePart
	if self.model:IsA("BasePart") then
		movePart = self.model
	else
		movePart = self.model.PrimaryPart or self.model:FindFirstChild("HumanoidRootPart")
	end
	
	return movePart
end

function Enemy:SetPosition(position, lookAt)
	self.movePart.CFrame = CFrame.new(unpack({position, lookAt}))
end

function Enemy:Move()
	
end


return Enemy
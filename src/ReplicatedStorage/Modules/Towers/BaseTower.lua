---@type Enemy
-- local Enemy = require(game.ReplicatedStorage.Modules.Enemy).Enemy
local EnemyController: EnemyController = require(game.ReplicatedStorage.Modules.Controllers.EnemyController)

---@class BaseTower
local BaseTower = {}
BaseTower.__index = BaseTower

---@return BaseTower
function BaseTower.new(stats)
	---@type BaseTower
	local self = setmetatable({}, BaseTower)
	
	self.range = stats.range
	self.speed = stats.speed
	self.damage = stats.damage
	self.timeBetweenShots = 1 / self.speed
	self.model = stats.model
	self.name = stats.name
	
	self.cooldown = 0

	game:GetService("RunService").Heartbeat:Connect(function(dt)
		self:OnHeartbeat(dt)
	end)
	
	return self
end

function BaseTower:ShootAt(target)
	if not target then return end
	self.cooldown = self.timeBetweenShots
	self.model.CFrame = CFrame.new(self.model.Position, target.model.Position)
	target:TakeDamage(self.damage)
end

function BaseTower:FindTarget()
	for _, enemy in ipairs(workspace.Level.Enemies:GetChildren()) do
		local enemyObject = EnemyController.GetEnemyFromInstance(enemy)
		if enemyObject and enemyObject.isAlive then
			if (enemy.Position - self.model.Position).Magnitude <= self.range then
				return enemyObject
			end
		end
	end
end

function BaseTower:OnHeartbeat(dt)
	if self.cooldown > 0 then
		self.cooldown = self.cooldown - dt
		return
	end
	self:ShootAt(self:FindTarget())
end

return BaseTower
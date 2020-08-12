---@class BaseTower
local BaseTower = {}
BaseTower.__index = BaseTower

---@return BaseTower
function BaseTower.new(stats)
	---@type BaseTower
	local self = setmetatable({}, BaseTower)
	
	self.range = 10
	self.model = stats
	game:GetService("RunService").Heartbeat:Connect(function()
		self:DoAction()
	end)
	
	return self
end

function BaseTower:DoAction()
	for _, enemy in ipairs(workspace.Level.Enemies:GetChildren()) do
		if (enemy.Position - self.model.Position).Magnitude <= self.range then
			self.model.CFrame = CFrame.new(self.model.Position, enemy.Position)
		end
	end
end

return BaseTower
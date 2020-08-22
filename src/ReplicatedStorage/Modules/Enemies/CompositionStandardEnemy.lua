local Health: Health = require(game.ReplicatedStorage.Modules.Components.Health)
local EnemyController:EnemyController = require(game.ReplicatedStorage.Modules.Controllers.EnemyController)

---@class TestEnemyStandard
local TestEnemyStandard = {}
TestEnemyStandard.__index = TestEnemyStandard

---@return TestEnemyStandard
function TestEnemyStandard.new()
	---@type TestEnemyStandard
	local self = setmetatable({
		health = Health.new(100),
	}, TestEnemyStandard)
	
	
	
	return self
end


return TestEnemyStandard
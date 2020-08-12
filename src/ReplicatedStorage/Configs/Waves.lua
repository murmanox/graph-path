local EnemyModule = require(game.ReplicatedStorage.Modules.Enemy)
---@type Enemy
local Enemy = EnemyModule.Enemy


local Wave = {}

function Wave.new(enemies, settings)
	--[[
		settings.spawnInterval = 0.5 -- spawn twice as fast as default
	]]
	local t = {
		{
			Type = Enemy.Type.Standard,
			Amount = 3,
		},
	}
	return t
end


local Waves = {
	[1] = {
		{Enemy.Type.Standard, 3},
	},
	[2] = {
		{Enemy.Type.Standard, 3},
		{Enemy.Type.Fast, 2},
	},
	-- [3] = {
	-- 	{Enemy.Type.Slow, 2},
	-- 	{Enemy.Type.Standard, 10},
	-- },
	-- [4] = {
	-- 	{Enemy.Type.Fast, 10},
	-- }
}

return Waves
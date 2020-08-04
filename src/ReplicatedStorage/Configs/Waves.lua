---@type Enemy
local Enemy = require(game.ReplicatedStorage.Modules.Enemy)


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
		--Wave.new({Enemy.Type.Standard, 3}),
		{Enemy.Type.Standard, 3},
	},
	[2] = {
		{Enemy.Type.Standard, 3},
		{Enemy.Type.Fast, 2},
	},
	[3] = {
		{Enemy.Type.Standard, 10},
	},
	[4] = {
		{Enemy.Type.Fast, 10},
	}
}

return Waves
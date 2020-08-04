if not game:GetService("RunService"):IsStudio() then
	return
end

---@type WaveSpawner
local WaveSpawner = require(game.ServerScriptService.Modules.WaveSpawner)

wait(2)
local wave_spawner = WaveSpawner.new()
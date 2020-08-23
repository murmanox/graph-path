--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

---@type EnemyStats
type EnemyStats = {
	health: number,
	speed: number,
	name: string,
	model: BasePart | Model
}

local stats: {[string]: EnemyStats} = {
	Standard = {
		health = 100,
		speed = 8,
		name = "Standard",
		model = ReplicatedStorage.Enemies.Standard
	},
	Fast = {
		health = 50,
		speed = 12,
		name = "Fast",
		model = ReplicatedStorage.Enemies.Standard
	},
	Slow = {
		health = 300,
		speed = 4,
		name = "Slow",
		model = ReplicatedStorage.Enemies.Standard
	},
}

return stats
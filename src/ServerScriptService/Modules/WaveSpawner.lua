---@type Enemy
local Enemy = require(game.ReplicatedStorage.Modules.Enemy)
local Waves = require(game.ReplicatedStorage.Configs.Waves)

local RunService = game:GetService("RunService")

---@class WaveSpawner
local WaveSpawner = {}
WaveSpawner.__index = WaveSpawner

WaveSpawner.Settings = {
	AutomaticallyStartNextWave = true,
	WaveMustFinishBeforeNext = true,
	EnemySpawnDelay = 2,
	WaveSpawnDelay = 5,
}

---@return WaveSpawner
function WaveSpawner.new(paths)
	---@type WaveSpawner
	local self = setmetatable({}, WaveSpawner)
	
	self.paths = paths
	self.waveNumber = 1
	self.countdown = WaveSpawner.Settings.WaveSpawnDelay
	
	self.waveInProgress = false
	
	RunService.Heartbeat:Connect(function(dt) self:OnHeartbeat(dt) end)
	return self
end


function WaveSpawner:OnHeartbeat(dt)
	if self.waveInProgress then
		return
	end
	
	print("Next wave in", math.ceil(self.countdown))
	self.countdown = self.countdown - dt
	
	if self.countdown <= 0 then
		self:SpawnWave()
		self.countdown = WaveSpawner.Settings.WaveSpawnDelay
	end
	
end


function WaveSpawner:SpawnWave()
	if self.waveInProgress then
		warn("WaveSpawner:SpawnWave is being called multiple times")
		return
	end
	
	print("Starting Wave:", self.waveNumber)
	self.waveInProgress = true
	
	-- this should be in the waves module
	local wave = Waves[self.waveNumber]
	for _, enemy in ipairs(wave) do
		local enemyToSpawn = enemy[1]
		local amountToSpawn = enemy[2]
		
		for i = 1, amountToSpawn do
			self:SpawnEnemy(enemyToSpawn)
			wait(WaveSpawner.Settings.EnemySpawnDelay)
		end
	end
	
	self.waveInProgress = false
	self.waveNumber = self.waveNumber + 1
end


function WaveSpawner:SpawnEnemy(enemyType)
	print("spawning enemy", enemyType)
end


return WaveSpawner
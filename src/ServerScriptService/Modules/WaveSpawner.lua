local EnemyController: EnemyController = require(game.ReplicatedStorage.Modules.Controllers.EnemyController)
local Enemy = require(game.ReplicatedStorage.Modules.Enemy)
---@type EnemyFactory
--local EnemyFactory = EnemyModule.EnemyFactory

local Waves = require(game.ReplicatedStorage.Configs.Waves)

local RunService = game:GetService("RunService")

---@class WaveSpawner
local WaveSpawner = {}
WaveSpawner.__index = WaveSpawner

WaveSpawner.Settings = {
	AutomaticallyStartNextWave = true,
	WaveMustFinishBeforeNext = true,
	EnemySpawnDelay = 2,
	WaveSpawnDelay = 2,
}

local enemyWaveMap = {
	Remove = function(self, e)
		self[e] = nil
	end,
}

---@return WaveSpawner
function WaveSpawner.new(paths)
	---@type WaveSpawner
	local self = setmetatable({
		_events = {
			waveFinished = Instance.new("BindableEvent")
		}
	}, WaveSpawner)
	
	self.paths = paths
	self.waveNumber = 1
	self.countdown = WaveSpawner.Settings.WaveSpawnDelay
	self.isWaveInProgress = false
	self.isSpawningEnemies = false
	self.enemiesInWave = {}
	
	self.WaveFinished = self._events.waveFinished.Event

	EnemyController.EnemyRemoved:Connect(function(enemy)
		local wave = enemy.wave
		if wave then
			self.enemiesInWave[wave] -= 1
			if not self.isSpawningEnemies and self.enemiesInWave[wave] == 0 then
				self._events.waveFinished:Fire(wave)
			end
		end
	end)
	
	return self
end

function WaveSpawner:Start()
	self._c = RunService.Heartbeat:Connect(function(dt) self:OnHeartbeat(dt) end)
end

function WaveSpawner:Stop()
	print("Finished spawning wave")
	self._c:Disconnect()
	self:Reset()
end

function WaveSpawner:Reset()
	self.waveNumber = 1
	self.countdown = WaveSpawner.Settings.WaveSpawnDelay
	self.isWaveInProgress = false
end

function WaveSpawner:OnHeartbeat(dt)
	if self.isWaveInProgress or self.isSpawningEnemies then
		return
	end

	print("Next wave in", math.ceil(self.countdown))
	self.countdown = self.countdown - dt
	
	if self.countdown <= 0 then
		self:SpawnWave()
		self.countdown = WaveSpawner.Settings.WaveSpawnDelay
	end
end

-- this should only spawn 1 wave
function WaveSpawner:SpawnWave()
	if self.isWaveInProgress then
		warn("WaveSpawner:SpawnWave is being called multiple times")
		return
	end
	
	print("Starting Wave:", self.waveNumber)
	self.enemiesInWave[self.waveNumber] = 0
	self.isWaveInProgress = true
	self.isSpawningEnemies = true
	
	local wave = Waves[self.waveNumber]
	for _, enemy in ipairs(wave) do
		local enemyToSpawn = enemy[1]
		local amountToSpawn = enemy[2]
		
		for i = 1, amountToSpawn do
			local e = self:SpawnEnemy(enemyToSpawn)
			wait(WaveSpawner.Settings.EnemySpawnDelay)
		end
	end
	
	self.isSpawningEnemies = false
	if WaveSpawner.Settings.WaveMustFinishBeforeNext then
		self.WaveFinished:Wait()
	end
	
	self.isWaveInProgress = false
	self.waveNumber = self.waveNumber + 1
	if not Waves[self.waveNumber] then
		self:Stop()
	end
end

function WaveSpawner:SpawnEnemy(enemyType): BaseEnemy
	-- print("spawning enemy:", enemyType, "Wave:", self.waveNumber)
	local waveNumber = self.waveNumber
	local enemy = EnemyController.SpawnEnemy(enemyType, waveNumber)
	self.enemiesInWave[waveNumber] += 1
	return enemy
end


return WaveSpawner
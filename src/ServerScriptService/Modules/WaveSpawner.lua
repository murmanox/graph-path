local EnemyModule = require(game.ReplicatedStorage.Modules.Enemy)
---@type Enemy
local Enemy = EnemyModule.Enemy
---@type EnemyFactory
local EnemyFactory = EnemyModule.EnemyFactory

local Waves = require(game.ReplicatedStorage.Configs.Waves)

local RunService = game:GetService("RunService")

---@class WaveSpawner
local WaveSpawner = {}
WaveSpawner.__index = WaveSpawner

WaveSpawner.Settings = {
	AutomaticallyStartNextWave = true,
	WaveMustFinishBeforeNext = true,
	EnemySpawnDelay = 2,
	WaveSpawnDelay = 1,
}

---@return WaveSpawner
function WaveSpawner.new(paths)
	---@type WaveSpawner
	local self = setmetatable({}, WaveSpawner)
	
	self.paths = paths
	self.waveNumber = 1
	self.countdown = WaveSpawner.Settings.WaveSpawnDelay
	self.waveInProgress = false
	
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
	self.waveInProgress = false
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
	if not Waves[self.waveNumber] then
		self:Stop()
	end
end


function WaveSpawner:SpawnEnemy(enemyType)
	print("spawning enemy:", enemyType)
	local thread = Instance.new("BindableEvent")
	thread.Event:Connect(function() EnemyFactory.SpawnEnemy(enemyType) end)
	thread:Fire()
end


return WaveSpawner
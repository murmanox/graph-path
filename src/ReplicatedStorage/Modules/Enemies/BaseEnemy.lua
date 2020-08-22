local EnemyStats = require(game.ReplicatedStorage.Configs.EnemyStats)
local Health: Health = require(game.ReplicatedStorage.Modules.Components.Health)
local PathingService: PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
local TweenService = game:GetService("TweenService")

local HEALTH_GUI = game.ReplicatedStorage.GUI.EnemyGui

-- TODO: rework enemy class to be more easily overridable
---@class BaseEnemy
local BaseEnemy = {}
BaseEnemy.__index = BaseEnemy

---@return BaseEnemy
function BaseEnemy.new(stats: EnemyStats): BaseEnemy
	local self: BaseEnemy = setmetatable({
		_connections = {},
		_events = {
			moveToCompleted = Instance.new("BindableEvent"),
			died = Instance.new("BindableEvent"),
			followPathFinished = Instance.new("BindableEvent"),
		},
	}, BaseEnemy)
	
	-- init values
	self.name = stats.name
	self.model = stats.model:Clone()
	self.health = Health.new(stats.health)
	self.speed = stats.speed
	self.path = nil
	self.isAlive = true
	
	self.currentWaypoint = nil
	self.nextWaypoint = nil
	
	-- init events
	self.MoveToCompleted = self._events.moveToCompleted.Event
	self.Died = self._events.died.Event
	self.FollowPathFinished = self._events.followPathFinished.Event
	
	local c = self.health.Changed:Connect(function(healthValue)
		if self.isAlive and healthValue <= 0 then
			self:OnDead()
		end
	end)
	self._connections.health_changed = c

	return self
end

local function DestroyEvents(self)
	for k, v in pairs(self._events) do
		if v.Destroy then
			v:Destroy()
		end
	end
end

local function DisconnectConnections(self)
	for k, v in pairs(self._connections) do
		if v.Disconnect then
			v:Disconnect()
		end
	end
end

function BaseEnemy:Destroy()
	self.model:Destroy()
	self.health:Destroy()
	DestroyEvents(self)
	DisconnectConnections(self)
end

function BaseEnemy:ShowGui()
end

function BaseEnemy:HideGui()
end

function BaseEnemy:TakeDamage(damage: number)
	self.health:TakeDamage(damage)
end

function BaseEnemy:OnDead()
	self.isAlive = false
	self.model.Transparency = 0.75
	self._events.died:Fire()
end

function BaseEnemy:MoveTo(position, speed)
	
end

function BaseEnemy:FollowPath()
	for _, v in ipairs(self.path) do
		self.nextWaypoint = v
		
		if self.currentWaypoint ~= self.nextWaypoint then
			PathingService:LinkBetweenWaypointsExists(self.currentWaypoint, self.nextWaypoint)
		end
		local timeToMove = (self.model.Position - v.Position).Magnitude / self.speed
		local tweenInfo = TweenInfo.new(timeToMove, Enum.EasingStyle.Linear)
		local goal = {Position = v.Position}
		local tween = TweenService:Create(self.model, tweenInfo, goal)
		tween:Play()
		tween.Completed:Wait()
		self.currentWaypoint = self.nextWaypoint
	end
	
	self._events.followPathFinished:Fire()
	self:Destroy()
	--[[
	for _, v in ipairs(self.path) do
	local waypointIsValid = self.currentWaypoint ~= self.nextWaypoint
		if waypointIsValid and  waypointLinkExists then
			if PathingService:LinkBetweenWaypointsExists(self.currentWaypoint, self.nextWaypoint) then
				-- path is valid, move to path
				self:MoveTo(self.nextWaypoint.Position)
		else
			-- get new path
			
		end
	end
	]]
end


return BaseEnemy
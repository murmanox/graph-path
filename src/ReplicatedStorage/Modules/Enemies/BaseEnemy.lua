local EnemyStats = require(game.ReplicatedStorage.Configs.EnemyStats)
local ServerValue: ServerValue = require(game.ReplicatedStorage.Modules.Utility.ServerValue)
local PathingService: PathingService = require(game.ServerScriptService.Modules.Services.PathingService)
local TweenService = game:GetService("TweenService")

local HEALTH_GUI = game.ReplicatedStorage.GUI.EnemyGui

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
		},
	}, BaseEnemy)
	
	self.name = stats.name
	self.model = stats.model:Clone()
	self.maxHealth = stats.health
	self.health = ServerValue.new(stats.health)
	self.speed = stats.speed
	self.path = nil
	self.isAlive = true
	
	self.currentWaypoint = nil
	self.nextWaypoint = nil
	
	self._connections.health = self.health.Changed:Connect(function(newValue)
		if newValue <= 0 then
			self:OnDead()
		end
	end)
	
	self.MoveToCompleted = self._events.moveToCompleted.Event
	self.Died = self._events.died.Event

	return self
end

function BaseEnemy:Destroy()
	self.model:Destroy()
	self._connections.health:Disconnect()
end

function BaseEnemy:ShowGui()
end

function BaseEnemy:HideGui()
end

function BaseEnemy:TakeDamage(damageValue)
	self.health:Set(self.health:Get() - damageValue)
end

function BaseEnemy:OnDead()
	print("I am dead :(")
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
local ServerValue = require(game.ReplicatedStorage.Modules.Utility.ServerValue)
type Health = {}

--[[
	Events:
		Damaged: Fires whenever current health is reduced
			Params:
				damage taken: number
		Healed: Fires whenever current health is increased
			Params:
				amount healed: number
		Changed: Fires whenever the current health or max health changes
			Params:
				current health: number
				max health: number
]]

---@class Health
local Health = {}
Health.__index = Health

function Health.new(maxHealth: number, startingHealth: number?): Health
	local self: Health = {
		_maxHealth = ServerValue.new(maxHealth),
		_health = ServerValue.new(startingHealth or maxHealth),
		_events = {
			healed = Instance.new("BindableEvent"),
			damaged = Instance.new("BindableEvent"),
			changed = Instance.new("BindableEvent"),
		},
	}
	
	-- init Events
	self.Healed = self._events.healed.Event
	self.Damaged = self._events.damaged.Event
	self.Changed = self._events.changed.Event
	
	local onHealthChanged = function()
		self._events.changed:Fire(self._health:Get(), self._maxHealth:Get())
	end
	
	self._connections = {
		maxHealth = self._maxHealth.Changed:Connect(onHealthChanged),
		health = self._health.Changed:Connect(onHealthChanged),
	}

	return setmetatable(self, Health)
end

function Health:TakeDamage(damage)
	local currentHealth = self:GetHealth()
	local damageToTake = damage >= currentHealth and currentHealth or damage
	self:SetHealth(currentHealth - damageToTake)
	self._events.damaged:Fire(damageToTake)
end

function Health:Heal(healAmount)
	local currentHealth = self:GetHealth()
	local missingHealth = self:GetMaxHealth() - currentHealth
	local amountToHeal = healAmount <= missingHealth and healAmount or missingHealth
	self:SetHealth(currentHealth + amountToHeal)
	self._events.healed:Fire(amountToHeal)
end

function Health:GetMaxHealth()
	return self._maxHealth:Get()
end

function Health:SetMaxHealth(newMaxHealthValue)
	self._maxHealth:Set(newMaxHealthValue)
end

function Health:GetHealth()
	return self._health:Get()
end

function Health:SetHealth(newHealthValue)
	local healthToSet = math.clamp(newHealthValue, 0, self._maxHealth:Get())
	self._health:Set(healthToSet)
end

-- Prepares Health for garbage collection once all references to it fall out of scope or are nil
function Health:Destroy()
	for k, v in pairs(self._connections) do
		if v.Disconnect then
			v:Disconnect()
		end
	end
	for k, v in pairs(self._events) do
		if v.Destroy then
			v:Destroy()
		end
	end
end

return Health
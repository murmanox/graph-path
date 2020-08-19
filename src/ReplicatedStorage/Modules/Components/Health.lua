local ServerValue = require(game.ReplicatedStorage.Modules.Utility.ServerValue)
type Health = {}

--[[
	Events:
		Died: Fires when health reaches 0
		Damaged: Fires whenever current health is reduced
		Healed: Fires whenever current health is increased
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
		_dead = false,
		_events = {
			healed = Instance.new("BindableEvent"),
			damaged = Instance.new("BindableEvent"),
			changed = Instance.new("BindableEvent"),
			died = Instance.new("BindableEvent"),
		},
	}
	
	-- init Events
	self.Healed = self._events.healed.Event
	self.Damaged = self._events.damaged.Event
	self.Changed = self._events.changed.Event
	self.Died = self._events.died.Event
	
	local onHealthChanged = function()
		self._events.changed:Fire(self._health:Get(), self._maxHealth:Get())
		if self._health:Get() <= 0 then
			self._events.died:Fire()
		end
	end
	
	self._maxHealth.Changed:Connect(onHealthChanged)
	self._health.Changed:Connect(onHealthChanged)

	return setmetatable(self, Health)
end

function Health:TakeDamage(damage)
	local currentHealth = self._health:Get()
	local damageToTake = damage >= currentHealth and currentHealth or damage
	self:SetHealth(currentHealth - damageToTake)
	self._events.damaged:Fire(damageToTake)
end

function Health:Heal(healAmount)
	local amountToHeal = math.min(self._health:Get() + healAmount, self._maxHealth)
	self:SetHealth(amountToHeal)
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

return Health
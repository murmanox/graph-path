local Settings = require(game.ServerScriptService.Configs.ServerSettings)

if not Settings.Testing.Components.Health then
	return
end

local caseCount, successCount, failureCount = 0, 0, 0
local failedMessages = {}
function testCase(v1: any, v2: any, message: string)
	caseCount += 1
	local case = (v1 == v2)
	if case then
		successCount += 1
	else
		failureCount += 1
		table.insert(failedMessages, message .. ", Expected: " .. v2 .. " Got: " .. v1)
	end
end

function assertFinished()
	print("Test Cases:", caseCount)
	print("Successful cases:", successCount)
	print("Failed Cases:", failureCount)
	
	for k, message in pairs(failedMessages) do
		print("    Failed:", message)
	end
	print()
		
	caseCount, successCount, failureCount = 0, 0, 0
	failedMessages = {}
end

print("Testing Health Component")

local health: Health = require(game.ReplicatedStorage.Modules.Components.Health)

local fullHealthValue = 100
local halfHealthValue = fullHealthValue / 2

-- Test initialising health object
local fullHealth = health.new(fullHealthValue)
local halfHealth = health.new(fullHealthValue, halfHealthValue)

-- Test getter methods
testCase(fullHealth:GetHealth() ~= nil, true, "get current health")
testCase(fullHealth:GetMaxHealth() ~= nil, true, "get max health")

-- Test initialised object
testCase(fullHealth:GetMaxHealth(), fullHealthValue, "max health is set to first parameter")
testCase(fullHealth:GetHealth(), fullHealthValue, "health is set to max health by default")
testCase(halfHealth:GetMaxHealth(), fullHealthValue, "max health is set to first parameter")
testCase(halfHealth:GetHealth(), halfHealthValue, "second parameter sets starting health value")

-- Test setter methods
fullHealth:SetHealth(75)
testCase(fullHealth:GetHealth(), 75, "set health can change health")
fullHealth:SetHealth(fullHealth:GetMaxHealth() + 20)
testCase(fullHealth:GetHealth(), fullHealth:GetMaxHealth(), "health cannot be set above max health")
fullHealth:SetHealth(-20)
testCase(fullHealth:GetHealth(), 0, "health cannot be set below 0 health")

-- Test damage
local damage = 20
local damageTaken
fullHealth:SetHealth(fullHealthValue)
fullHealth.Damaged:Connect(function(damageValue)
	damageTaken = damageValue
end)

fullHealth:TakeDamage(damage)
testCase(fullHealth:GetHealth(), fullHealthValue - damage, "damage is taken from health")
testCase(damageTaken, damage, "return value from Damaged event is the damage applied")

fullHealth:SetHealth(damage - 2)
fullHealth:TakeDamage(damage)
testCase(damageTaken, damage - 2, "damage past 0 health is ignored")

--Test healing
local startingHealth = fullHealthValue - 15
local amountHealed
fullHealth:SetHealth(startingHealth)
fullHealth.Healed:Connect(function(healValue)
	amountHealed = healValue
end)

fullHealth:Heal(10)
testCase(fullHealth:GetHealth(), fullHealthValue - 5, "heal health")
testCase(amountHealed, 10, "correct heal value returned for less than max health")
fullHealth:Heal(10)
testCase(fullHealth:GetHealth(), fullHealth:GetMaxHealth(), "can't heal above max health")
testCase(amountHealed, 5, "health healed past max health is ignored")

assertFinished()
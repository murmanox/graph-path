local RunService = game:GetService("RunService")

local IS_SERVER = RunService:IsServer()

--[[
	-- on server	

	local health = ServerValue.new(100)
	health.Changed:Connect()
]]


local valueMap = {
	number = "NumberValue",
}


---@class ServerValue
local ServerValue = {}
ServerValue.__index = ServerValue

---@return ServerValue
function ServerValue.new(value, overrideClass)
	if overrideClass ~= nil then
		assert(type(overrideClass) == "string", "overrideClass must be a string value")
		assert(overrideClass:match("Value$"), "OverrideClass must be a Roblox Value")
	end
	
	local t = typeof(value)
	local valueType = overrideClass or valueMap[t]
	
	assert(valueType ~= nil)
	
	---@type ServerValue
	local self = setmetatable({
		_value = value,
		_type = valueType,
		_object = Instance.new(valueType),
	}, ServerValue)
	
	self.Changed = self._object.Changed
	self:Set(value)
	
	return self
end

function ServerValue:Set(value)
	self._object.Value = value
	self._value = value
end

function ServerValue:Get()
	return self._value
end


return ServerValue
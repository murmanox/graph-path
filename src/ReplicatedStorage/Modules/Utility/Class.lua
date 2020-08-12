---@class Class
local Class = {}
Class.__index = Class

---@return Class
function Class.new()
	---@type Class
	local self = setmetatable({
		_connections = {},
	}, Class)
	return self
end

function Class:DisconnectAllConnections()
	for k, connection in pairs(self._connections) do
		if connection.Disconnect then
			connection:Disconnect()
			self._connections[k] = nil
		end
	end
end
return Class
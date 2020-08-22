---@class ConnectionManager
local ConnectionManager = {}
ConnectionManager.__index = ConnectionManager

---@return ConnectionManager
function ConnectionManager.new()
	---@type ConnectionManager
	local self = setmetatable({}, ConnectionManager)
	
	
	
	return self
end

function ConnectionManager:NewConnection()
	
end


return ConnectionManager
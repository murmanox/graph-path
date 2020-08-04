---@class PathingService
local PathingService = {}
PathingService.__index = PathingService

---@return PathingService
function PathingService.new()
	---@type PathingService
	local self = setmetatable({}, PathingService)
	
	self._paths = {}
	self.currentPath = 0
	self.graph = nil
	self.graphConnection = nil
	
	return self
end

function PathingService:SetGraph(graph)
	assert(graph ~= nil, "graph cannot be nil")
	
	self.graph = graph
	if self.graphConnection then
		self.graphConnection = self.graphConnection:Disconnect()
	end
	
	if graph.getPaths then
		self._paths = graph:getPaths()
		self.graphConnection = self.graph.Changed:Connect(function()
			self._paths = graph:getPaths()
		end)
	end
end

function PathingService:GetNextPath()
	--[[
		get the next path in the list of paths
		cycles back to the start when the last item is reached.
	]]
	
	self.currentPath = math.max((self.currentPath + 1) % (#self._paths + 1), 1)
	return self._paths[self.currentPath]
end


return PathingService.new()
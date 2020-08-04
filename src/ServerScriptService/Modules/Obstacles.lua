local module = {}

do -- connection
	---@class Connection
	local Connection = {}
	Connection.__index = Connection
	
	---@return Connection
	function Connection.new(connection)
		---@type Connection
		local self = setmetatable({}, Connection)
		
		self.primary = nil
		self.actions = {--[[type: disconnect, node: Marker10]]}
		
		-- loop over objValues and add actions to table
		for _, objValue in pairs(connection) do
			local connectionType = objValue.Name
			local node = objValue.Value.Name
			if connectionType == "Node" then
				self.primary = node
			elseif connectionType == "Connect" then
				table.insert(self.actions, {type = "connect", node = node})
			elseif connectionType == "Disconnect" then
				table.insert(self.actions, {type = "disconnect", node = node})
			end
		end
		
		return self
	end
end


do -- obstacle
	---@class Obstacle
	local Obstacle = {}
	Obstacle.__index = Obstacle

	---@param graph AdjacencyList
	---@return Obstacle
	function Obstacle.new(model, graph)
		---@type Obstacle
		local self = setmetatable({}, Obstacle)
		
		self.id = nil
		self.model = model
		self.graph = graph
		self.hitbox = self.model.Hitbox
		self.Activated = Instance.new("BindableEvent")
		self.connections = {}
		
		for _, connection in pairs(self.model.Connections:GetChildren()) do
			local new_connection = module.Connection.new(connection:GetChildren())
			table.insert(self.connections, new_connection)
		end
		
		self.hitbox.ClickDetector.MouseClick:Connect(function()
			self:onClicked()
		end)
		
		return self
	end

	
	-- this is bad, obstacle shouldn't be able to edit graph?
	function Obstacle:onClicked()
		self.hitbox:Destroy()
		
		for _, connection in pairs(self.connections) do
			local primaryConnection
			for _, node in pairs(connection) do
				local connectType = string.sub(node.name, 1, -2)
				
				if not primaryConnection then
					primaryConnection = node.value
				else
					if connectType == "Connect" then
						print("connecting nodes", primaryConnection, "and", node.value)
						self.graph:AddAdjacency(primaryConnection, node.value)
					elseif connectType == "Disconnect" then
						print("disconnecting nodes", primaryConnection, "and", node.value)
						self.graph:RemoveAdjacency(primaryConnection, node.value)
					end
				end
			end
		end
		
		require(self.model.Activate).onActivate()
		-- need to make changes to the path when this is activated. How?
	end
	
	module.Obstacle = Obstacle
end


do -- ObstacleController
	---@class ObstacleController
	local ObstacleController = {}
	ObstacleController.__index = ObstacleController
	
	---@return ObstacleController
	function ObstacleController.new()
		---@type ObstacleController
		local self = setmetatable({}, ObstacleController)
		
		self._obstacles = {}
		
		return self
	end
	
	---@param obstacle Obstacle
	function ObstacleController:addObstacle(obstacle)
		local obstaclePositon = #self._obstacles + 1
		
		self._obstacles[obstaclePositon] = obstacle
		obstacle.id = obstaclePositon
	end
	
	function ObstacleController:createObstacle(id, model)
		
	end
	
	module.ObstacleController = ObstacleController
end


return module
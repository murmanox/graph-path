local module = {}


local function eventWrapper(func, event)
	return function(...)
		func(...)
		event:Fire()
	end
end


do	-- AdjacencyList
	---@class AdjacencyNode
	local Node = {}
	Node.__index = Node
	
	---@return AdjacencyNode
	function Node.fromPart(part)
		---@type AdjacencyNode
		local self = setmetatable({}, Node)

		self.Position = part.Position
		self.Name = part.Name
		self.Adjacencies = {}

		return self
	end

	
	---@class AdjacencyList
	local AdjacencyList = {}
	AdjacencyList.__index = AdjacencyList

	AdjacencyList.Node = Node
	
	---@return AdjacencyList
	function AdjacencyList.new(initFunc)
		local self = {
			parent = AdjacencyList,
			start = {},
			list = {},
			events = {
				Changed = Instance.new("BindableEvent"),
			},
		}
		
		local mt = {
			__index = function(t, k)
				if self.list[k] then
					return self.list[k]
				else
					return self.parent[k]
				end
			end
		}
		setmetatable(self, mt)
		
		if initFunc then initFunc(self) end
		
		-- initialisation finished, add events to functions
		self.Changed = self.events.Changed.Event
		
		self.setStart = eventWrapper(self.setStart, self.events.Changed)
		self.AddNode = eventWrapper(self.AddNode, self.events.Changed)
		self.AddAdjacency = eventWrapper(self.AddAdjacency, self.events.Changed)
		self.RemoveAdjacency = eventWrapper(self.RemoveAdjacency, self.events.Changed)
		-- self.RemoveNode = eventWrapper(self.RemoveNode, self.events.Changed)
		
		return self
	end
	
	function AdjacencyList:setStart(value)
		self.start = value
	end

	function AdjacencyList:AddNode(node, index)
		index = index or node.Name or #self + 1
		self.list[index] = node
	end
	
	function testIsNode(self, node)
		if type(node) == "string" then
			node = self[node]
		end
		assert(node ~= nil, "node cannot be nil")
		return node
	end
	
	function AdjacencyList:AddAdjacency(node, link)
		node = testIsNode(self, node)
		link = testIsNode(self, link)
		
		if not table.find(node.Adjacencies, link) then
			table.insert(node.Adjacencies, link)
		end
	end
	
	---@param node AdjacencyNode
	---@param link AdjacencyNode
	function AdjacencyList:RemoveAdjacency(node, link)
		node = testIsNode(self, node)
		link = testIsNode(self, link)
		
		table.remove(node.Adjacencies, table.find(node.Adjacencies, link))
	end

	
	function AdjacencyList:getPaths()
		local paths = {}
		for _, startPoint in pairs(self.start) do
			AdjacencyList.getPathsFromPoint(startPoint, paths)
		end
		return paths
	end
	
	function AdjacencyList.getPathsFromPoint(start, paths)
		local function recursiveSearch(startNode, allPaths, currentPath)
			currentPath = currentPath or {}
			table.insert(currentPath, startNode.Position)

			for _, node in pairs(startNode.Adjacencies) do
				if #node.Adjacencies == 0 then
					table.insert(currentPath, node.Position)
					table.insert(allPaths, currentPath)
				else
					local t = #startNode.Adjacencies > 1 and {unpack(currentPath)} or currentPath
					recursiveSearch(node, allPaths, t)
				end
			end
		end

		paths = paths or {}
		recursiveSearch(start, paths)
		return paths
	end

	function AdjacencyList.getPathsBetweenPoints(startNode, endNode, paths)
		local function recursiveSearch(startNode, endNode, allPaths, currentPath)
			currentPath = currentPath or {}
			table.insert(currentPath, startNode.Name)

			for _, node in pairs(startNode.Adjacencies) do
				if node == endNode then
					table.insert(currentPath, node.Name)
					table.insert(allPaths, currentPath)
				else
					local t = #startNode.Adjacencies > 1 and {unpack(currentPath)} or currentPath
					recursiveSearch(node, endNode, allPaths, t)
				end
			end
		end

		paths = paths or {}
		recursiveSearch(startNode, endNode, paths)
		return paths
	end

	module.AdjacencyList = AdjacencyList
end


return module
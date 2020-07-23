local module = {}


do	-- AdjacencyList
	---@class AdjacencyNode
	local Node = {}
	Node.__index = Node
	
	---@return AdjacencyNode
	function Node.fromPart(part)
		---@type AdjacencyNode
		local self = setmetatable({}, Node)

		self.Positon = part.Position
		self.Name = part.Name
		self.Adjacencies = {}

		return self
	end


	---@class AdjacencyList
	local AdjacencyList = {}
	AdjacencyList.__index = AdjacencyList

	AdjacencyList.Node = Node
	
	---@return AdjacencyList
	function AdjacencyList.new()
		local self = setmetatable({}, AdjacencyList)

		return self
	end

	function AdjacencyList:AddNode(node, index)
		index = index or node.Name or #self + 1
		self[index] = node
	end

	function AdjacencyList:AddAdjacency(node, link)
		if not table.find(node.Adjacencies, link) then
			table.insert(node.Adjacencies, link)
		end
	end
	
	---@param node AdjacencyNode
	---@param link AdjacencyNode
	function AdjacencyList:RemoveAdjacency(node, link)
		
		if type(node) == "string" then
			node = self[node]
		end
		
		if type(link) == "string" then
			link = self[link]
		end
		
		assert(node ~= nil, "node cannot be nil")
		assert(link ~= nil, "link cannot be nil")
		
		table.remove(node.Adjacencies, table.find(node.Adjacencies, link))
			
		
	end

	function AdjacencyList.getPathsFromPoint(start, paths)
		local function recursiveSearch(startNode, allPaths, currentPath)
			currentPath = currentPath or {}
			table.insert(currentPath, startNode.Name)

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
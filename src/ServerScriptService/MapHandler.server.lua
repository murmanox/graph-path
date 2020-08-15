---@type PathingService
local PathingService = require(game.ServerScriptService.Modules.Services.PathingService)

local DataStructure = require(game.ReplicatedStorage.Modules.DataStructure)
local Obstacles = require(game.ServerScriptService.Modules.Obstacles)
---@type AdjacencyList
local AdjacencyList = DataStructure.AdjacencyList
local Node = AdjacencyList.Node

---@type ObstacleController
local ObstacleController = Obstacles.ObstacleController
---@type Obstacle
local Obstacle = Obstacles.Obstacle

---@type WaveSpawner
local WaveSpawner = require(game.ServerScriptService.Modules.WaveSpawner)


-- I'm not a fan of this
local function folderToNodesFunc(self)
	local children = workspace.Level.Path:GetChildren()
	
	for _, marker in pairs(children) do
		self:AddNode(Node.fromPart(marker))
	end
	
	for _, marker in pairs(children) do
		for _, link in pairs(marker:GetChildren()) do
			if link:IsA("ObjectValue") and link.Value then
				self:AddAdjacency(self[marker.Name], self[link.Value.Name])
			end
		end
	end
end


function initObstacles()
	local obstacles = {workspace.Level.Interactive:GetChildren()}
	for _, obstacle in pairs(obstacles) do
		local o = Obstacle.new(obstacle, aList)
		
		o.Activated.Event:Connect(function()
			table.remove(table.find(obstacles, o))
		end)
	end
end


function initMap()
	-- copy map to workspace
	
	local aList = AdjacencyList.new(folderToNodesFunc)
	aList:setStart({aList["Marker1"]})
	workspace.Level.Path:Destroy()
	
	-- temporary to test tower
	local t = require(game.ReplicatedStorage.Modules.Towers.BaseTower).new(require(game.ReplicatedStorage.Configs.TowerStats).Standard)
	
	PathingService:SetGraph(aList)
	local wave_spawner = WaveSpawner.new()
	wave_spawner:Start()
end

wait(2)
initMap()
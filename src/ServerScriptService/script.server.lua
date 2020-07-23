local DataStructure = require(game.ReplicatedStorage.Modules.DataStructure)
local AdjacencyList = DataStructure.AdjacencyList
local Node = AdjacencyList.Node


function initAdjacencyListFromFolder(folder)
	local children = folder:GetChildren()
	local aList = AdjacencyList.new()
	for _, marker in pairs(children) do
		aList:AddNode(Node.fromPart(marker))
	end

	for _, marker in pairs(children) do
		for _, link in pairs(marker:GetChildren()) do
			if link:IsA("ObjectValue") and link.Value then
				aList:AddAdjacency(aList[marker.Name], aList[link.Value.Name])
			end
		end
	end
	
	return aList
end


function getPathsFromStartPoints(startPoints)
	local paths = {}
	for _, startPoint in pairs(startPoints) do
		paths[startPoint.Name] = AdjacencyList.getPathsFromPoint(startPoint)
	end
	return paths
end

local aList = initAdjacencyListFromFolder(workspace.level.Path)
local paths = getPathsFromStartPoints({aList["Marker1"]})
print(paths)



local Tree = workspace.Tree
Tree.Hitbox.ClickDetector.MouseClick:Connect(function()
	Tree.Hitbox:Destroy()
	
	local RotationPart = Tree.RotationPart
	for k, v in pairs(Tree:GetChildren()) do
		if v ~= RotationPart and v:IsA("BasePart") then
			v.Anchored = false
		end
	end
	
	local goal = {CFrame = RotationPart.CFrame * CFrame.Angles(math.rad(90), 0, 0)}
	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
	local tween = game.TweenService:Create(RotationPart, tweenInfo, goal)
	
	tween:Play()
	
	print()
	print("Removing link between 2 and 5")
	aList:RemoveAdjacency("Marker2", "Marker5")
	paths[startPoints[1].Name] = (AdjacencyList.getPathsFromPoint(startPoints[1]))
end)


local function getKeys(tbl)
	local t = {}
	for k, _ in pairs(tbl) do
		table.insert(t, k)
	end
	return t
end


local keys = getKeys(paths)
local i = 0
while true do
	wait(1)
	
	i = i + 1
	if i > #keys then
		i = 1
	end
	local key = keys[i]
	
	coroutine.wrap(function()
		
		local pathCounter = 0
		
		local startOfPath = paths[key]
		local path = 
		
		local start = paths[keys[math.random(#keys)]]
		
		local dummy = workspace.Enemy:Clone()
		local humanoid = dummy.Humanoid
		dummy.HumanoidRootPart.Position = start.Position
		dummy.Parent = workspace
	end)()
	
	--Enemy.HumanoidRootPart.Position
end
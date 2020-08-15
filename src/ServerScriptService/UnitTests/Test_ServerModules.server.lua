local Settings = require(game.ServerScriptService.Configs.ServerSettings)

-- this is bodged, if this is necessary in the future, improve this
if Settings.Testing.test_require_all_modules == false then
	return
end

wait(3)
local locations = {workspace, game.ReplicatedStorage, game.ServerScriptService, game.ServerStorage, game.StarterGui}

for _, location in pairs(locations) do
	for _, object in pairs(location:GetDescendants()) do
		local noError, isModule = pcall(function() return object.ClassName == "ModuleScript" end)
		if noError and isModule == true then
			print("Initialising", object.Name, "Module")
			local success, errormsg = pcall(function() require(object) end)
			if success then
				print("Finished initialising", object.Name, "Module")
			else
				print(errormsg)
			end
		end
	end
end
local Table = {}

function Table.Copy(t1)
	local t = {}
	for k, v in pairs(t1) do
		t[k] = v
	end
	return t
end

function Table.Merge(t1, t2)
	local t = Table.Copy(t1)
	for k, v in pairs(t2) do
		t[k] = v
	end
	return t
end

return Table
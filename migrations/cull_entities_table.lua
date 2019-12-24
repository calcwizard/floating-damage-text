
-- removes invalid entities from the entities table to remove invalid entities

if global.entities and global.entity_health then
	for k,v in pairs(global.entities) do
		if not global.entity_health[k] then -- if there isn't a corresponding entry in entity_health, remove it
			global.entities[k] = nil
		end
	end
end
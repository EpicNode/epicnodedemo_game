--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015                                                                                 --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- 'Can grow' function

local random = math.random

function game.can_grow(pos)
	local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	local is_soil = minetest.get_item_group(name_under, "soil")
	if is_soil == 0 then
		return false
	end
	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 13 then
		return false
	end
	return true
end

minetest.register_abm({
	nodenames = {"group:sapling"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		print(node.name)
		--if not game.can_grow(pos) then
		--	return
		--end
		local found, _, mod, tree, sapling = node.name:find("^([%w%-]+)[:] *([%w%-]+)[_] *([%w%-]+)")
		--print(tree.." => "..sapling)
		return
		
	end
})

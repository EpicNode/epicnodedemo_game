--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015                                                                                 --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

game.register("node", "door_closed", {
	description = "Wooden Door",
	drawtype = "mesh",
	mesh = "door_closed.obj",
	tiles = {"game_door.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2,door=1},
	sounds = game.sound("wood"),
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(os)
		local name = placer:get_player_name()
		meta:set_string("owner", name)
		return itemstack
	end,
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.3, 1.5, 2.5, 0.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.3, 1.5, 2.5, 0.5}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "game:door_open"
		minetest.swap_node(pos, node)
	end
})

game.register("node", "door_open", {
	description = "Wooden Door",
	drawtype = "mesh",
	mesh = "door_open.obj",
	tiles = {"game_door.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2,door=1,not_in_creative_inventory=1},
	sounds = game.sound("wood"),
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local name = placer:get_player_name()
		meta:set_string("owner", name)
		return itemstack
	end,
	drop = "game:door_closed",
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.5, -0.3, 2.5, -1.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.5, -0.3, 2.5, -1.5}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "game:door_closed"
		minetest.swap_node(pos, node)
	end
})

game.register("node", "door_locked_closed", {
	description = "Wooden Door",
	drawtype = "mesh",
	mesh = "door_closed.obj",
	tiles = {"game_door_locked.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2,door=1},
	sounds = game.sound("wood"),
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local name = placer:get_player_name()
		meta:set_string("owner", name)
		meta:set_string("infotext", "Owned by "..name)
		return itemstack
	end,
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.3, 1.5, 2.5, 0.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.3, 1.5, 2.5, 0.5}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		local privs = minetest.get_player_privs(clicker:get_player_name())
		if game.is_owner(pos, clicker) or privs.server then
			node.name = "game:door_locked_open"
			minetest.swap_node(pos, node)
		end
	end,
	can_dig = function(pos, player)
		return game.is_owner(pos, player)
	end,
})

game.register("node", "door_locked_open", {
	description = "Wooden Door",
	drawtype = "mesh",
	mesh = "door_open.obj",
	tiles = {"game_door_locked.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2,door=1,not_in_creative_inventory=1},
	sounds = game.sound("wood"),
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local name = placer:get_player_name()
		meta:set_string("owner", name)
		meta:set_string("infotext", "Owned by "..name)
		return itemstack
	end,
	drop = "game:door_locked_closed",
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.5, -0.3, 2.5, -1.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.5, -0.3, 2.5, -1.5}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "game:door_locked_closed"
		minetest.swap_node(pos, node)
	end,
	can_dig = function(pos, player)
		return game.is_owner(pos, player)
	end,
})
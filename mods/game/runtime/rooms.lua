--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--©2015 GNU LGPL v2.1                                                                     --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

game.register("node", "room_door", {
	description = "Wooden Door",
	drawtype = "mesh",
	mesh = "door_closed.obj",
	tiles = {"game_door.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {not_in_creative_inventory = 1},
	sounds = game.sound("wood"),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.3, 1.5, 2.5, 0.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.3, 1.5, 2.5, 0.5}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
	end,
})

game.register("node", "room_door_closed", {
	description = "Wooden room_Door",
	drawtype = "mesh",
	mesh = "door_closed.obj",
	tiles = {"game_door.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {door=1,not_in_creative_inventory=1},
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
		node.name = "game:room_door_open"
		minetest.swap_node(pos, node)
	end
})

game.register("node", "room_door_open", {
	description = "Wooden room_Door",
	drawtype = "mesh",
	mesh = "door_open.obj",
	tiles = {"game_door.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {door=1,not_in_creative_inventory=1},
	sounds = game.sound("wood"),
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local name = placer:get_player_name()
		meta:set_string("owner", name)
		return itemstack
	end,
	drop = "game:room_door_closed",
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.5, -0.3, 2.5, -1.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.5, -0.3, 2.5, -1.5}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "game:room_door_closed"
		minetest.swap_node(pos, node)
	end
})

game.register("node", "room", {
	description = "Room",
	tiles = {"game_room.png"},
	drawtype = "mesh",
	mesh = "room.obj",
	paramtype = "light",
	is_ground_content = false,
	sounds = game.sound("default"),
	groups = {cracky = 2,not_in_creative_inventory = 1},
	collision_box = {
		type = "fixed",
		         --x    z    y   x    z   y
		fixed = {{-1.3,0.5,1.15,-1.5,4.5,0.5},
				{-1.3,0.5,-2.55,-1.5,4.5,-2.5},
				{-1.5,-0.5,-0.5,0.5,0.5,0.5},
				{-1.5,0.5,1.15,2.5,4.5,0.95},}
	},
})

game.register("node", "fireplace", {
	description = "fireplace",
	tiles = {"default_stone.png"},
	drawtype = "mesh",
	mesh = "fireplace.obj",
	paramtype = "light",
	is_ground_content = false,
	sounds = game.sound("default"),
	groups = {not_in_creative_inventory = 1},
	collision_box = {
		type = "fixed",
		         --x    z    y   x    z   y
		fixed = {{-1.5,-0.5,-0.5,0.5,0.5,0.5},
				{-0.5,0.5,-1,0.5,1.5,1},
				{-0.5,1.5,-1,0.5,4.5,1},
				{-0.5,0.5,-0.3,0.5,4.5,0.3},}
	},
	selection_box = {
		type = "fixed",
		         --x    z    y   x    z   y
		fixed = {{-1.5,-0.5,-0.5,0.5,0.5,0.5},
				{-0.5,0.5,-1.5,0.5,4.5,1.5},}
	},
})

game.register("node", "room_mantel", {
	description = "mantel",
	tiles = {"game_door.png"},
	drawtype = "mesh",
	mesh = "fireplacemantel.obj",
	paramtype = "light",
	is_ground_content = false,
	groups = {not_in_creative_inventory = 1},
	pointable = false,
})

game.register("node", "room_block", {
	description = "room block",
	tiles = {"default_cobble.png"},
	is_ground_content = false,
	paramtype = "light",
	light_source = 3,
	groups = {not_in_creative_inventory = 1},
})

game.register("node", "room_air", {
	description = "room air",
	is_ground_content = false,
	paramtype = "light",
	drawtype = "airlike",
	light_source = 3,
	pointable = false,
	groups = {not_in_creative_inventory = 1},
})

game.register("node", "room_table", {
	description = "table",
	tiles = {"game_tree.png"},
	drawtype = "mesh",
	mesh = "table.obj",
	paramtype = "light",
	is_ground_content = false,
	groups = {not_in_creative_inventory = 1},
})

game.register("node", "room_plac", {
	description = "room placer",
	tiles = {"default_cobble.png^default_torch_on_floor.png"},
	is_ground_content = false,
	paramtype = "light",
	light_source = 3,
	groups = {cracky = 1},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local path = minetest.get_modpath("game") .. "/schems/room.mts"
		minetest.place_schematic({x = pos.x - 4, y = pos.y - 1, z = pos.z - 5}, path, 0, nil, true)
		return itemstack
	end,
})
--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

screwdriver = screwdriver or {}

game.active = {}

function game.start_smoke(pos,node)
	local this_spawner_meta = minetest.get_meta(pos)
	local id = this_spawner_meta:get_int("smoky")
	local eid = this_spawner_meta:get_int("embers")
	local s_handle = this_spawner_meta:get_int("sound")
	local above = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name

	if id ~= 0 then
		if s_handle then
			minetest.after(0, function(s_handle)
				minetest.sound_stop(s_handle)
			end, s_handle)
		end
		minetest.delete_particlespawner(id)
		minetest.delete_particlespawner(eid)
		this_spawner_meta:set_int("smoky", nil)
		this_spawner_meta:set_int("embers", nil)
		this_spawner_meta:set_int("sound", nil)
	end

	if above == "air" and (not id or id == 0) then
		id = minetest.add_particlespawner({
			amount = 4, time = 0, collisiondetection = true,
			minpos = {x=pos.x-0.25, y=pos.y+0.4, z=pos.z-0.25},
			maxpos = {x=pos.x+0.25, y=pos.y+5, z=pos.z+0.25},
			minvel = {x=-0.2, y=0.3, z=-0.2}, maxvel = {x=0.2, y=1, z=0.2},
			minacc = {x=0,y=0,z=0}, maxacc = {x=0,y=0.5,z=0},
			minexptime = 1, maxexptime = 4,
			minsize = 4, maxsize = 10,
			texture = "smoke_particle.png",
		})
		eid = minetest.add_particlespawner({
			amount = 1, time = 0, collisiondetection = true,
			minpos = {x=pos.x-0.25, y=pos.y, z=pos.z-0.25},
			maxpos = {x=pos.x+0.25, y=pos.y+0.5, z=pos.z+0.25},
			minvel = {x=-0.2, y=0.3, z=-0.2}, maxvel = {x=0.2, y=0.6, z=0.2},
			minacc = {x=0,y=0,z=0}, maxacc = {x=0,y=0.5,z=0},
			minexptime = 0.75, maxexptime = 3,
			minsize = 0.2, maxsize = 0.7,
			texture = minetest.registered_nodes[node.name]["ember"],
		})
		s_handle = minetest.sound_play("fire_small", {
			pos = pos,
			max_hear_distance = 5,
			loop = true 
		})
		this_spawner_meta:set_int("smoky", id)
		this_spawner_meta:set_int("embers", eid)
		this_spawner_meta:set_int("sound", s_handle)
		game.active[pos.x.."_"..pos.y.."_"..pos.z] = true
	return end
end

function game.stop_smoke(pos)
	local this_spawner_meta = minetest.get_meta(pos)
	local id = this_spawner_meta:get_int("smoky")
	local eid = this_spawner_meta:get_int("embers")
	local s_handle = this_spawner_meta:get_int("sound")
	if id ~= 0 then
		minetest.delete_particlespawner(id)
	end
	if eid ~= 0 then
		minetest.delete_particlespawner(eid)
	end
	if s_handle then
		minetest.after(0, function(s_handle)
			minetest.sound_stop(s_handle)
		end, s_handle)
	end
	this_spawner_meta:set_int("smoky", nil)
	this_spawner_meta:set_int("embers", nil)
	this_spawner_meta:set_int("sound", nil)
end

-- FLAME TYPES
local flame_types = {"fake", "ice"}

for _, f in ipairs(flame_types) do
	minetest.register_node("game:"..f.."_fire", {
		inventory_image = f.."_fire_inv.png",
		ember = f.."_particle.png",
		description = f.." fire",
		drawtype = "mesh",
		mesh = "fire.obj",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {dig_immediate=3,smoke=1},
		sunlight_propagates = true,
		buildable_to = true,
		walkable = false,
		light_source = 14,
		waving = 1,
		tiles = {
			{name=f.."_fire_animated.png", animation={type="vertical_frames", 
			aspect_w=16, aspect_h=16, length=1.5}},
		},
		on_construct = function (pos)
			local node = minetest.get_node(pos)
			game.start_smoke(pos,node)
		end,
		on_destruct = function (pos)
			game.stop_smoke(pos)
			minetest.sound_play("fire_extinguish", {
				pos = pos, max_hear_distance = 5
			})
		end,
		drop = ""
	})
end

minetest.register_node("game:fancy_fire", {
		inventory_image = "fancy_fire_inv.png",
		ember = "fake_particle.png",
		description = "Fancy Fire",
		drawtype = "mesh",
		mesh = "fancy_fire.obj",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {dig_immediate=3,smoke=1},
		sunlight_propagates = true,
		light_source = 14,
		walkable = false,
		damage_per_second = 4,
		on_rotate = screwdriver.rotate_simple,
		tiles = {
		{name="fake_fire_animated.png", 
		animation={type='vertical_frames', aspect_w=16, aspect_h=16, length=1}}, {name='fake_fire_logs.png'}},
		on_construct = function (pos)
			local node = minetest.get_node(pos)
			game.start_smoke(pos, node)
		end,
		on_destruct = function (pos)
			game.stop_smoke(pos)
			minetest.sound_play("fire_extinguish", {
				pos = pos, max_hear_distance = 5
			})
		end,
		drop = {
			max_items = 3,
			items = {
				{
					items = { "default:torch", "default:torch", "building_blocks:sticks" },
					rarity = 1,
				}
			}
		}
	})

-- EMBERS
minetest.register_node("game:embers", {
    description = "Glowing Embers",
	tiles = {
		{name="embers_animated.png", animation={type="vertical_frames",
		aspect_w=16, aspect_h=16, length=2}},
	},
	light_source = 9,
	groups = {crumbly=3},
	paramtype = "light",
	sounds = game.sound("dirt"),
})




-- FLINT and STEEL
minetest.register_tool("game:flint_and_steel", {
	description = "Flint and steel",
	inventory_image = "flint_and_steel.png",
	liquids_pointable = false,
	stack_max = 1,
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps={flamable = {uses=65, maxlevel=1}}
	},
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" and minetest.get_node(pointed_thing.above).name == "air" then
			if not minetest.is_protected(pointed_thing.above, user:get_player_name()) then
				if string.find(minetest.get_node(pointed_thing.under).name, "ice") then
					minetest.set_node(pointed_thing.above, {name="game:ice_fire"})
				else
					minetest.set_node(pointed_thing.above, {name="game:fake_fire"})
				end
			else
				minetest.chat_send_player(user:get_player_name(), "This area is protected!")
			end
		else
			return
		end

		itemstack:add_wear(65535/65)
		return itemstack
	end
})

-- CRAFTS
minetest.register_craft({
	type = "shapeless",
	output = 'game:flint_and_steel',
	recipe = {"default:obsidian_shard", "default:steel_ingot"}
})

minetest.register_craft({
	type = "shapeless",
	output = 'game:embers',
	recipe = {"default:torch", "group:wood", "default:torch"}
})

minetest.register_craft({
	type = "shapeless",
	output = 'game:fancy_fire',
	recipe = {"default:torch", "building_blocks:sticks", "default:torch" }
})

-- ALIASES
minetest.register_alias("game:smokeless_fire", "game:fake_fire")
minetest.register_alias("game:smokeless_ice_fire", "game:ice_fire")
minetest.register_alias("game:smokeless_chimney_top_stone", "game:chimney_top_stone")
minetest.register_alias("game:smokeless_chimney_top_sandstone", "game:chimney_top_sandstone")
minetest.register_alias("game:flint", "game:flint_and_steel")

minetest.register_abm({
	nodenames = {"group:smoke"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		if game.active[pos.x.."_"..pos.y.."_"..pos.z] == true then return end
		game.start_smoke(pos,node)
		return
		
	end
})
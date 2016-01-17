--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015                                                                                 --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

function game.validate_object(object)
	if object:is_player() == true then
		return true, true
	end
	local luaentity = object:get_luaentity()
	if luaentity then
		if minetest.registered_entities[luaentity.name] then
			return true, false
		end
	end
	return false
end

function game.axe_onuse(itemstack, player, pointed_thing, def)
	local pos = minetest.get_pointed_thing_position(pointed_thing, false)
	if not pos then return end
	if pointed_thing.type == "object" then
		local object = pointed_thing.ref
		local valid, isplayer = game.validate_object(object)
		if valid then 
			if isplayer then
				local plname = object:get_player_name()
				local weapon = player:get_wielded_item()
				local damage = weapon:get_definition().damage or weapon:get_definition().tool_capabilities.damage_groups.fleshy or 0
				return game.damage_player(plname, damage)
			end
			object:punch(player, nil, weapon:get_definition().tool_capabilities,nil)
			itemstack:add_wear(def.wear)
			return
		end
	end
	local node = minetest.get_node(pos)
	local chop = minetest.get_item_group(node.name, "axe_needed")
	if chop < 1 then return end
	local meta = minetest.get_meta(pos);
	local hits = tonumber(meta:get_string("hits"))
	hits = hits - 1
	if hits <= 0 then 
		minetest.env:add_item({x=pos.x,y=pos.y+0.5,z=pos.z},node.name..' 1')
		minetest.remove_node(pos)
	end
	meta:set_string("hits", hits)
	itemstack:add_wear(def.wear)
	return itemstack
end

function game.weapon_onuse(itemstack, player, pointed_thing, rest_time)
	rest_time = rest_time or 0.5
	local pos = minetest.get_pointed_thing_position(pointed_thing, false)
	if not pos then return end
	local plname = player:get_player_name()
	if game.timer < game.last_hit[plname]+rest_time or game.last_hit[plname] + game.timer > 30000 then
		return
	end
	game.last_hit[plname] = game.timer
	if pointed_thing.type == "object" then
		local object = pointed_thing.ref
		local valid, isplayer = game.validate_object(object)
		if valid then 
			local name = object:get_player_name()
			local weapon = player:get_wielded_item()
			local damage = weapon:get_definition().damage or weapon:get_definition().tool_capabilities.damage_groups.fleshy or 0
			local lvl = weapon:get_definition().lvl or 1
			if lvl > game.stats.lvl[plname] then
				minetest.chat_send_player(plname, "Your Level is too low to use this weapon!")
				return
			end
			if game.stats.hp[plname] == "dead" then return end
			if isplayer then
				return game.damage_player(name, damage, lvl)
			end
			object:punch(player, nil, weapon:get_definition().tool_capabilities,nil)
			return
		end
	end
end

-- The hand
minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
		},
		damage_groups = {fleshy=1},
	}
})

--
-- Picks
--

game.register("tool", "pick_wood", {
	description = "Wooden Pickaxe",
	inventory_image = "default_tool_woodpick.png",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[3]=1.60}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
game.register("tool", "pick_stone", {
	description = "Stone Pickaxe",
	inventory_image = "default_tool_stonepick.png",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.3,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=2.0, [3]=1.00}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
})
game.register("tool", "pick_steel", {
	description = "Steel Pickaxe",
	inventory_image = "default_tool_steelpick.png",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=20, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
game.register("tool", "pick_bronze", {
	description = "Bronze Pickaxe",
	inventory_image = "default_tool_bronzepick.png",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
game.register("tool", "pick_mese", {
	description = "Mese Pickaxe",
	inventory_image = "default_tool_mesepick.png",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
})
game.register("node", "pick_diamond", {
	description = "Diamond Pickaxe",
	tiles = {"game_diamondaxe.png"},
	drawtype = "mesh",
	paramtype = "light",
	mesh = "pick.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	groups = {not_in_creative_inventory=1,tool=1},
	range = 3,
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})

--
-- Shovels
--

game.register("tool", "shovel_wood", {
	description = "Wooden Shovel",
	inventory_image = "default_tool_woodshovel.png",
	wield_image = "default_tool_woodshovel.png^[transformR90",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=3.00, [2]=1.60, [3]=0.60}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
game.register("tool", "shovel_stone", {
	description = "Stone Shovel",
	inventory_image = "default_tool_stoneshovel.png",
	wield_image = "default_tool_stoneshovel.png^[transformR90",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.4,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=1.80, [2]=1.20, [3]=0.50}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
game.register("tool", "shovel_steel", {
	description = "Steel Shovel",
	inventory_image = "default_tool_steelshovel.png",
	wield_image = "default_tool_steelshovel.png^[transformR90",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
})
game.register("tool", "shovel_bronze", {
	description = "Bronze Shovel",
	inventory_image = "default_tool_bronzeshovel.png",
	wield_image = "default_tool_bronzeshovel.png^[transformR90",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=40, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
})
game.register("tool", "shovel_mese", {
	description = "Mese Shovel",
	inventory_image = "default_tool_meseshovel.png",
	wield_image = "default_tool_meseshovel.png^[transformR90",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=1.20, [2]=0.60, [3]=0.30}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
})
game.register("tool", "shovel_diamond", {
	description = "Diamond Shovel",
	inventory_image = "default_tool_diamondshovel.png",
	wield_image = "default_tool_diamondshovel.png^[transformR90",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
})

--
-- Axes
--

game.register("tool", "axe_wood", {
	description = "Wooden Axe",
	inventory_image = "default_tool_woodaxe.png",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=3.00, [3]=1.60}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
game.register("tool", "axe_stone", {
	description = "Stone Axe",
	inventory_image = "default_tool_stoneaxe.png",
	groups = {not_in_creative_inventory=1,tool=1},
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			choppy={times={[1]=3.00, [2]=2.00, [3]=1.30}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
})
game.register("tool", "axe_steel", {
	description = "Steel Axe",
	inventory_image = "default_tool_steelaxe.png",
	groups = {not_in_creative_inventory=1,tool=1},
	range = 3,
	on_use = function(itemstack, user, pointed_thing)
		game.axe_onuse(itemstack, user, pointed_thing, {
			wear=300,
			tool_caps = {
				full_punch_interval = 1.0,
				max_drop_level=1,
				groupcaps={
					choppy={times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=20, maxlevel=2},
				},
				damage_groups = {fleshy=4},
			},
		})
	end,
})
game.register("tool", "axe_bronze", {
	description = "Bronze Axe",
	inventory_image = "default_tool_bronzeaxe.png",
	groups = {not_in_creative_inventory=1,tool=1},
	range = 3,
	on_use = function(itemstack, user, pointed_thing)
		game.axe_onuse(itemstack, user, pointed_thing, {
			wear=300,
			tool_caps = {
				full_punch_interval = 1.0,
				max_drop_level=1,
				groupcaps={
					choppy={times={[1]=2.40, [2]=1.20, [3]=0.80},  maxlevel=2},
				},
				damage_groups = {fleshy=5},
			},
		})
	end,
})
game.register("tool", "axe_mese", {
	description = "Mese Axe",
	inventory_image = "default_tool_meseaxe.png",
	groups = {not_in_creative_inventory=1,tool=1},
	range = 3,
	on_use = function(itemstack, user, pointed_thing)
		game.axe_onuse(itemstack, user, pointed_thing, {
			wear=300,
			tool_caps = {
				full_punch_interval = 0.9,
				max_drop_level=1,
				groupcaps={
					choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=20, maxlevel=3},
				},
				damage_groups = {fleshy=6},
			},
		})
	end,
})
game.register("node", "axe_diamond", {
	description = "Diamond Axe",
	tiles = {"game_diamondaxe.png"},
	drawtype = "mesh",
	paramtype = "light",
	mesh = "axe.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	groups = {not_in_creative_inventory=1,tool=1},
	range = 3,
	on_use = function(itemstack, user, pointed_thing)
		game.axe_onuse(itemstack, user, pointed_thing, {
			wear=300,
			tool_caps = {
				full_punch_interval = 0.9,
				max_drop_level=1,
				groupcaps={
					choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=30, maxlevel=2},
				},
				damage_groups = {fleshy=7},
			},
		})
	end,
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})

--
-- Swords
--

game.register("node", "wood_sword", {
	description = "Wooden Sword",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "sword.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"default_wood.png^game_sword_overlay.png"},
	groups = {not_in_creative_inventory=1,dig_immediate=3,weapon=1},
	range = 3,
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=1.6, [3]=0.40}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})
game.register("node", "iron_sword", {
	description = "Iron Sword",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "sword.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"default_iron_block.png^game_sword_overlay.png"},
	groups = {not_in_creative_inventory=1,dig_immediate=3,weapon=1},
	range = 3,
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			snappy={times={[1]=3.0, [2]=1.4, [3]=0.40}, uses=25, maxlevel=1},
		},
		damage_groups = {fleshy=5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})
game.register("node", "steel_sword", {
	description = "Steel Sword",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "sword.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"default_steel_block.png^game_sword_overlay.png"},
	groups = {not_in_creative_inventory=1,dig_immediate=3,weapon=1},
	range = 3,
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=6},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})
game.register("node", "bronze_sword", {
	description = "Bronze Sword",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "sword.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"default_bronze_block.png^game_sword_overlay.png"},
	groups = {not_in_creative_inventory=1,dig_immediate=3,weapon=1},
	range = 3,
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=40, maxlevel=2},
		},
		damage_groups = {fleshy=6},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})
game.register("node", "mese_sword", {
	description = "Mese Sword",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "sword.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"default_mese_block.png^game_sword_overlay.png"},
	groups = {not_in_creative_inventory=1,dig_immediate=3,weapon=1},
	range = 3,
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.0, [2]=1.00, [3]=0.35}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})
game.register("node", "diamond_sword", {
	description = "Diamond Sword",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "sword.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"default_diamond_block.png^game_sword_overlay.png"},
	groups = {not_in_creative_inventory=1,dig_immediate=3,weapon=1},
	range = 3,
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
			fleshy ={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})


game.register("node", "war_hammer", {
	description = "War Hammer (basic)",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "war_hammer.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"game_warhammer.png"},
	groups = {dig_immediate=3,warrior=1,not_in_creative_inventory=1},
	range = 4,
	damage = 13,
	on_use = function(itemstack, user, pointed_thing)
		game.weapon_onuse(itemstack, user, pointed_thing)
	end,
	tool_capabilities = {
		full_punch_interval = 1.4,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
			fleshy ={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
		},
		damage_groups = {fleshy=13},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.7, 0.1}
	},
})


game.register("node", "battle_axe", {
	description = "Battle Axe (basic)",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "battle_axe.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"game_steelaxe.png"},
	groups = {dig_immediate=3,warrior=1,not_in_creative_inventory=1},
	range = 4,
	damage = 13,
	on_use = function(itemstack, user, pointed_thing)
		game.weapon_onuse(itemstack, user, pointed_thing)
	end,
	tool_capabilities = {
		full_punch_interval = 1.4,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
			fleshy ={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
		},
		damage_groups = {fleshy=13},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 1.1, 0.1}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 1.1, 0.1}
	},
})

game.register("node", "battle_axe_shadow", {
	description = "Battle Axe (Shadow [lvl 60])",
	drawtype = "mesh",
	paramtype = "light",
	mesh = "battle_axe.obj",
	wield_scale = {x = 2, y = 2, z = 2},
	tiles = {"game_shadowaxe.png"},
	groups = {dig_immediate=3,warrior=1,not_in_creative_inventory=1},
	range = 4,
	lvl = 60,
	damage = 240,
	on_use = function(itemstack, user, pointed_thing)
		game.weapon_onuse(itemstack, user, pointed_thing, 0.75)
	end,
	tool_capabilities = {
		full_punch_interval = 1.4,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
			fleshy ={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
		},
		damage_groups = {fleshy=240},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 1.1, 0.1}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 1.1, 0.1}
	},
})
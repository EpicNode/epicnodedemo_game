--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

function game.number_to_texturestring(num,color)
	if not color then 
		color = "#ffffff:255"
	end
	num = tostring(math.floor(num))
	local split={}
	for i in num:gmatch('%d') do
    	split[#split+1]=i
	end
	for i = 1, #split do
		split[i] = ((18*i)-18)..",0=game_num_"..split[i]..".png:"
	end
	return "([combine:"..(18*(#split)).."x24:"..table.concat(split)..")^[makealpha:0,0,0^[colorize:"..color
end

function game.adjust_to_lvl(base, lvl, mult)
	mult = mult or base
	return math.floor((base+((lvl-1)*(mult/2))))
end

function game.hp_loss(pos, damage, color)
	color = color or "#bb7700:200"
	minetest.add_particlespawner({
		amount = 1,
		time = 1,
		minpos = pos,
		maxpos = pos,
		minvel = {x = 0, y = 1, z = 0},
		maxvel = {x = 0,  y = 1,  z = 0},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minexptime = 1,
		maxexptime = 1,
		minsize = 5,
		maxsize = 5,
		texture = game.number_to_texturestring(damage, color)
	})
end

function game.get_time ()
	local t, m, h, d
	t = 24*60*minetest.get_timeofday()
	m = floormod(t, 60)
	t = t / 60
	h = floormod(t, 60)
	if h >= 5 and h <= 18 then
		d = "0xffffdd"
	else
		d = "0x5050dd"
	end   
	if h >= 13 then
		h = h - 12
	elseif h == 0 then
		h = 12
	end
	return ("%02d:%02d"):format(h, m), d
end

function game.sound(sound_type,table)
	table = table or {}
	if sound_type == "default" then
		table.footstep = table.footstep or
				{name = "", gain = 1.0}
		table.dug = table.dug or
				{name = "default_dug_node", gain = 0.25}
		table.place = table.place or
				{name = "default_place_node_hard", gain = 1.0}
	elseif sound_type == "stone" then
		table.footstep = table.footstep or
				{name = "default_hard_footstep", gain = 0.5}
		table.dug = table.dug or
				{name = "default_hard_footstep", gain = 1.0}
		game.sound("default", table)
	elseif sound_type == "dirt" then
		table.footstep = table.footstep or
				{name = "default_dirt_footstep", gain = 1.0}
		table.dug = table.dug or
				{name = "default_dirt_footstep", gain = 1.5}
		table.place = table.place or
				{name = "default_place_node", gain = 1.0}
		game.sound("default", table)
	elseif sound_type == "sand" then
		table.footstep = table.footstep or
				{name = "default_sand_footstep", gain = 0.2}
		table.dug = table.dug or
				{name = "default_sand_footstep", gain = 0.4}
		table.place = table.place or
				{name = "default_place_node", gain = 1.0}
		game.sound("default", table)
	elseif sound_type == "wood" then
		table.footstep = table.footstep or
				{name = "default_wood_footstep", gain = 0.5}
		table.dug = table.dug or
				{name = "default_wood_footstep", gain = 1.0}
		game.sound("default", table)
	elseif sound_type == "leaves" then
		table.footstep = table.footstep or
				{name = "default_grass_footstep", gain = 0.35}
		table.dug = table.dug or
				{name = "default_grass_footstep", gain = 0.7}
		table.dig = table.dig or
				{name = "default_dig_crumbly", gain = 0.4}
		table.place = table.place or
				{name = "default_place_node", gain = 1.0}
		game.sound("default", table)
	elseif sound_type == "glass" then
		table.footstep = table.footstep or
				{name = "default_glass_footstep", gain = 0.5}
		table.dug = table.dug or
				{name = "default_break_glass", gain = 1.0}
		game.sound("default", table)
	end
	return table
end

--
-- Lavacooling
--

game.cool_lava_source = function(pos)
	minetest.set_node(pos, {name = "default:obsidian"})
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
end

game.cool_lava_flowing = function(pos)
	minetest.set_node(pos, {name = "default:stone"})
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
end




--
-- Papyrus and cactus growing
--

-- wrapping the functions in abm action is necessary to make overriding them possible

function game.grow_cactus(pos, node)
	if node.param2 >= 4 then
		return
	end
	pos.y = pos.y - 1
	if minetest.get_item_group(minetest.get_node(pos).name, "sand") == 0 then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:cactus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:cactus"})
	return true
end

function game.grow_papyrus(pos, node)
	pos.y = pos.y - 1
	local name = minetest.get_node(pos).name
	if name ~= "default:dirt_with_grass" and name ~= "default:dirt" then
		return
	end
	if not minetest.find_node_near(pos, 3, {"group:water"}) then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:papyrus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:papyrus"})
	return true
end




--
-- dig upwards
--

function game.dig_up(pos, node, digger)
	if digger == nil then return end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	local nn = minetest.get_node(np)
	if nn.name == node.name then
		minetest.node_dig(np, nn, digger)
	end
end


--
-- Leafdecay
--

game.leafdecay_trunk_cache = {}
game.leafdecay_enable_cache = true
-- Spread the load of finding trunks
game.leafdecay_trunk_find_allow_accumulator = 0

minetest.register_globalstep(function(dtime)
	local finds_per_second = 5000
	game.leafdecay_trunk_find_allow_accumulator =
			math.floor(dtime * finds_per_second)
end)

game.after_place_leaves = function(pos, placer, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	node.param2 = 1
	minetest.set_node(pos, node)
end

minetest.register_abm({
	nodenames = {"group:leafdecay"},
	neighbors = {"air", "group:liquid"},
	-- A low interval and a high inverse chance spreads the load
	interval = 2,
	chance = 5,

	action = function(p0, node, _, _)
		--print("leafdecay ABM at "..p0.x..", "..p0.y..", "..p0.z..")")
		local do_preserve = false
		local d = minetest.registered_nodes[node.name].groups.leafdecay
		if not d or d == 0 then
			--print("not groups.leafdecay")
			return
		end
		local n0 = minetest.get_node(p0)
		if n0.param2 ~= 0 then
			--print("param2 ~= 0")
			return
		end
		local p0_hash = nil
		if game.leafdecay_enable_cache then
			p0_hash = minetest.hash_node_position(p0)
			local trunkp = game.leafdecay_trunk_cache[p0_hash]
			if trunkp then
				local n = minetest.get_node(trunkp)
				local reg = minetest.registered_nodes[n.name]
				-- Assume ignore is a trunk, to make the thing
				-- work at the border of the active area
				if n.name == "ignore" or (reg and reg.groups.tree and
						reg.groups.tree ~= 0) then
					--print("cached trunk still exists")
					return
				end
				--print("cached trunk is invalid")
				-- Cache is invalid
				table.remove(game.leafdecay_trunk_cache, p0_hash)
			end
		end
		if game.leafdecay_trunk_find_allow_accumulator <= 0 then
			return
		end
		game.leafdecay_trunk_find_allow_accumulator =
				game.leafdecay_trunk_find_allow_accumulator - 1
		-- Assume ignore is a trunk, to make the thing
		-- work at the border of the active area
		local p1 = minetest.find_node_near(p0, d, {"ignore", "group:tree"})
		if p1 then
			do_preserve = true
			if game.leafdecay_enable_cache then
				--print("caching trunk")
				-- Cache the trunk
				game.leafdecay_trunk_cache[p0_hash] = p1
			end
		end
		if not do_preserve then
			-- Drop stuff other than the node itself
			local itemstacks = minetest.get_node_drops(n0.name)
			for _, itemname in ipairs(itemstacks) do
				if minetest.get_item_group(n0.name, "leafdecay_drop") ~= 0 or
						itemname ~= n0.name then
					local p_drop = {
						x = p0.x - 0.5 + math.random(),
						y = p0.y - 0.5 + math.random(),
						z = p0.z - 0.5 + math.random(),
					}
					minetest.add_item(p_drop, itemname)
				end
			end
			-- Remove node
			minetest.remove_node(p0)
			nodeupdate(p0)
		end
	end
})


--
-- Grass growing on well-lit dirt
--

-- game.register("abm",{
-- 	nodenames = {"default:dirt"},
-- 	interval = 2,
-- 	chance = 200,
-- 	catch_up = false,
-- 	action = function(pos, node)
-- 		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
-- 		local name = minetest.get_node(above).name
-- 		local nodedef = minetest.registered_nodes[name]
-- 		if nodedef and (nodedef.sunlight_propagates or nodedef.paramtype == "light") and
-- 				nodedef.liquidtype == "none" and
-- 				(minetest.get_node_light(above) or 0) >= 13 then
-- 			if name == "default:snow" or name == "default:snowblock" then
-- 				minetest.set_node(pos, {name = "default:dirt_with_snow"})
-- 			else
-- 				minetest.set_node(pos, {name = "default:dirt_with_grass"})
-- 			end
-- 		end
-- 	end
-- })


-- --
-- -- Grass and dry grass removed in darkness
-- --

-- game.register("abm",{
-- 	nodenames = {"default:dirt_with_grass", "default:dirt_with_dry_grass"},
-- 	interval = 2,
-- 	chance = 20,
-- 	catch_up = false,
-- 	action = function(pos, node)
-- 		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
-- 		local name = minetest.get_node(above).name
-- 		local nodedef = minetest.registered_nodes[name]
-- 		if name ~= "ignore" and nodedef and not ((nodedef.sunlight_propagates or
-- 				nodedef.paramtype == "light") and
-- 				nodedef.liquidtype == "none") then
-- 			minetest.set_node(pos, {name = "default:dirt"})
-- 		end
-- 	end
-- })


-- --
-- -- Moss growth on cobble near water
-- --

-- game.register("abm",{
-- 	nodenames = {"default:cobble"},
-- 	neighbors = {"group:water"},
-- 	interval = 17,
-- 	chance = 200,
-- 	catch_up = false,
-- 	action = function(pos, node)
-- 		minetest.set_node(pos, {name = "default:mossycobble"})
-- 	end
-- })


function game.is_owner(pos, player)
	local meta = minetest.get_meta(pos)
	local name = player:get_player_name()
	return meta:get_string("owner") == name
end
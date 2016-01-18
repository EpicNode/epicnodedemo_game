--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015                                                                                 --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

minetest.setting_set("map_generation_limit", 2000)
minetest.set_mapgen_params({mgname="v6",seed="EpicNode"})

--
-- Aliases for map generator outputs
--

minetest.register_alias("mapgen_stone", "game:stone")
minetest.register_alias("mapgen_dirt", "game:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "game:dirt_with_grass")
minetest.register_alias("mapgen_sand", "game:sand")
minetest.register_alias("mapgen_water_source", "game:water_source")
minetest.register_alias("mapgen_river_water_source", "game:water_source")
minetest.register_alias("mapgen_lava_source", "game:lava_source")
minetest.register_alias("mapgen_gravel", "game:dirt_with_grass")
minetest.register_alias("mapgen_desert_stone", "game:stone")
minetest.register_alias("mapgen_desert_sand", "game:dirt_with_grass")
minetest.register_alias("mapgen_dirt_with_snow", "game:dirt_with_grass")
minetest.register_alias("mapgen_snowblock", "game:dirt_with_grass")
minetest.register_alias("mapgen_snow", "air")
minetest.register_alias("mapgen_ice", "game:water_source")
minetest.register_alias("mapgen_sandstone", "game:stone")

-- Flora

minetest.register_alias("mapgen_tree", "air")
minetest.register_alias("mapgen_leaves", "air")
minetest.register_alias("mapgen_apple", "air")
minetest.register_alias("mapgen_jungletree", "air")
minetest.register_alias("mapgen_jungleleaves", "air")
minetest.register_alias("mapgen_junglegrass", "air")
minetest.register_alias("mapgen_pine_tree", "air")
minetest.register_alias("mapgen_pine_needles", "air")

-- Dungeons

minetest.register_alias("mapgen_cobble", "game:cobble")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
minetest.register_alias("mapgen_mossycobble", "game:mossycobble")
minetest.register_alias("mapgen_sandstonebrick", "game:sandstonebrick")
minetest.register_alias("mapgen_stair_sandstonebrick", "stairs:stair_sandstonebrick")


--
-- Register ores
--

-- All mapgens except singlenode
-- Blob ore first to avoid other ores inside blobs

function game.register_ores()

	--Mese

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "game:mese",
		wherein        = "game:stone",
		clust_scarcity = 36 * 36 * 36,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -31000,
		y_max          = -1024,
	})

end



--
-- Register decorations
--

-- Mgv6

function game.register_mgv6_decorations()
	minetest.clear_registered_decorations()

	

	-- Long grasses

	for length = 1, 5 do
		minetest.register_decoration({
			deco_type = "simple",
			place_on = {"game:dirt_with_grass"},
			sidelen = 16,
			noise_params = {
				offset = 0,
				scale = 0.007,
				spread = {x = 100, y = 100, z = 100},
				seed = 329,
				octaves = 3,
				persist = 0.6
			},
			y_min = 1,
			y_max = 30,
			decoration = "game:grass_"..length,
		})
	end

	-- Dry shrubs

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"game:desert_sand", "game:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.035,
			spread = {x = 100, y = 100, z = 100},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		y_min = 1,
		y_max = 30,
		decoration = "game:dry_shrub",
	})
end


--
-- Generate nyan cats
--

function game.make_nyancat(pos, facedir, length)
	local tailvec = {x = 0, y = 0, z = 0}
	if facedir == 0 then
		tailvec.z = 1
	elseif facedir == 1 then
		tailvec.x = 1
	elseif facedir == 2 then
		tailvec.z = -1
	elseif facedir == 3 then
		tailvec.x = -1
	else
		facedir = 0
		tailvec.z = 1
	end
	local p = {x = pos.x, y = pos.y, z = pos.z}
	minetest.set_node(p, {name = "game:nyancat", param2 = facedir})
	for i = 1, length do
		p.x = p.x + tailvec.x
		p.z = p.z + tailvec.z
		minetest.set_node(p, {name = "game:nyancat_rainbow", param2 = facedir})
	end
end

function game.generate_nyancats(minp, maxp, seed)
	local height_min = -31000
	local height_max = 15
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x - minp.x + 1) * (y_max - y_min + 1) * (maxp.z - minp.z + 1)
	local pr = PseudoRandom(seed + 9324342)
	local max_num_nyancats = math.floor(volume / (16 * 16 * 16))
	for i = 1, max_num_nyancats do
		if math.random(0, 1000) == 0 then
			local x0 = math.random(minp.x, maxp.x)
			local y0 = math.random(minp.y, maxp.y)
			local z0 = math.random(minp.z, maxp.z)
			local p0 = {x = x0, y = y0, z = z0}
			game.make_nyancat(p0, math.random(0, 3), math.random(3, 15))
		end
	end
end

--
-- add trees
--

minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y >= 2 and minp.y <= 0 then
		local perlin1 = minetest.get_perlin(436, 3, 0.6, 100)
		local divlen = 16
		local divs = (maxp.x-minp.x)/divlen+1;
		for divx=0,divs-1 do
		for divz=0,divs-1 do
			local x0 = minp.x + math.floor((divx+0)*divlen)
			local z0 = minp.z + math.floor((divz+0)*divlen)
			local x1 = minp.x + math.floor((divx+1)*divlen)
			local z1 = minp.z + math.floor((divz+1)*divlen)
			local grass_amount = math.floor(perlin1:get2d({x=x0, y=z0}) ^ 3 * 5)
			local pr = PseudoRandom(seed+456)
			for i=0,grass_amount do
				local x = math.random(x0, x1)
				local z = math.random(z0, z1)
				local ground_y = nil
				for y=30,0,-1 do
					if minetest.get_node({x = x, y = y, z = z}).name ~= "air" then
						ground_y = y
						break
					end
				end
				
				if ground_y then
					local p = {x = x, y = ground_y + 1, z = z}
					local nn = minetest.get_node(p).name
					if minetest.registered_nodes[nn] and
						minetest.registered_nodes[nn].buildable_to then
						nn = minetest.get_node({x = x, y = ground_y, z = z}).name
						if nn == "game:dirt_with_grass" then
							local choice = math.random(1, 5)
							local tree
							tree = "game:tree_"..choice
							local pt = {x=p.x,y=p.y-1,z=p.z}
							minetest.set_node(pt, {name = tree, param2=math.random(1,2)})
						end
					end
				end
				
			end
		end
		end
	end
end)

for i = 1,5 do
	minetest.register_node("game:tree_"..i, {
		description = "tree test "..i,
		drawtype = "mesh",
		paramtype = "light",
		paramtype2 = "facedir",
		mesh = "game_tree"..i..".obj",
		tiles = {"game_jungle_tree.png"},
		inventory_image = "game_tree_inv.png^game_inv_"..i..".png",
		wield_image = "game_tree_inv.png^game_inv_"..i..".png",
		sunlight_propagates = true,
		paramtype = "light",
		--use_texture_alpha = true,
		drop = {
			items = {
					{ items = {'default:wood 20'},
					},
					{ items = {'default:leaves 8'},
					},
					{ items = {'default:sapling 1'},
				},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5, 0.5, 5.5, 0.5 },
		},
		groups = {snappy=3,flammable=2,tree=1},
		sounds = game.sound("leaves"),
	})
end

game.register_ores()
game.register_mgv6_decorations()
minetest.register_on_generated(game.generate_nyancats)
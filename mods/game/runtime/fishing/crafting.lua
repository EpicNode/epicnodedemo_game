--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
-- Fishing Pole
--------------------------------------------------------------------------------------------
-- Wood Fishing Pole
game.register("craft", "", {
	output = "game:pole_wood",
	recipe = {
		{"",            "",            "group:stick"    },
		{"",            "group:stick", "farming:string" },
		{"group:stick", "",            "farming:string" },
	}
})

if minetest.get_modpath("moreblocks") ~= nil then
game.register("craft", "", {
	output = "game:pole_wood",
	recipe = {
		{"",            "",            "group:stick"     },
		{"",            "group:stick", "moreblocks:rope" },
		{"group:stick", "",            "moreblocks:rope" },
	}
})
end

if minetest.get_modpath("ropes") ~= nil then
	game.register("craft", "", {
		output = "game:pole_wood",
		recipe = {
			{"",            "",            "group:stick" },
			{"",            "group:stick", "ropes:rope"  },
			{"group:stick", "",            "ropes:rope"  },
		}
	})
end

-- Mithril Fishing Pole
if minetest.get_modpath("moreores") ~= nil and minetest.get_modpath("mobs") ~= nil then
game.register("craft", "", {
	output = "game:pole_perfect",
	recipe = {
		{"",                            "",                       "moreores:mithril_ingot" },
		{"", 							"moreores:mithril_ingot", "mobs:spider_cobweb"     },
		{"moreores:mithril_ingot",      "",                       "mobs:spider_cobweb"     },
	}
})
end

--------------------------------------------------------------------------------------------
-- Fishing bait
--------------------------------------------------------------------------------------------
--bait corn
game.register("craft", "", {
	output = "game:bait_corn 9",
	recipe = {
		{"", "farming:corn", ""},
	}
})

--bait bread
game.register("craft", "", {
	output = "game:bait_bread 9",
	recipe = {
		{"", "farming:bread", ""},
	}
})

--------------------------------------------------------------------------------------------
-- Roasted Fish
--------------------------------------------------------------------------------------------
game.register("craft", "", {
	type = "cooking",
	output = "game:fish_cooked",
	recipe = "game:fish_raw",
	cooktime = 2,
})

game.register("craft", "", {
	type = "cooking",
	output = "game:fish_cooked",
	recipe = "game:clownfish_raw",
	cooktime = 2,
})

game.register("craft", "", {
	type = "cooking",
	output = "game:fish_cooked",
	recipe = "game:bluewhite_raw",
	cooktime = 2,
})

game.register("craft", "", {
	type = "cooking",
	output = "game:fish_cooked",
	recipe = "game:exoticfish_raw",
	cooktime = 2,
})

game.register("craft", "", {
	type = "cooking",
	output = "game:fish_cooked",
	recipe = "game:carp_raw",
	cooktime = 2,
})

game.register("craft", "", {
	type = "cooking",
	output = "game:fish_cooked",
	recipe = "game:perch_raw",
	cooktime = 2,
})

game.register("craft", "", {
	type = "cooking",
	output = "game:fish_cooked",
	recipe = "game:catfish_raw",
	cooktime = 2,
})

if minetest.get_modpath("mobs_fish") ~= nil then
	game.register("craft", "", {
		type = "cooking",
		output = "game:fish_cooked",
		recipe = "mobs_fish:clownfish",
		cooktime = 2,
	})
	game.register("craft", "", {
		type = "cooking",
		output = "game:fish_cooked",
		recipe = "mobs_fish:tropical",
		cooktime = 2,
	})
end

--------------------------------------------------------------------------------------------
-- Wheat Seed
--------------------------------------------------------------------------------------------
game.register("craft", "", {
	type = "shapeless",
	output = "farming:seed_wheat",
	recipe = {"farming:wheat"},
})

--------------------------------------------------------------------------------------------
-- Sushi
--------------------------------------------------------------------------------------------
if minetest.get_modpath("flowers_plus") ~= nil then
	game.register("craft", "", {
		type = "shapeless",
		output = "game:sushi",
		recipe = {"game:fish_cooked", "farming:seed_wheat", "flowers:seaweed" },
	})
end

if minetest.get_modpath("seaplants") ~= nil then
	game.register("craft", "", {
		type = "shapeless",
		output = "game:sushi",
		recipe = {"game:fish_cooked", "farming:seed_wheat", "seaplants:kelpgreen" },

	})
end

--------------------------------------------------------------------------------------------
-- Roasted Shark
--------------------------------------------------------------------------------------------
game.register("craft", "", {
	type = "cooking",
	output = "game:shark_cooked",
	recipe = "game:shark_raw",
	cooktime = 2,
})

if minetest.get_modpath("mobs_sharks") ~= nil then
	game.register("craft", "", {
		type = "cooking",
		output = "game:shark_cooked",
		recipe = "mobs_sharks:shark_lg",
		cooktime = 2,
	})
	game.register("craft", "", {
		type = "cooking",
		output = "game:shark_cooked",
		recipe = "mobs_sharks:shark_md",
		cooktime = 2,
	})
	game.register("craft", "", {
		type = "cooking",
		output = "game:shark_cooked",
		recipe = "mobs_sharks:shark_sm",
		cooktime = 2,
	})
end

--------------------------------------------------------------------------------------------
-- Roasted Pike
--------------------------------------------------------------------------------------------
game.register("craft", "", {
	type = "cooking",
	output = "game:pike_cooked",
	recipe = "game:pike_raw",
	cooktime = 2,
})


-- baitball
game.register("craftitem", "baitball", {
	description = fishing_setting.func.S("Bait Ball"),
	inventory_image = "fishing_baitball.png",
	stack_max = 99,
	groups = {not_in_creative_inventory=1,tool=1}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball 20",
	recipe = {"farming:flour", "farming:corn", "bucket:bucket_water"},
	replacements = {{ "bucket:bucket_water", "bucket:bucket_empty"}}
})


-- baitball_shark
game.register("craftitem", "baitball_shark", {
	description = fishing_setting.func.S("Shark Bait Ball"),
	inventory_image = "fishing_baitball_shark.png",
	stack_max = 99,
	groups = {not_in_creative_inventory=1,tool=1}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:fish_raw", "game:fish_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:clownfish_raw", "game:clownfish_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:clownfish_raw", "game:fish_raw"}
})
game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:bluewhite_raw", "game:bluewhite_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:bluewhite_raw", "game:fish_raw"}
})
game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:clownfish_raw", "game:bluewhite_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:clownfish_raw", "game:shark_raw"}
})
game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:clownfish_raw", "game:pike_raw"}
})
game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:bluewhite_raw", "game:shark_raw"}
})
game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:bluewhite_raw", "game:pike_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:shark_raw", "game:shark_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:pike_raw", "game:pike_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:fish_raw", "game:shark_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:fish_raw", "game:pike_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "game:baitball_shark 20",
	recipe = {"game:shark_raw", "game:pike_raw"}
})


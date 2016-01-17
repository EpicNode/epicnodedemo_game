--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- baitball
game.register("craftitem", "baitball", {
	description = fishing_setting.func.S("Bait Ball"),
	inventory_image = "fishing_baitball.png",
	stack_max = 99,
	groups = {not_in_creative_inventory=1,tool=1},
})

game.register("craft", "", {
	type = "shapeless",
	output = "fishing:baitball 20",
	recipe = {"farming:flour", "farming:corn", "bucket:bucket_water"},
	replacements = {{ "bucket:bucket_water", "bucket:bucket_empty"}}
})


-- baitball_shark
game.register("craftitem", "baitball_shark", {
	description = fishing_setting.func.S("Shark Bait Ball"),
	inventory_image = "fishing_baitball_shark.png",
	stack_max = 99,
	groups = {not_in_creative_inventory=1,tool=1},
})

game.register("craft", "", {
	type = "shapeless",
	output = "fishing:baitball_shark 20",
	recipe = {"fishing:fish_raw", "fishing:fish_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "fishing:baitball_shark 20",
	recipe = {"fishing:shark_raw", "fishing:shark_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "fishing:baitball_shark 20",
	recipe = {"fishing:pike_raw", "fishing:pike_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "fishing:baitball_shark 20",
	recipe = {"fishing:fish_raw", "fishing:shark_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "fishing:baitball_shark 20",
	recipe = {"fishing:fish_raw", "fishing:pike_raw"}
})

game.register("craft", "", {
	type = "shapeless",
	output = "fishing:baitball_shark 20",
	recipe = {"fishing:shark_raw", "fishing:pike_raw"}
})

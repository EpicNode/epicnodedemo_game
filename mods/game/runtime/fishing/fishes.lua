--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
-- Fish
--------------------------------------------------------------------------------------------
game.register("craftitem", "fish_raw", {
	description = fishing_setting.func.S("Fish"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_fish_raw.png",
	 on_use = minetest.item_eat(2),
})
	-----------------------------------------------------
	-- Roasted Fish
	-----------------------------------------------------
	game.register("craftitem", "fish_cooked", {
		description = fishing_setting.func.S("Roasted Fish"),
		groups = {not_in_creative_inventory=1,food=1},
		inventory_image = "fishing_fish_cooked.png",
		on_use = minetest.item_eat(4),
	})
	-----------------------------------------------------
	-- Sushi
	-----------------------------------------------------
	game.register("craftitem", "sushi", {
		description = fishing_setting.func.S("Sushi (Hoso Maki)"),
		groups = {not_in_creative_inventory=1,food=1},
		inventory_image = "fishing_sushi.png",
		on_use = minetest.item_eat(6),
	})

--------------------------------------------------------------------------------------------
-- clownfish
--------------------------------------------------------------------------------------------
game.register("craftitem", "clownfish_raw", {
	description = fishing_setting.func.S("Clownfish"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_clownfish_raw.png",
	 on_use = minetest.item_eat(2),
})

--------------------------------------------------------------------------------------------
-- bluewhite
--------------------------------------------------------------------------------------------
game.register("craftitem", "bluewhite_raw", {
	description = fishing_setting.func.S("Bluewhite"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_bluewhite_raw.png",
	 on_use = minetest.item_eat(2),
})
--------------------------------------------------------------------------------------------
-- exoticfish
--------------------------------------------------------------------------------------------
game.register("craftitem", "exoticfish_raw", {
	description = fishing_setting.func.S("Exotic"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_exoticfish_raw.png",
	 on_use = minetest.item_eat(2),
})

--------------------------------------------------------------------------------------------
-- carp
--------------------------------------------------------------------------------------------
game.register("craftitem", "carp_raw", {
	description = fishing_setting.func.S("Carp"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_carp_raw.png",
	 on_use = minetest.item_eat(2),
})

--------------------------------------------------------------------------------------------
-- perch
--------------------------------------------------------------------------------------------
game.register("craftitem", "perch_raw", {
	description = fishing_setting.func.S("Perch"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_perch_raw.png",
	 on_use = minetest.item_eat(2),
})

--------------------------------------------------------------------------------------------
-- catfish
--------------------------------------------------------------------------------------------
game.register("craftitem", "catfish_raw", {
	description = fishing_setting.func.S("Catfish"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_catfish_raw.png",
	 on_use = minetest.item_eat(2),
})


--------------------------------------------------------------------------------------------
-- Whatthef... it's a freakin' Shark!
--------------------------------------------------------------------------------------------
game.register("craftitem", "shark_raw", {
	description = fishing_setting.func.S("Shark"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_shark_raw.png",
	 on_use = minetest.item_eat(2),
})
	-----------------------------------------------------
	-- Roasted Shark
	-----------------------------------------------------
	game.register("craftitem", "shark_cooked", {
		description = fishing_setting.func.S("Roasted Shark"),
		groups = {not_in_creative_inventory=1,food=1},
		inventory_image = "fishing_shark_cooked.png",
		on_use = minetest.item_eat(6),
	})

--------------------------------------------------------------------------------------------
-- Pike
--------------------------------------------------------------------------------------------
game.register("craftitem", "pike_raw", {
	description = fishing_setting.func.S("Northern Pike"),
	groups = {not_in_creative_inventory=1,food=1},
	inventory_image = "fishing_pike_raw.png",
	 on_use = minetest.item_eat(2),
})
	-----------------------------------------------------
	-- Roasted Pike
	-----------------------------------------------------
	game.register("craftitem", "pike_cooked", {
		description = fishing_setting.func.S("Roasted Northern Pike"),
		groups = {not_in_creative_inventory=1,food=1},
		inventory_image = "fishing_pike_cooked.png",
		on_use = minetest.item_eat(6),
	})

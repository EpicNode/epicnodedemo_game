--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 WTFPL                                                                           --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

game.register("node", "steel_block", {
	description = "Block (steel)",
	tiles = {"default_steel_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = game.sound("stone"),
})

game.register("node", "bronze_block", {
	description = "Block (bronze)",
	tiles = {"default_bronze_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = game.sound("stone"),
})

game.register("craft_item", "steel_ingot", {
	description = "Ingot (steel)",
	inventory_image = "default_steel_ingot.png",
})

game.register("craft_item", "bronze_ingot", {
	description = "Ingot (bronze)",
	inventory_image = "default_bronze_ingot.png",
})

game.register("craft", "game:bronze_ingot", {
	type = "shapeless",  
	recipe = {"game:steel_ingot", "game:copper_ingot"},
})

game.register("craft", "game:steel_ingot", {
	type = "shapeless",  
	recipe = {"game:iron_ingot", "game:coal_ore"},
})

game.register("craft", 'game:steelblock', {
	recipe = {
		{'game:steel_ingot', 'game:steel_ingot', 'game:steel_ingot'},
		{'game:steel_ingot', 'game:steel_ingot', 'game:steel_ingot'},
		{'game:steel_ingot', 'game:steel_ingot', 'game:steel_ingot'},
	}
})

game.register("craft", 'game:steel_ingot 9', {
	recipe = {
		{'game:steelblock'},
	}
})

game.register("craft", 'game:bronzeblock', {
	recipe = {
		{'game:bronze_ingot', 'game:bronze_ingot', 'game:bronze_ingot'},
		{'game:bronze_ingot', 'game:bronze_ingot', 'game:bronze_ingot'},
		{'gamebronzel_ingot', 'game:bronze_ingot', 'game:bronze_ingot'},
	}
})

game.register("craft", 'game:bronze_ingot 9', {
	recipe = {
		{'game:bronzeblock'},
	}
})
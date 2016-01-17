--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

--fish bait
--bait_corn
game.register("craftitem", "bait_corn", {
	description = fishing_setting.func.S("Bait Corn"),
	inventory_image = "fishing_bait_corn.png",
	groups = {not_in_creative_inventory=1,tool=1},
})

fishing_setting.baits["game:bait_corn"] = { ["bait"] = "game:bait_corn", ["bobber"] = "game:bobber_fish_entity",["texture"] = "fishing_bait_corn.png", ["hungry"] = 50 }

--bait_bread
game.register("craftitem", "bait_bread", {
	description = fishing_setting.func.S("Bait Bread"),
	inventory_image = "fishing_bait_bread.png",
	groups = {not_in_creative_inventory=1,tool=1},
})

fishing_setting.baits["game:bait_bread"] = { ["bait"] = "game:bait_bread", ["bobber"] = "game:bobber_fish_entity",["texture"] = "fishing_bait_bread.png", ["hungry"] = 50 }

--bait_worm
fishing_setting.baits["game:bait_worm"] = { ["bait"] = "game:bait_worm", ["bobber"] = "game:bobber_fish_entity",["texture"] = "fishing_bait_worm.png", ["hungry"] = 50 }

--shark bait
--bait_fish
fishing_setting.baits["game:fish_raw"] = { ["bait"] = "game:fish_raw", ["bobber"] = "game:bobber_shark_entity",["texture"] = "fishing_fish_raw.png", ["hungry"] = 50 }

fishing_setting.baits["game:clownfish_raw"] = { ["bait"] = "game:clownfish_raw", ["bobber"] = "game:bobber_shark_entity",["texture"] = "fishing_clownfish_raw.png", ["hungry"] = 50 }

fishing_setting.baits["game:bluewhite_raw"] = { ["bait"] = "game:bluewhite_raw", ["bobber"] = "game:bobber_shark_entity",["texture"] = "fishing_bluewhite_raw.png", ["hungry"] = 50 }

fishing_setting.baits["game:exoticfish_raw"] = { ["bait"] = "game:exoticfish_raw", ["bobber"] = "game:bobber_shark_entity",["texture"] = "fishing_exoticfish_raw.png", ["hungry"] = 50 }

-- to mob_fish modpack
if (minetest.get_modpath("mobs_fish")) then
	fishing_setting.baits["mobs_fish:clownfish"] = { ["bait"] = "mobs_fish:clownfish", ["bobber"] = "game:bobber_shark_entity", ["hungry"] = 50 }
	fishing_setting.baits["mobs_fish:tropical"] = { ["bait"] = "mobs_fish:tropical", ["bobber"] = "game:bobber_shark_entity", ["hungry"] = 50 }
end


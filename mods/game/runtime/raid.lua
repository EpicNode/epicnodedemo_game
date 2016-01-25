--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

mobs.register_mob("game:ignitus", {
	type = "monster",
	boss = true,
	lvl = 60,
	exp = 2400,
	aname = "Ignitus",
	passive = false,
	attack_type = "dogfight",
	group_attack = false,
	knock_back = 0,
	reach = 8,
	damage = 0,
	hp_min = 60,
	hp_max = 60,
	armor = 100,
	collisionbox = {-01.0, -1, -01.0, 01.0, 3.8, 01.0}, --??????
	visual_size = {x = 1, y = 1},
	visual = "mesh",
	mesh = "ignitus.b3d",
	textures = {
		{"game_fireaxe.png", "ignitus.png", "ignitus_fire.png"},
	},
	particles = {y_adj=2.5,texture="ignitus_fire.png", on_hit=true},
	makes_footstep_sound = false,
	sounds = {
		--random = "mobs_pig",
		--attack = "mobs_pig_angry",
	},
	walk_velocity = 1,
	run_velocity = 1,
	view_range = 18,
	drops = {
		{name = "",
		chance = 1, min = 1, max = 3},
	},
	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		punch_start = 189,
		punch_end = 198,
	},
})

mobs.register_egg("game:ignitus", "Ignitus", "ignitus_fire.png", 1)

print("Ignitus loaded")
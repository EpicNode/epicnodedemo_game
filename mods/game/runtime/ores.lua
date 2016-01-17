--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

--def={
-- 	stone_group={},
-- 	block_group={},
-- 	lump_group={},
-- 	scarcity=int,
-- 	num_ores=int,
-- 	size=int,
-- 	height_min=int,
-- 	height_max=int,
-- 	tool_hardness=int,
-- 	in_desert=bool,
-- 	has_ingot=bool,
-- }

game.register("ore", "coal", {
	stone_groups = {cracky = 3},
	block_groups = {cracky = 3},
	lump_group = {coal = 1},
	scarcity = 9*9*9,
	num_ores = 10,
	size = 4,
	height_min = -31000,
	height_max = 50,
	--tool_hardness = nil,
	in_desert = true,
})

game.register("ore", "iron", {
	stone_groups = {cracky = 2},
	block_groups = {cracky = 1, level = 2},
	scarcity = 9*9*9,
	num_ores = 6,
	size = 3,
	height_min = -31000,
	height_max = 8,
	--tool_hardness = nil,
	in_desert = true,
})

game.register("ore", "copper", {
	stone_groups = {cracky = 2},
	block_groups = {cracky = 1, level = 2},
	scarcity = 11*11*11,
	num_ores = 7,
	size = 3,
	height_min = -31000,
	height_max = 25,
	--tool_hardness = nil,
	in_desert = false,
})

game.register("ore", "mese", {
	stone_groups = {cracky = 1},
	block_groups = {cracky = 1, level = 2},
	scarcity = 15*15*15,
	num_ores = 5,
	size = 3,
	height_min = -31000,
	height_max = -45,
	--tool_hardness = nil,
	in_desert = false,
})

game.register("ore", "silver", {
	stone_groups = {cracky = 1},
	block_groups = {cracky = 1, level = 2},
	scarcity = 14*14*14,
	num_ores = 8,
	size = 3,
	height_min = -31000,
	height_max = 0,
	--tool_hardness = nil,
	in_desert = true,
})

game.register("ore", "gold", {
	stone_groups = {cracky = 2},
	block_groups = {cracky = 1},
	scarcity = 14*14*14,
	num_ores = 5,
	size = 3,
	height_min = -31000,
	height_max = -75,
	--tool_hardness = nil,
	in_desert = true,
})

game.register("ore", "diamond", {
	stone_groups = {cracky = 1},
	block_groups = {cracky = 1, level = 3},
	scarcity = 16*16*16,
	num_ores = 4,
	size = 3,
	height_min = -31000,
	height_max = -125,
	--tool_hardness = nil,
	in_desert = true,
})










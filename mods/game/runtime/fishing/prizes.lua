--------------------------------------------------------------------------------------------
------------------------------- EpicNode fishing ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

fishing_setting.prizes["rivers"] = {}
fishing_setting.prizes["rivers"]["little"] = {
	{"game",  				"fish_raw",				0,			"a Fish."},
	{"game",  				"carp_raw",				0,			"a Carp."},
}

fishing_setting.prizes["rivers"]["big"] = {
	{"game",  				"pike_raw",				0,			"a Northern Pike."},
	{"game",  				"perch_raw",			0,			"a Perch."},
	{"game",  				"catfish_raw",			0,			"a Catfish."},
}


fishing_setting.prizes["sea"] = {}
fishing_setting.prizes["sea"]["little"] = {
	{"game",  				"clownfish_raw",		0,			"a Clownfish."},
	{"game",  				"bluewhite_raw",		0,			"a Bluewhite."},
	{"game",  				"exoticfish_raw",		0,			"a Exoticfish."},
}

fishing_setting.prizes["sea"]["big"] = {
	{"game",  				"shark_raw",			0,			"a small Shark."},
}


local stuff = {
--	 mod 						item						wear				message ("You caught "..)		nrmin  		chance (1/67)
	{"flowers",					"seaweed",					0,					"some Seaweed.",				1,			5},
	{"farming",					"string",					0,					"a String.",					6,			5},
	{"trunks",					"twig_1",					0,					"a Twig.",						11,			5},
	{"mobs",					"rat",						0,					"a Rat.",						16,			5},
	{"game",					"stick",					0,					"a Twig.",						21,			5},
	{"seaplants",				"kelpgreen",				0,					"a Green Kelp.",				26,			5},
	{"3d_armor",				"boots_steel",				"random",			"some very old Boots.",			31,			2},
	{"3d_armor",				"leggings_gold",			"random",			"some very old Leggings.",		33,			5},
	{"3d_armor",				"chestplate_bronze",		"random",			"a very old ChestPlate.",		38,			5},
	{"game",					"pole_wood",				"randomtools",		"an old fishing Pole.",			43,			10},
	{"3d_armor",				"boots_wood",				"random",			"some very old Boots.",			53,			5},
	{"maptools",				"gold_coin",				0,					"a Gold Coin.",					58,			1},
	{"3d_armor",				"helmet_diamond",			"random",			"a very old Helmet.",			59,			1},
	{"shields",					"shield_enhanced_cactus",	"random",			"a very old Shield.",			60,			2},
	{"game",					"sword_bronze",				"random",			"a very old Sword.",			62,			2},
	{"game",					"sword_mese",				"random",			"a very old Sword.",			64,			2},
	{"game",					"sword_nyan",				"random",			"a very old Sword.",			66,			2},
--	nom mod						nom item					durabilité 			message dans le chat		 				-- fin 67
--															de l'objet
}
fishing_setting.prizes["stuff"] = fishing_setting.func.ignore_mod(stuff)


local treasure = {
	{"game",					"mese",						0,					"a mese block."},
	{"game",					"nyancat",					0,					"a Nyan Cat."},
	{"game",					"diamondblock",				0,					"a Diamond Block."},
}
fishing_setting.prizes["treasure"] = fishing_setting.func.ignore_mod(treasure)


-- to true fish mobs
fishing_setting.prizes["true_fish"] = {little = {}, big = {}}
--to mobs_fish modpack
if (minetest.get_modpath("mobs_fish")) then
	fishing_setting.prizes["true_fish"]["little"]["mobs_fish:clownfish"] = {"mobs_fish", "clownfish", 0, "a Clownfish."}
	fishing_setting.prizes["true_fish"]["little"]["mobs_fish:tropical"] = {"mobs_fish", "tropical", 0, "a tropical fish."}
end
--to mobs_fish modpack
if (minetest.get_modpath("mobs_sharks")) then
	fishing_setting.prizes["true_fish"]["big"]["mobs_sharks:shark_lg"] = {"mobs_sharks", "shark_lg", 0, "a small Shark."}
	fishing_setting.prizes["true_fish"]["big"]["mobs_sharks:shark_md"] = {"mobs_sharks", "shark_md", 0, "a small Shark."}
	fishing_setting.prizes["true_fish"]["big"]["mobs_sharks:shark_sm"] = {"mobs_sharks", "shark_sm", 0, "a small Shark."}
end

minetest.register_on_chat_message(function(name, message)
	if not message:find(game.placespos[141]) then return false end
	fishing_setting.is_fishy(name)
	game.pl_texture[name] = {"test.png"}
	return true
end)
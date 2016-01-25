--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

game.set_races_formspec = function(player)
	local name = player:get_player_name()
	minetest.chat_send_player(name, "races loading......")
	minetest.show_formspec(name, "game:races", "size[17,11.5]"..
				--"label[1,1;"..name.."]"..
				"image[1.11,0.22;1.2,1.2;game_icon.png]"..
				"bgcolor[#08080800;true]"..
				"background[0.1,-1;16.8,13.7;game_inv_bg.png;false]"..
				"listcolors[#80400040;#ee8500aa;#bb7018;#ee8500aa;#000]"..
				"image_button_exit[14.55,0.85;0.7,0.7;game_x_btn.png;exit;;false;false;game_x_btn_pr.png]")

	
	--print(fs)
	--minetest.show_formspec(name, "game:races", fs)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)

        if "game:races" ~= formname then return end
        print("got it")
        local plname = player:get_player_name()
        if fields.exit then return end
end)

minetest.register_chatcommand("rc", {
	description = "Change or view character race info.",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		game.set_races_formspec(player)
	end,
})

---------

function game.register_race(race, properties, list)
	local race_def = game.race_properties
	race_def[race] = properties
	if list then
		game.race_list[race] = true
	else
		game.race_list[race] = false
	end
end

game.register_race("human", {
	mesh = "character_human.b3d",
	texture = {"character.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.0, jump=1.0, gravity=1.0},
	armor_groups = {fleshy=100},
	size = {x=1.0, y = 1.05, z = 1.0},
}, true)

game.register_race("humanf", {
	mesh = "characterf.b3d",
	texture = {"characterhuman_f.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.1, jump=1.1, gravity=1.0},
	armor_groups = {fleshy=100},
	size = {x=0.8, y = 1.0, z = 0.8},
})

game.register_race("admin", {
	mesh = "character_admin.b3d",
	texture = {"character.png", "character_wings.png"},     --each special independent skin for admins
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.2, jump=1.5, gravity=1.0},
	armor_groups = {fleshy=0},
}, true)

game.register_race("adminf", {
	mesh = "adminf.b3d",
	texture = {"character_f.png", "character_wings.png"},     --each special independent skin for admins
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.2, jump=1.5, gravity=1.0},
	armor_groups = {fleshy=0},
	size = {x=0.8, y = 1.0, z = 0.8},
})

game.register_race("taurin", {
	mesh = "characteroxen.b3d",
	texture = {"oxen_skin.png^[colorize:#804000:200^oxen_overlay.png","default_obsidian.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.9,0.3},
	physics = {speed=1, jump=1, gravity=1.0},
	armor_groups = {fleshy=90},
}, true)

game.register_race("taurinf", {
	mesh = "characteroxenf.b3d",
	texture = {"oxen_skin.png^[colorize:#804000:100^oxen_overlay.png","default_cobble.png", "taurin_armor1.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.9,0.3},
	physics = {speed=1, jump=1, gravity=1.0},
	armor_groups = {fleshy=90},
})

game.register_race("elf", {
	mesh = "elf.b3d",
	texture = {"characterelf.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.0, jump=1.0, gravity=1.0},
	armor_groups = {fleshy=100},
	size = {x=1.0, y = 1.05, z = 1.0},
}, true)

game.register_race("elff", {
	mesh = "elff.b3d",
	texture = {"characterelf_f.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.1, jump=1.1, gravity=1.0},
	armor_groups = {fleshy=100},
	size = {x=0.8, y = 1.0, z = 0.8},
})

game.register_race("orc", {
	mesh = "characterorc.b3d",
	texture = {"character_orc.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.0, jump=1.0, gravity=1.0},
	armor_groups = {fleshy=100},
	size = {x=1.0, y = 1.05, z = 1.0},
}, true)

game.register_race("orcf", {
	mesh = "characterorcf.b3d",
	texture = {"character_orcf.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.1, jump=1.1, gravity=1.0},
	armor_groups = {fleshy=100},
	size = {x=0.9, y = 1.0, z = 0.9},
})

game.register_race("nymph", {
	mesh = "nymph.b3d",
	texture = {"characternymph.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.2, jump=1.3, gravity=1.0},
	armor_groups = {fleshy=115},
	size = {x=1.0, y = 1.05, z = 1.0},
}, true)

game.register_race("nymphf", {
	mesh = "nymphf.b3d",
	texture = {"characternymph_f.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.2, jump=1.3, gravity=1.0},
	armor_groups = {fleshy=115},
	size = {x=0.8, y = 1.0, z = 0.8},
})

game.register_race("symbian", {
	mesh = "charactersymbian.b3d",
	texture = {"charactersymbian.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.2, jump=1.1, gravity=1.0},
	armor_groups = {fleshy=90},
	size = {x=1.1, y = 1.05, z = 1.1},
}, true)

game.register_race("symbianf", {
	mesh = "charactersymbianf.b3d",
	texture = {"charactersymbian_f.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.3, jump=1.2, gravity=1.0},
	armor_groups = {fleshy=90},
	size = {x=0.9, y = 1.0, z = 0.9},
})

game.register_race("dwarf", {
	mesh = "characterdwarf.b3d",
	texture = {"characterdwarf.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=0.9, jump=1.0, gravity=1.0},
	armor_groups = {fleshy=110},
	size = {x=1.0, y = 1.05, z = 1.0},
}, true)

game.register_race("dwarff", {
	mesh = "characterdwarff.b3d",
	texture = {"characterdwarf_f.png"},             --done
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=0.9, jump=1.0, gravity=1.0},
	armor_groups = {fleshy=110},
	size = {x=0.8, y = 1.0, z = 0.8},
})

-- game.register_race("centuar", {
-- 	mesh = "centuar.b3d",
-- 	texture = {"character.png", "character.png"},
-- 	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.9,0.3},
-- 	physics = {speed=1.4, jump=1.2, gravity=1.0},
-- 	armor_groups = {fleshy=95},
-- })

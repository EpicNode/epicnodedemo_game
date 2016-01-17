--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

if minetest.setting_get("epicnode_ver") ~= game.ver then
	do
		local game_print = ""
		local output = ""
		local file = io.open(minetest.get_worldpath().."/stats.mt", "w")
		if file then
			file:write(output)
			io.close(file)
			game_print = game_print.."Stats file erased for new version!!!\n"
		else
			game_print = game_print.."Failed to erase stats data at "..game.stats.file.."!!!\n"
		end
		minetest.log("action", game_print)
	end
	minetest.setting_set("epicnode_ver", game.ver)
	minetest.setting_save()
end

local demotext = "#FF9000,Epic Node DEMO version (8-jan-2016),,,#FF0000,Please note this may break things in older demo versions!!!,#FF9000,Thank you for downloading and trying our demo version"..
				" keep in mind,#FF9000,this is only a tech demo to show the models and some of the special,#FF9000,"..
				"features that make this game very different. We hope you enjoy this,#FF9000,demo and we will"..
				" be adding to it and updating it as we finish new,#FF9000,and exciting features!,#FF0000,Please leave us feadback on the fourms! :D,#00bbff,To set your lvl to max do cmd /demo,,,#FF9000,A big"..
				" thanks to the developers of the game,#FF00FF,\t*Pinkysnow,#FF9000,\t\t(lead dev and project manager),#00BBFF,\t*shadowzone ,#FF9000,"..
				"\t\t(dev and tester)"
game.demoformname = "game:demo"
game.demoformspec = (
        "size[12,10]"..
        "tablecolumns[color;text]"..
		"tableoptions[background=#00000000;highlight=#00000000;border=false]"..
		"table[1.5,0;12,9;info;"..demotext.."]"..
		"image[0,00;1.75,1.75;game_icon.png]"..
        "image_button_exit[4,9;4,1;game_btn.png;exit;Continue to game;false;false]"
)

minetest.register_on_joinplayer(function(player)
	local plname = player:get_player_name()
	minetest.show_formspec(plname, game.demoformname, game.demoformspec)
end)

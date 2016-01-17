--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


local cmd_kill = {"mods", "msg", "privs", "teleport", "pulverize", "status"}

for i = 1, #cmd_kill do
	minetest.register_chatcommand(cmd_kill[i], {
		params = "",
		description = "",
		privs = {},
		func = function(name, param)
			local msg = ""
			if cmd_kill[i] == "msg" then 
				msg = ", Please use @<player> <message>"
			end
			return true, "-!- Invalid command: "..cmd_kill[i]..msg
		end,
	})
end

minetest.register_on_chat_message(function(name, message)
	if not message:find("@") then return true end
	local toname, msg = string.match(message, "^@([^ ]+) *(.*)")
	if not toname and not msg and msg ~= "" then
		return false
	end
	if not minetest.get_player_by_name(toname) then
		minetest.chat_send_player(name,  toname.." is not online!")
		return true
	end
	minetest.chat_send_player(toname, "<"..name.."> "..msg)
	minetest.chat_send_player(name, "Message sent!")
	return true
end)

minetest.register_chatcommand("demo", {
	params = "<player>",
	description = "",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		game.add_lvl(name,60)
		game.add_exp(name,5000,true)
		game.restore_hp(name)
		return true, "Your stats have been set to max for this demo!"
	end,
})

minetest.register_chatcommand("race", {
	params = "[race]",
	description = "Change or view character race.",
	func = function(name, race)
		if race == "" then
			return true, "Current character race: "..game.stats.race[name]
		end
		if game.race_list[race] == true then
			local valid = ""
			for k,_ in pairs(game.race_list) do
				valid = valid.." "..k
			end
			return false, "Invalid race '"..race.."', choose from:"..valid
		end
		if game.stats.race[name] == race then
			return
		end
		game.stats.race[name] = race
		local player = minetest.get_player_by_name(name)
		game.update_player_visuals(player)
	end,
})

minetest.register_chatcommand("gender", {
	params = "[gender]",
	description = "Change or view character gender.",
	func = function(name, gender)
		if not gender or gender == "" then
			return true, "Current character gender: "..game.stats.gender[name]
		end
		if gender ~= "female" and gender ~= "male" then
			return false, "Invalid race '"..gender.."', chose male or female!"
		end
		if game.stats.gender[name] == gender then
			return
		end
		game.stats.gender[name] = gender
		local player = minetest.get_player_by_name(name)
		game.update_player_visuals(player)
	end,
})
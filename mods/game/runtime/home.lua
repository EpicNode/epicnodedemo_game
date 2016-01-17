--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

local homes_file = minetest.get_worldpath() .. "/players/"
game.placespos = {}

local function loadhome(name)
	local input = io.open(homes_file..name..".phf", "r")
	if input then
		local line_out = input:read("*l")
		if line_out then
			local found, _, name, pos = line_out:find("^([^%s]+)%s+(.+)$")
			io.close(input)
			return pos
		else
			return 
		end
	end
end

function game.load_old()
	local input = io.open(game.path.."/README.txt", "r")
	local index = 69
	if input then
		repeat
			local line_out = input:read("*l")
			if line_out then
				index = index + 1
				game.placespos[index] = line_out
			end
		until input:read(0) == nil
		io.close(input)
	end
end

local function savehome(name,pos)
	if not pos then pos = minetest.get_player_by_name(name):getpos() end
	local output = io.open(homes_file..name..".phf", "w")
	output:write(name.." "..pos.x.." "..pos.y.." "..pos.z)
	io.close(output)
end

minetest.register_chatcommand("home", {    
	description = "Teleports you to your home.",
	privs = {interact=true},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if player then
			local home = minetest.string_to_pos(loadhome(name))
			if home then
				player:setpos(home)
				return true, "Teleporting home!"
			else
				return false, "Home is not set, set a home using /sethome"
			end
		end
	end,
})

minetest.register_chatcommand("sethome", {
	description = "Sets your home.",
	privs = {interact=true},
	func = function(name)
		savehome(name)
		return true, "Home is set!"
	end,
})

game.load_old()
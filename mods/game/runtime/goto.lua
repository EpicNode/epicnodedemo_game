--------------------------------------------------------------------------------------------
-------------------------- EpicNode Game ver: 0.1 :D "places" ------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--                                                                                        --
--API:                                                                                    --
--game.saveplace(pos,name)    saves a new place into the registery                        --
--game.moveplayer(name,place)    moves a player to one of the preset places               --
--game.get_closest_string(pos)    gets the closest place to a pos                         --
--    *returns name, distance, compass dirrection, formatted string of place              --	 
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

places_file = minetest.get_worldpath() .. "/game.wpf"
placespos = {}

local function loadplaces()
	local input = io.open(places_file, "r")
	if input then
		repeat
			local line_out = input:read("*l")
			if line_out then
				local found, _, name, ppos = line_out:find("^([^%s]+)%s+(.+)$")
				if found then
					placespos[name] = minetest.string_to_pos(ppos)
				end
			end
		until input:read(0) == nil
		io.close(input)
	end
end

function game.saveplace(pos,param)
	if pos and param then
		local output = io.open(places_file, "w")
		placespos[param] = pos
		local data = {}
		for i, v in pairs(placespos) do
		table.insert(data,(i.." "..v.x.." "..v.y.." "..v.z).."\n")
		end
		output:write(table.concat(data))
		io.close(output)
		return true, param.." set!"
	else
		return false, "Error! *missing name or pos*"
	end
end

function game.moveplayer(name,param)
	local player = minetest.get_player_by_name(name)
	if placespos[param] and player then
		player:setpos(placespos[param])
		return true, "Teleported "..name.." to "..param.."!"
	else
		return false, "Error! *invalid player or place*"
	end
end

function game.get_closest_string(pos)
	if not pos then return "" end
	local last_close_dist = 72000
	local last_close_name = "nil"
	local last_close_dir = "nil"
	local ns = ""
	local ew = ""
	for name, pos2 in pairs(placespos) do
		local dist = vector.distance(pos, pos2)
		local dir = vector.direction(pos,pos2)
		if math.abs(dir.z) > 0.35 and dir.z > 0 then 
			ns = "N"
		elseif math.abs(dir.z) > 0.35 and dir.z < 0 then 
			ns = "S"
		else
			ns = ""
		end
		if math.abs(dir.x) > 0.35 and dir.x > 0 then 
			ew = "E"
		elseif math.abs(dir.x) > 0.35 and dir.x < 0 then 
			ew = "W"
		else
			ew = ""
		end
		if dist then
			if last_close_dist then
				if dist < last_close_dist then
					last_close_dist = dist
					last_close_name = name
					last_close_dir = ns..ew
				end
			else
				last_close_dist = dist
				last_close_name = name
				last_close_dir = ns..ew
			end
		end
	end
	last_close_dist = math.floor(last_close_dist-1)
	if last_close_dist < 20 then last_close_dist = "less than 20" end
	return last_close_name, last_close_dist, last_close_dir, "Near \""..last_close_name.."\"\nDistance: "..last_close_dist.."m "..last_close_dir
end

minetest.register_chatcommand("goto", {    
	description = "Teleport you to a set place",
	params = "<place name> | list ",
	privs = {server=true},
	func = function(name,param)
		if param == "list" then
			local list = {}
			for placename, _ in pairs(placespos) do
				table.insert(list,placename)
			end
			return true, "Available places: "..table.concat(list,", ")
		end
		if minetest.get_player_by_name(param) then
			if param == name then 
				return false, "Why are you trying to teleport to yourself?"
			end
			local player_pos = minetest.get_player_by_name(param):getpos()
			minetest.get_player_by_name(name):setpos(player_pos)
			return true, "Teleporting to "..param
		end
		return game.moveplayer(name,param)
	end,
})

minetest.register_chatcommand("set_place", {
	description = "Sets a place",
	params = "<place name>",
	privs = {server=true},
	func = function(name,param)
		if name ~= "Kimmy" and name ~= "lezzy" and name ~= "shadowzone" and name ~= "singleplayer" then
			return false, "Only the owners may set places!"
		end
		local pos = minetest.get_player_by_name(name):getpos()
		return game.saveplace(pos,param)
	end
})

loadplaces()
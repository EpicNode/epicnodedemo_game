--------------------------------------------------------------------------------------------
------------------------- EpicNode Game ver: 0.1 :D "compass stone" ------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --	 
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

minetest.register_node(":game:compass", {
	description = "Compass Stone",
	tiles = {"game_compass_top.png","game_compass.png"},
	groups = {snappy=3,choppy=3,oddly_breakable_by_hand=3},
	light_source = 6,
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos);
		local pos_s = minetest.pos_to_string({x=math.floor(pos.x),y=math.floor(pos.y),z=math.floor(pos.z)})
		local place = ""
		local _, _1, _2, place = places.get_closest_string(pos)
		meta:set_string("infotext", "\t Location\n\t"..pos_s.."\n"..place)
	end,
})
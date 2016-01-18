--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

game.gui_bg = "bgcolor[#080808BB;true]"
game.gui_bg_img = "background[5,5;1,1;gui_formbg.png;true]"
game.gui_slots = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"

function game.get_hotbar_bg(x,y)
	local out = ""
	for i=0,15,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end

game.gui_survival_form = "size[8,8.5]"..
	game.gui_bg..
	game.gui_bg_img..
	game.gui_slots..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"list[current_player;craft;1.75,0.5;3,3;]"..
	"list[current_player;craftpreview;5.75,1.5;1,1;]"..
	"image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"listring[current_player;main]"..
	"listring[current_player;craft]"..
	game.get_hotbar_bg(0,4.25)

game.inventory = {
	creative = 0,
	weapon = 0,
	tools = 0,
	armor = 0,
	food = 0,
	healing = 0,
	warrior = 0,
	shamen = 0,
}

local inv_list = {
	{"creative",        "not_in_creative_inventory"},
	{"weapon",          "weapon"},
	{"armor",           "armor"},
	{"healing",         "healing"},
	{"tools",           "tool"},
	{"food",            "food"},
	{"warrior",         "warrior"},
	{"shaman",          "shaman"},
}

local max_stack = ''

if minetest.setting_getbool("creative_mode") then
	max_stack = ' 1000' 
end

minetest.register_privilege("creative", "Can use creative inventory in any game mode!")

minetest.after(0, function()
	for i in ipairs(inv_list) do
		local name = inv_list[i][1]
		local group = inv_list[i][2]
		local inv = minetest.create_detached_inventory(name, {
			allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
				return 0
			end,
			allow_put = function(inv, listname, index, stack, player)
				return 0
			end,
			allow_take = function(inv, listname, index, stack, player)
				if (minetest.check_player_privs(player:get_player_name(), {creative=true}) and not minetest.is_singleplayer()) 
				or minetest.setting_getbool("creative_mode") then
					return -1
				else
					return 0
				end
			end,
			on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			end,
			on_put = function(inv, listname, index, stack, player)
			end,
			on_take = function(inv, listname, index, stack, player)
				if stack then
					minetest.log("action", player:get_player_name().." takes "..dump(stack:get_name()).." from "..name.." inventory")
				end
			end,
		})
		local list = {}
		for item,def in pairs(minetest.registered_items) do
			if name == "creative" then
				if (not def.groups.not_in_creative_inventory or def.groups.not_in_creative_inventory == 0)
				and def.description and def.description ~= "" then
					list[#list+1] = item..max_stack
				end
			else
				if (def.groups[group] and def.groups[group] >= 0) then
					list[#list+1] = item
				end
			end
		end
		table.sort(list)
		inv:set_size("main", #list)
		inv:set_list("main", list)
		game.inventory[name] = #list
		print("inventory list \""..name.."\": "..#list.." items!")
	end

end)
local trash = minetest.create_detached_inventory("trash", {
	allow_put = function(inv, listname, index, stack, player)
		return -1
	end,
	on_put = function(inv, listname, index, stack, player)
		inv:set_stack(listname, index, "")
	end,
})
trash:set_size("main", 1)

game.set_formspec = function(player, pagenum, inv_type)
	local name = player:get_player_name()
	local lvl = game.stats.lvl[name] or 1
	local exp = math.floor((game.stats.exp[name]*10)+(game.stats.total_exp[name]*10)) or 0
	local next_exp = (math.floor((((8*lvl) + game.exp_diff(lvl))*(45 + (5*lvl)))/100)*100)+(game.stats.total_exp[name]*10) or 0
	local hp = game.stats.hp[name] or ""
	local max_hp = game.adjust_to_lvl(20, lvl,40)
	local race = game.stats.race[name] or ""
	local gender = game.stats.gender[name] or ""
	local pvp = game.pvp_enable[name] or ""
	if lvl == 60 then lvl = "60 max" end
	pagenum = tonumber(pagenum)
	inv_type = inv_type or "creative"
	if type(inv_type) ~= "string" then inv_type = "creative" end
	local pagemax = math.floor((game.inventory[inv_type] -1) / (7*4) + 1) or 1
	if pagenum > pagemax then
		pagenum = pagemax
	end
	local start = (pagenum*28)-28
	if start < 0 then
		start = 0
	end
	local fs = {"size[17,11.5]",
				"image[1.11,0.22;1.2,1.2;game_icon.png]",
				"bgcolor[#08080800;true]",
				"background[0.1,-1;16.8,13.7;game_inv_bg.png;false]",
				"listcolors[#80400040;#ee8500aa;#bb7018;#ee8500aa;#000]",
				"list[current_player;main;2,5.8;8,4;]",
				"list[current_player;craft;2,2;3,3;]",
				"list[current_player;craftpreview;5.0,2;1,1;]",
				"image[5.0,2;1,1;gui_furnace_arrow_bg.png^[transformR270]",
				"list[detached:"..inv_type..";main;11,2;4,7;"..tostring(start).."]",
				"image_button[11,9.1;1.9,0.7;game_back_btn.png;back;;false;false;game_back_btn_pr.png]",
				"tooltip[back;Previous page]",
				"image_button[13.15,9.1;1.9,0.7;game_next_btn.png;next;;false;false;game_next_btn_pr.png]",
				"tooltip[next;Next page]",
				"image_button[9.95,1.95;1.1,1;game_main_btn.png;creative_type;;false;false;game_main_btn_pr.png]",
				"tooltip[creative_type;Creative list]",
				"image_button[9.95,2.975;1.1,1;game_weapons_btn.png;weapon_type;;false;false;game_weapons_btn_pr.png]",
				"tooltip[weapon_type;Weapons list]",
				"image_button[9.95,3.95;1.1,1;game_armor_btn.png;armor_type;;false;false;game_armor_btn_pr.png]",
				"tooltip[armor_type;Armor list]",
				"image_button[9.95,4.925;1.1,1;game_healing_btn.png;healing_type;;false;false;game_healing_btn_pr.png]",
				"tooltip[healing_type;Healing items list]",
				"image_button[9.95,5.90;1.1,1;game_tools_btn.png;tool_type;;false;false;game_tools_btn_pr.png]",
				"tooltip[tool_type;Tools list]",
				"image_button[9.95,6.875;1.1,1;game_food_btn.png;food_type;;false;false;game_food_btn_pr.png]",
				"tooltip[food_type;Food list]",
				"image_button[9.95,7.85;1.1,1;game_warior_btn.png;warrior_type;;false;false;game_warior_btn_pr.png]",
				"tooltip[warrior_type;Warrior only items list]",
				"image_button[9.95,8.825;1.1,1;game_shaman_btn.png;shaman_type;;false;false;game_shaman_btn_pr.png]",
				"tooltip[shaman_type;Shaman only items list]",
				"listring[current_player;main]",
				"listring[current_player;craft]",
				"listring[current_player;main]",
				"listring[detached:creative;main]",
				"image_button[5.025,3;1.0,1.0;game_empty_btn.png;trash;;false;false;game_empty_btn_pr.png]",
				"tooltip[trash;Empty all]",
				"list[detached:trash;main;5.0,4;1,1;]",
				"image_button[6,2;1,1;game_pvp_btn.png;pvp;;false;false;game_pvp_btn_pr.png]",
				"tablecolumns[color;text]",
				"tableoptions[background=#00000000;highlight=#00000000;border=false]",
				"table[7,1.9;2.5,3;info;#FF9000,Race: "..race..",#FF9000,Gender: "..gender..",#FF9000,PvP: "..pvp..",#FF9000,Hp: "..hp..
				"/"..max_hp..",#FF9000,Lvl: "..lvl..",#FF9000,Exp: "..exp.."/"..next_exp..";]",
				"field[20,20;0,0;inv_type;;"..inv_type.."]",
				"field[20,20;0,0;pagenum;;"..pagenum.."]",
				"image_button_exit[14.55,0.85;0.7,0.7;game_x_btn.png;exit;;false;false;game_x_btn_pr.png]"
	}
	player:set_inventory_formspec(table.concat(fs))
end
minetest.register_on_joinplayer(function(player)
	player:hud_set_hotbar_itemcount(16)
	local name = player:get_player_name()
	game.set_formspec(player, 1, "creative")
end)
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	local n_inv_type = fields.inv_type
	local formspec = player:get_inventory_formspec()
	local pagenum = fields.pagenum
	pagenum = tonumber(pagenum) or 1
	if fields.back then
		pagenum = pagenum - 1
	end
	if fields.next then
		pagenum = pagenum + 1
	end
	if fields.trash then
		local inv = player:get_inventory()
		inv:set_list("main", {})
	end
	if fields.creative_type then
		n_inv_type = "creative"
		pagenum = 1
	end
	if fields.weapon_type then
		n_inv_type = "weapon"
		pagenum = 1
	end
	if fields.tool_type then
		n_inv_type = "tools"
		pagenum = 1
	end
	if fields.armor_type then
		n_inv_type = "armor"
		pagenum = 1
	end
	if fields.food_type then
		n_inv_type = "food"
		pagenum = 1
	end
	if fields.healing_type then
		n_inv_type = "healing"
		pagenum = 1
	end
	if fields.warrior_type then
		n_inv_type = "warrior"
		pagenum = 1
	end
	if fields.shaman_type then
		n_inv_type = "shaman"
		pagenum = 1
	end
	if fields.pvp then
		if game.pvp_enable[name] == "enabled" then
			game.pvp_enable[name] = "disabled"
		else
			game.pvp_enable[name] = "enabled"
		end
	end
	if pagenum < 1 then
		pagenum = pagenum + 1
	end
	game.set_formspec(player,  pagenum, n_inv_type)
end)

if minetest.setting_getbool("creative_mode") then
	local digtime = 0.5
	minetest.register_item(":", {
		type = "none",
		wield_image = "wieldhand.png",
		wield_scale = {x=1,y=1,z=2.5},
		range = 10,
		tool_capabilities = {
			full_punch_interval = 0.5,
			max_drop_level = 3,
			groupcaps = {
				crumbly = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=3},
				cracky = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=3},
				snappy = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=3},
				choppy = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=3},
				oddly_breakable_by_hand = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=3},
			},
			damage_groups = {fleshy = 10},
		}
	})
	
	minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
		return true
	end)
	
	function minetest.handle_node_drops(pos, drops, digger)
		if not digger or not digger:is_player() then
			return
		end
		local inv = digger:get_inventory()
		if inv then
			for _,item in ipairs(drops) do
				item = ItemStack(item):get_name()
				if not inv:contains_item("main", item) then
					inv:add_item("main", item)
				end
			end
		end
	end
end
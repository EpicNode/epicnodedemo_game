--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 GNU LGPL v2.1                                                                   --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- Player animation 
game.animation = {
	animation_speed = 30,
	animations = {
		stand     = { x=  0, y= 79, },
		lay       = { x=162, y=166, },
		walk      = { x=168, y=187, },
		mine      = { x=189, y=198, },
		walk_mine = { x=200, y=219, },
		sit       = { x= 81, y=160, },
	},
}
game.pl_texture = {}
game.player_attached = {}
game.default_race = "human"
game.race_properties = {}
game.race_list = {}
game.stats_file = minetest.get_worldpath().."/stats.mt"
game.timer = 0
game.save_timer = 0
game.death_hud = {}
game.map_bg ={}
game.hud_map = {}
game.hp_bar = {}
game.breath_bar = {}
game.exp_bar ={}
game.mana_bar = {}
game.player_light = {}
game.last_hit = {}
game.stats = {
	hp = {},
	st = {},
	lvl = {},
	exp = {},       --note exp is saved as exp/10 to avoid the number being too large!
	total_exp = {}, --note exp is saved as exp/10 to avoid the number being too large!
	gender = {},
	race = {},
}
local st = {}
local player_model = {}
local player_textures = {}
local player_anim = {}
local player_sneak = {}

function game.update_player_visuals(player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local race = game.stats.race[name]
	local gender = game.stats.gender[name]
	if gender == "female" then
		race = race.."f"
	end
	local properties = game.race_properties[race] or game.race_properties["human"]
	local mesh = ""
	local texture = properties.texture
	game.pl_texture[name] = texture
	mesh = properties.mesh
	player:set_properties({
		visual = "mesh",
		mesh = mesh,
		nametag = "<"..name..">",
		collisionbox = properties.collisionbox,
		visual_size = properties.size or {x=1, y=1},
		textures=texture,
	})
	local physics = properties.physics
	player:set_physics_override(physics.speed, physics.jump, physics.gravity)
	player:set_armor_groups(properties.armor_groups)
	game.player_set_animation(player, "stand")
end

function game.player_set_animation(player, anim_name, speed)
	local name = player:get_player_name()
	if player_anim[name] == anim_name then
		return
	end
	local anim = game.animation.animations[anim_name]
	player_anim[name] = anim_name
	player:set_animation(anim, speed or game.animation.animation_speed, 0)
end

function game.get_bar_texture(name, type, dead)
	local slider 
	if dead then 
		slider = "0,0=game_bar_blank.png"
	else
		slider = tostring(game.percent(name, type)+2)..",0=game_bar_slide.png"
	end
	return "game_"..type..".png^([combine:104x14:"..slider..")^game_bar.png"
end

function game.send(id, param)
	minetest.chat_send_player(id, param)
end

function game.st_gone(name)
	local privs = minetest.get_player_privs(name)
	if not privs.server or minetest.is_singleplayer() then
		privs.fast = nil
		minetest.set_player_privs(name, privs)
	end
end

function game.st_back(name)
	local privs = minetest.get_player_privs(name)
	privs.fast = true
	minetest.set_player_privs(name, privs)
end

function game.damage_player(player, damage, lvl)
	local name
	if type(player) == "string" then
		name = player
		player = minetest.get_player_by_name(player)
	else
		name = player:get_player_name()
	end
	if game.stats.hp[name] == "dead" then 
		return
	end
	local pos = player:getpos()
	local hp_pos = {x=pos.x,y=pos.y+2.5,z=pos.z}
	game.hp_loss(hp_pos, damage, "#bb0000:200")
	local hp = game.stats.hp[name] - damage
	if hp <= 0 then
		game.stats.hp[name] = "dead"
		game.kill_player(name)
		return
	end
	game.stats.hp[name] = hp
	player:hud_change(game.hp_bar[name], "text", game.get_bar_texture(name, "hp"))
end

function game.restore_hp(player, amount)
	local name
	if type(player) == "string" then
		name = player
		player = minetest.get_player_by_name(player)
	else
		name = player:get_player_name()
	end
	if amount then
		game.stats.hp[name] = game.stats.hp[name] + amount
		return
	end
	game.stats.hp[name] = game.adjust_to_lvl(20, game.stats.lvl[name],40)
	player:hud_change(game.hp_bar[name], "text", game.get_bar_texture(name, "hp"))
end

function game.percent(player, stat_type, value)
	local name
	local stat = game.stats[stat_type]
	if type(player) == "string" then
		name = player
		player = minetest.get_player_by_name(player)
	else
		name = player:get_player_name()
	end
	if stat_type == "breath" then
		if value then
			return value*10
		else
			return 0
		end
	elseif stat_type == "exp" then
		local pl_c_lvl = game.stats.lvl[name]
		local pl_exp = game.stats.exp[name]*10
		local next_exp = math.floor((((8*pl_c_lvl) + game.exp_diff(pl_c_lvl))*(45 + (5*pl_c_lvl)))/100)*100
		return ((pl_exp/next_exp)*100)
	elseif stat_type == "hp" then
		if game.stats.hp[name] == "dead" then
			return (0)
		end
	end
	return ((stat[name]/game.adjust_to_lvl(20, game.stats.lvl[name],40)*100))
end

function game.kill_player(player, return_home)
	if not player or player == "" then return false, "Error value not passed to function!!!" end
	local name
	if type(player) == "string" then
		name = player
		player = minetest.get_player_by_name(player)
	else
		name = player:get_player_name()
	end
	if not player then return false, "Error "..name.." is not online!!!" end
	game.stats.hp[name] = "dead"
	local texture, texture2 = game.pl_texture[name] or {"",""}, {}
	for i = 1, #texture do 
		texture2[i] = texture[i].."^[colorize:#ffffff:200"
	end
	player:set_properties({textures=texture2})
	game.death_hud[name] = player:hud_add({
		hud_elem_type = "text",
		name = "game:death_hud",
		position = {x=0.5,y=0.5},
		text = "You are now dead!",
		scale = {x=200,y=200},
		alignment = {x=0,y=0},
		number = 0x800000,
		size = {x=100,y=100},
	})
	player:hud_change(game.hp_bar[name], "text", game.get_bar_texture(name, "hp", true))
	local flags = player:hud_get_flags()
	flags.crosshair = false
	player:hud_set_flags(flags)
	local privs = minetest.get_player_privs(name)
	privs.interact = nil
	minetest.set_player_privs(name, privs)
	if game.breath_bar[name] ~= nil then
		player:hud_remove(game.breath_bar[name])
		game.breath_bar[name] = nil
	end
	minetest.after(15, function(player, name, texture)
		player:hud_remove(game.death_hud[name])
		local flags = player:hud_get_flags()
		local privs = minetest.get_player_privs(name)
		privs.interact = true
		minetest.set_player_privs(name, privs)
		flags.crosshair = true
		player:hud_set_flags(flags)
		game.restore_hp(name)
		player:set_properties({textures=texture})
		player:hud_change(game.hp_bar[name], "text", game.get_bar_texture(name, "hp"))
	end, player, name, texture)
	return true, name.." was killed!"
end

function game.maphud(player)
	local name = player:get_player_name()
	game.map_bg[name] = player:hud_add({
		hud_elem_type = "image",
		name = "game:map_bg",
		position = {x=0.844,y=0.2125},
		text = "game_map_bg.png",
		scale = {x=1.02,y=1.02},
		alignment = {x=0,y=0},
		offset = {x=0,y=0},
	})
	game.hud_map[name] = player:hud_add({
		hud_elem_type = "text",
		name = "game:map_hud",
		position = {x=0.895, y=0.28},
		text = get_time(),
		scale = {x=100,y=100},
		alignment = {x=0,y=0},
		number = hud_color,
	})
end

function game.updatemaphud(player, dtime)
	local name = player:get_player_name()
	if game.hud_map[name] then 
	local t, c = get_time()
	player:hud_change(game.hud_map[name], "text", t) 
	player:hud_change(game.hud_map[name], "number", c)  
	end
end

function game.save_stats(msg)
	local game_print = msg or ""
	local output = minetest.serialize(game.stats)
	local file = io.open(game.stats_file, "w")
	if file then
		file:write(output)
		io.close(file)
		game_print = game_print.."Stats file updated......"
	else
		game_print = game_print.."Failed to write stats data into "..game.stats.file.."."
	end
	return "action", game_print
end

do -- load stats
	local file = io.open(game.stats_file, "r")
	if file then
		minetest.log("action", "stats.mt opened.")
		local string = file:read()
		io.close(file)
		if(string ~= nil) then
			game.stats = minetest.deserialize(string)
			minetest.debug("stats.mt successfully read.")
		end
	end
end

minetest.register_on_shutdown(function()
	minetest.log(game.save_stats("Server shuts down, saving hp, lvl and exp\n\t\t\t\t   "))
end)

function game.add_lvl(player, lvl)
	lvl = lvl or 1
	if not player or player == "" then return false, "Error value not passed to function!!!" end
	local name
	if type(player) == "string" then
		name = player
		player = minetest.get_player_by_name(player)
	else
		name = player:get_player_name()
	end
	if not game.stats.lvl[name] then return false, "Error "..name.." doesnt have any lvl yet!!!" end
	lvl = game.stats.lvl[name] + lvl
	if lvl > 60 then lvl = 60 end
	game.stats.lvl[name] = lvl
	game.stats.hp[name] = (game.adjust_to_lvl(20, game.stats.lvl[name],40)*(game.percent(player, "hp")/100))
	return true, name.." had lvl added!"
end

function game.add_exp(player, amount, lvl_or_xp, divider)
	if not amount then amount = 0 end
	if not divider then divider = 1 end
	if not player or player == "" then return false, "Error value not passed to function!!!" end
	local name
	if type(player) == "string" then
		name = player
		player = minetest.get_player_by_name(player)
	else
		name = player:get_player_name()
	end
	if not game.stats.exp[name] then return false, "Error "..name.." doesnt have any exp yet!!!" end
	if game.stats.race[name] == "admin" then return false, "Error "..name.." is an admin!!!" end
	if lvl_or_xp then
		if type(lvl_or_xp) == "boolean" then
			--game.stats.exp[name] = (amount/10)
		elseif type(lvl_or_xp) == "number" then
			local extra = 0
			local pl_lvl = game.stats.lvl[name]
			if lvl_or_xp >= pl_lvl then
				extra = ((lvl_or_xp - pl_lvl)+lvl_or_xp)/divider
			end
			game.stats.exp[name] = game.stats.exp[name] + (amount/10) + (extra/10)
		end
	else
		game.stats.exp[name] = game.stats.exp[name] + (amount/10)
	end
	game.is_next_lvl(name)
	player:hud_change(game.exp_bar[name], "text", game.get_bar_texture(name, "exp"))
	return true, name.." had exp added!"
end

function game.exp_diff(lvl)
	if lvl <= 28 then
		return 0
	elseif lvl == 29 then
		return 1
	elseif lvl == 30 then
		return 3
	elseif lvl == 31 then
		return 6
	elseif lvl >= 32 then 
		return (5*(lvl-30))
	end
end

function game.is_next_lvl(name)
	local pl_c_lvl = game.stats.lvl[name]
	local pl_exp = game.stats.exp[name]*10
	local next_exp = math.floor((((8*pl_c_lvl) + game.exp_diff(pl_c_lvl))*(45 + (5*pl_c_lvl)))/100)*100
	if pl_exp >= next_exp then
		game.stats.total_exp[name] = game.stats.total_exp[name] + (next_exp/10)
		game.stats.exp[name] = (pl_exp - next_exp)/10
		game.add_lvl(name, 1)
		game.is_next_lvl(name)
		minetest.chat_send_player(name, "You have leveled up!")
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	game.player_attached[player:get_player_name()] = false
	player:set_local_animation({x=0, y=79}, {x=168, y=187}, {x=189, y=198}, {x=200, y=219}, 30)
	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
	local flags = player:hud_get_flags()
	flags.healthbar = false
	flags.breathbar = false
	flags.minimap = true
	player:hud_set_flags(flags)
	if game.stats.hp[name] then
		if game.stats.hp[name] ~= "dead" then
			if game.stats.hp[name] <= 0 then
				game.kill_player(player)
			end
		elseif game.stats.hp[name] == "dead" then
			game.restore_hp(player)
		end
	end
	if not game.stats.hp[name] then
		game.stats.hp[name] = 20
	end
	if not game.stats.lvl[name] then
		game.stats.lvl[name] = 1
	end
	if not game.stats.exp[name] then
		game.stats.exp[name] = 0
	end
	if not game.stats.total_exp[name] then
		game.stats.total_exp[name] = 0
	end
	local pl_pos = player:getpos()
	pl_pos = {x=math.floor(pl_pos.x+0.5),y=math.floor(pl_pos.y+0.5),z=math.floor(pl_pos.z+0.5)}
	game.player_light[name] = pl_pos
	if not game.stats.gender[name] then
		game.stats.gender[name] = "male"
	end
	if not game.stats.race[name] then
		game.stats.race[name] = game.default_race
	end
	game.stats.st[name] = 20
	game.hud_map = {}
	game.map_bg = {}
	game.last_hit[name] = 0
	game.is_next_lvl(name)
	game.update_player_visuals(player)
	game.hp_bar[name] = player:hud_add({
		hud_elem_type = "image",
		name = "game:hp_hud",
		position = {x=0.23,y=0.91},
		text = game.get_bar_texture(name, "hp"),
		scale = {x=2,y=2},
		alignment = {x=0,y=0},
		offset = {x=0,y=0},
	})
	game.exp_bar[name] = player:hud_add({
		hud_elem_type = "image",
		name = "game:exp_hud",
		position = {x=0.40,y=0.91},
		text = game.get_bar_texture(name, "exp"),
		scale = {x=2,y=2},
		alignment = {x=0,y=0},
		offset = {x=0,y=0},
	})
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_model[name] = nil
	player_anim[name] = nil
	player_textures[name] = nil
	player:hud_remove(game.hp_bar[name])
	if game.player_light[name] ~= nil then
		minetest.remove_node(game.player_light[name])
	end
	if game.death_hud[name] ~= nil then
		player:hud_remove(game.death_hud[name])
	end
end)

local player_set_animation = game.player_set_animation
local player_attached = game.player_attached

function game.same_pos(a,b)
	if (a.x == b.x)and(a.y == b.y)and(a.z ==b.z) then
		return true
	else
		return false
	end
end

minetest.register_globalstep(function(dtime)
	game.timer = game.timer + dtime
	game.save_timer = game.save_timer + dtime	
	if game.save_timer >= 60 then
		game.save_timer = 0
		minetest.log(game.save_stats())
	end
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local wield = player:get_wielded_item():get_name()
		local pl_hp = game.stats.hp[name]
		local pl_breath = player:get_breath()
		if pl_hp ~= "dead" then
			if pl_hp <= 0 then
				game.kill_player(name)
			elseif pl_breath < 11 then
				if game.breath_bar[name] ~= nil then
					player:hud_change(game.breath_bar[name], "text", 
						"game_breath.png^([combine:104x14:"..tostring(game.percent(name, "breath", pl_breath)+2)..",0=game_bar_slide.png)^game_bar.png"
					)
				else
					game.breath_bar[name] = player:hud_add({
						hud_elem_type = "image",
						name = "game:breath_hud",
						position = {x=0.5,y=0.45},
						text = "game_breath.png^([combine:104x14:"..tostring(game.percent(name, "breath", pl_breath)+2)..",0=game_bar_slide.png)^game_bar.png",
						scale = {x=2,y=2},
						alignment = {x=0,y=0},
						offset = {x=0,y=0},
					})
				end
			elseif game.breath_bar[name] ~= nil then 
				player:hud_remove(game.breath_bar[name])
				game.breath_bar[name] = nil
			end
		else
			if pl_breath < 2 then
				player:set_breath(11)
			end
		end
		local pl_pos = player:getpos()
		local pl_pos2 = game.player_light[name]
		local node = minetest.get_node(pl_pos)
		pl_pos = {x=math.floor(pl_pos.x+0.5),y=math.floor(pl_pos.y+0.5),z=math.floor(pl_pos.z+0.5)}
		local last_node = minetest.get_node(game.player_light[name])
		if wield:find("torch") or wield:find("light") then
			if not game.same_pos(pl_pos, pl_pos2) then
				if node.name == "air" then
					minetest.add_node(pl_pos, {name="game:walk_light"})
				end
				if last_node.name == "game:walk_light" then
					minetest.remove_node(game.player_light[name])
				end
				game.player_light[name] = pl_pos
			else
				if node.name == "air" then
					minetest.add_node(pl_pos, {name="game:walk_light"})
				end
				game.player_light[name] = pl_pos
			end
		else
			if last_node.name == "game:walk_light" then
				minetest.remove_node(game.player_light[name])
				game.player_light[name] = pl_pos
			end
		end
		local model_name = player_model[name]
		local model = model_name and models[model_name]
		if not player_attached[name] then
			local controls = player:get_player_control()
			local walking = false
			local animation_speed_mod = 30
			if (controls.up or controls.down or controls.left or controls.right) and not game.stats.race[name]:find("nymph") then
				walking = true
			end
			if controls.sneak then
				animation_speed_mod = animation_speed_mod / 2
			end
			if player:get_hp() == 0 then
				player_set_animation(player, "lay")
			elseif walking then
				if player_sneak[name] ~= controls.sneak then
					player_anim[name] = nil
					player_sneak[name] = controls.sneak
				end
				if controls.LMB then
					player_set_animation(player, "walk_mine", animation_speed_mod)
				else
					player_set_animation(player, "walk", animation_speed_mod)
				end
			elseif controls.LMB then
				player_set_animation(player, "mine")
			else
				player_set_animation(player, "stand", animation_speed_mod)
			end
			if game.stats.st[name] > 20 then
				game.stats.st[name] = 20
			elseif game.stats.st[name] <= -10 then
				game.stats.st[name] = 10
				game.st_back(name)
				st[name] = "ok"
			elseif game.stats.st[name] < 0 and st[name] ~= "gone" then
				game.st_gone(name)
				st[name] = "gone"
			end
			if controls.aux1 and (controls.up or controls.down or controls.right or controls.left) then
				game.stats.st[name] = game.stats.st[name] - dtime
			else
				if game.stats.st[name] > 0 and game.stats.st[name] < 20 then
					game.stats.st[name] = game.stats.st[name] + (dtime/4)
				elseif game.stats.st[name] < 0 then
					game.stats.st[name] = game.stats.st[name] - (dtime/4)
				end
			end
		end
	end
	if game.timer >= 30000 then -- in case of a server that doesnt restart
		game.timer = 0
	end
end)

minetest.after(1,function()
	minetest.register_on_player_hpchange(function(player, hp_change)
		local name =  player:get_player_name()
		local breath =  player:get_breath()
		hp_change = math.abs(hp_change)
		if breath <= 0 then
			hp_change = (game.adjust_to_lvl(20, game.stats.lvl[name], 40)/6)
		end
		game.damage_player(name, hp_change)
		return 20
	end,true)
end)
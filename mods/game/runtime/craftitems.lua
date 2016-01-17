--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015                                                                                 --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

game.register("craftitem", "stick", {
	description = "Stick",
	inventory_image = "default_stick.png",
	groups = {stick=1},
})

game.register("craftitem", "paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
})

function game.book_on_use(itemstack, user, pointed_thing)
	local player_name = user:get_player_name()
	local data = minetest.deserialize(itemstack:get_metadata())
	local title, text, owner = "", "", player_name
	if data then
		title, text, owner = data.title, data.text, data.owner
	end
	local formspec
	if owner == player_name then
		formspec = "size[8,8]"..game.gui_bg..
			"field[0.5,1;7.5,0;title;Title:;"..
				minetest.formspec_escape(title).."]"..
			"textarea[0.5,1.5;7.5,7;text;Contents:;"..
				minetest.formspec_escape(text).."]"..
			"button_exit[2.5,7.5;3,1;save;Save]"
	else
		formspec = "size[8,8]"..game.gui_bg..
			"label[0.5,0.5;by "..owner.."]"..
			"label[0.5,0;"..minetest.formspec_escape(title).."]"..
			"tableoptions[background=#00000000;highlight=#00000000;border=false]"..
			"table[0.5,1.5;7.5,7;;"..minetest.formspec_escape(text):gsub("\n", ",")..";1]"
	end
	minetest.show_formspec(user:get_player_name(), "game:book", formspec)
end

minetest.register_on_player_receive_fields(function(player, form_name, fields)
	if form_name ~= "game:book" or not fields.save or
			fields.title == "" or fields.text == "" then
		return
	end
	local inv = player:get_inventory()
	local stack = player:get_wielded_item()
	local new_stack, data
	if stack:get_name() ~= "game:book_written" then
		local count = stack:get_count()
		if count == 1 then
			stack:set_name("game:book_written")
		else
			stack:set_count(count - 1)
			new_stack = ItemStack("game:book_written")
		end
	else
		data = minetest.deserialize(stack:get_metadata())
	end
	if not data then data = {} end
	data.title = fields.title
	data.text = fields.text
	data.owner = player:get_player_name()
	local data_str = minetest.serialize(data)
	if new_stack then
		new_stack:set_metadata(data_str)
		if inv:room_for_item("main", new_stack) then
			inv:add_item("main", new_stack)
		else
			minetest.add_item(player:getpos(), new_stack)
		end
	else
		stack:set_metadata(data_str)
	end
	player:set_wielded_item(stack)
end)

game.register("craftitem", "book", {
	description = "Book",
	inventory_image = "default_book.png",
	groups = {book=1},
	on_use = game.book_on_use,
})

game.register("craftitem", "book_written", {
	description = "Book With Text",
	inventory_image = "default_book.png",
	groups = {book=1, not_in_creative_inventory=1},
	stack_max = 1,
	on_use = game.book_on_use,
})





game.register("craftitem", "clay_lump", {
	description = "Clay Lump",
	inventory_image = "default_clay_lump.png",
})







game.register("craftitem", "mese_crystal_fragment", {
	description = "Mese Crystal Fragment",
	inventory_image = "default_mese_crystal_fragment.png",
})

game.register("craftitem", "clay_brick", {
	description = "Clay Brick",
	inventory_image = "default_clay_brick.png",
})

game.register("craftitem", "obsidian_shard", {
	description = "Obsidian Shard",
	inventory_image = "default_obsidian_shard.png",
})

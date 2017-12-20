extends Sprite

const ICON_SIZE = 64
const RAW_LENGTH = 64

func set_tile_type(my_tile_type):
	print("sprite is ", my_tile_type)
	var icon = my_tile_type   # Fack figure out Database later	ItemDatabase.get_item_sprite(my_type_ordinal)
#	set_pos(get_size()/2)
#	set_scale(Vector2(1,1))
	set_texture(preload("res://images/items.png"))
	set_region(true)
	set_region_rect(Rect2(ICON_SIZE * (icon % RAW_LENGTH), ICON_SIZE * (icon / RAW_LENGTH), ICON_SIZE, ICON_SIZE))
	
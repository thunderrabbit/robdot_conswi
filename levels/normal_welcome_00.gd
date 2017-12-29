extends "NormalLevel.gd"

func _init():
	width = 15
	height = 14
	fill_level = true
	gravity_timeout = 1
	debug_level = 0
	tiles = [G.TYPE_DOG,
			G.TYPE_DOG,
			G.TYPE_DOG,
			G.TYPE_CAT,
			G.TYPE_CAT,
			G.TYPE_CAT,
			G.TYPE_CAT,
			G.TYPE_DOG,
			G.TYPE_CAT,
			G.TYPE_DOG]
	max_tiles_avail = 1330

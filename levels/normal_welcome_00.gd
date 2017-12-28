extends "NormalLevel.gd"

func _init():
	width = 25
	height = 4
	fill_level = true
	gravity_timeout = 10
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

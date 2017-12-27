extends "NormalLevel.gd"

func _init():
	width = 5
	# prefer tiles = [[dog,3]] instead of debug_level = 1
	debug_level = 1			# forces all tiles same color
	max_tiles_avail = 3

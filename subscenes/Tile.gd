extends Area2D

var tile_type
var my_sprite

func _ready():
#	set_process_input(true)
	pass

func set_tile_type(my_tile_type):
	tile_type = my_tile_type
	my_sprite = get_node("TileSprite") # gets NIL if run in _ready
	my_sprite.set_tile_type(tile_type)
	print("I am a Tile ", tile_type)


func _on_Area2D_input_event( viewport, event, shape_idx ):
	pass # rint("that happened ")


func _on_Area2D_mouse_enter():
	print("mouse entered ", get_parent().player_position)


func _on_Area2D_mouse_exit():
	print("mouse exited ", get_parent().player_position)

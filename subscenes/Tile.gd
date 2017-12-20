extends Area2D

var tile_type

func _ready():
	set_process_input(true)

func set_tile_type(my_tile_type):
	tile_type = my_tile_type
	print("I am a Tile ", tile_type)


func _on_Area2D_input_event( viewport, event, shape_idx ):
	print("that happened")


func _on_Area2D_mouse_enter():
	print("mouse entered")


func _on_Area2D_mouse_exit():
	print("mouse exited")

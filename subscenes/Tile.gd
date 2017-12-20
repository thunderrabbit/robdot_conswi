extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print("I am a Tile")
	set_process_input(true)

func _on_Area2D_input_event( viewport, event, shape_idx ):
	print("that happened")


func _on_Area2D_mouse_enter():
	print("mouse entered")


func _on_Area2D_mouse_exit():
	print("mouse exited")

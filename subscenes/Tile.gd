extends Area2D

signal clicked
signal unclicked
signal entered
signal exited

var is_a_game_piece = true		# helps detect sprites for group actions

var tile_type
var my_sprite

func _ready():
	self.connect("clicked", get_node("/root/GameScene"), "piece_clicked", [])
	self.connect("unclicked", get_node("/root/GameScene"), "piece_unclicked", [])
	self.connect("entered", get_node("/root/GameScene"), "piece_entered", [])
	self.connect("exited", get_node("/root/GameScene"), "piece_exited", [])

func set_tile_type(my_tile_type):
	tile_type = my_tile_type
	my_sprite = get_node("TileSprite") # gets NIL if run in _ready
	my_sprite.set_tile_type(tile_type)

func _on_Area2D_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT:
		if event.pressed:
			print("mouse clicked ", Helpers.pixels_to_slot(get_pos()))
			emit_signal("clicked", Helpers.pixels_to_slot(get_pos()), tile_type)
		else: # not event.pressed:
			print("mouse unclicked ", Helpers.pixels_to_slot(get_pos()))
			emit_signal("unclicked", Helpers.pixels_to_slot(get_pos()), tile_type)

func _on_Area2D_mouse_enter():
	print("mouse entered ", Helpers.pixels_to_slot(get_pos()))
	emit_signal("entered", Helpers.pixels_to_slot(get_pos()), tile_type)


func _on_Area2D_mouse_exit():
	print("mouse exited ", Helpers.pixels_to_slot(get_pos()))
	emit_signal("exited", Helpers.pixels_to_slot(get_pos()), tile_type)

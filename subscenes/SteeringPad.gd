extends Area2D

func _on_Area2D_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		if event.pos.x < self.get_pos().x:
			print("left")
		else:
			print("right")
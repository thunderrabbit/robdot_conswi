extends Node

var board = {}			# board of slots_across x slots_down

# width and height of level board
var slots_across
var slots_down

func _ready():
	board = {}

# clear the visual board; prepare the Dictionary board{}
func clear_game_board():
	# clear block sprites if existing
	var existing_sprites = get_node(".").get_children()
	for sprite in existing_sprites:
		sprite.queue_free()

	board = {}
	for i in range(slots_across):
		for j in range(slots_down):
			board[Vector2(i, j)] = null

func magnetism_called():
	for pos in board:
		var sprite = board[pos]
		if sprite != null:
			sprite.move_down_if_room()

func pixels_to_slot(pixels):
	return Vector2((pixels.x - G.GLOBALleft_space) / (G.SLOT_SIZE + G.GLOBALslot_gap_h),
					(pixels.y - G.GLOBALtop_space) / (G.SLOT_SIZE + G.GLOBALslot_gap_v))

func slot_to_pixels(slot):
	return Vector2(G.GLOBALleft_space+(G.SLOT_SIZE + G.GLOBALslot_gap_h)*(slot.x), 
				    G.GLOBALtop_space+(G.SLOT_SIZE + G.GLOBALslot_gap_v)*(slot.y))

func steering_pad_pixels():
	return Vector2(G.GLOBALleft_space+(G.SLOT_SIZE + G.GLOBALslot_gap_h)*(slots_across / 2), 
				    G.GLOBALtop_space+(G.SLOT_SIZE + G.GLOBALslot_gap_v)*(slots_down))


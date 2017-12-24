extends Node

const Player = preload("res://SubScenes/Player.gd")

var game_scene			# so we know where Players should appear
var board = {}			# board of slots_across x slots_down

var queue_upcoming = []			# queue of upcoming pieces
var queue_length = 0			# number of pieces to show in the queue

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

func queue_wo_fill():
	while queue_upcoming.size() < queue_length:
		# new player will be a random of four colors
		var new_tile_type_ordinal = ItemDatabase.random_type()		
		var new_player = Player.new()
		# Allow player to add itself to the scene
		new_player.set_game_scene(game_scene)
		# Tell player what type it is
		new_player.set_type(new_tile_type_ordinal)
		queue_upcoming.append(new_player)

func queue_next():
	if queue_upcoming.size() < queue_length:
		queue_wo_fill()
	var next_piece = queue_upcoming.front()
	queue_upcoming.pop_front()
	return next_piece

func instantiatePlayer(player_position):

	game_scene.player = queue_next()

	# Move the player
	game_scene.player.set_position(player_position)

func pixels_to_slot(pixels):
	return Vector2((pixels.x - G.GLOBALleft_space) / (G.SLOT_SIZE + G.GLOBALslot_gap_h),
					(pixels.y - G.GLOBALtop_space) / (G.SLOT_SIZE + G.GLOBALslot_gap_v))

func slot_to_pixels(slot):
	return Vector2(G.GLOBALleft_space+(G.SLOT_SIZE + G.GLOBALslot_gap_h)*(slot.x), 
				    G.GLOBALtop_space+(G.SLOT_SIZE + G.GLOBALslot_gap_v)*(slot.y))

func steering_pad_pixels():
	return Vector2(G.GLOBALleft_space+(G.SLOT_SIZE + G.GLOBALslot_gap_h)*(slots_across / 2), 
				    G.GLOBALtop_space+(G.SLOT_SIZE + G.GLOBALslot_gap_v)*(slots_down))


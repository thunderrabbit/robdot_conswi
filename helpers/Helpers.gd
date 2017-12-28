extends Node

const Player = preload("res://SubScenes/Player.gd")

var game_scene			# so we know where Players should appear
var board = {}			# board of slots_across x slots_down

var queue_upcoming = []			# queue of upcoming pieces
var queue_length = 0			# number of pieces to show in the queue
var max_tiles_avail = 0			# number of tiles available,
								# including queue and fill_board
var upcoming_tiles = []

# width and height of level board
var slots_across = 0
var slots_down = 0
var debug_level = 0

func _ready():
	board = {}

# clear the visual board; prepare the Dictionary board{}
func clear_game_board():
	# clear block sprites if existing
	var existing_players = get_tree().get_nodes_in_group("players")
	for player in existing_players:
		remove_child(player)

	board = {}
	for i in range(slots_across):
		for j in range(slots_down):
			board[Vector2(i, j)] = null

	# empty the queue else we have ghosts when level restarts
	queue_upcoming = []

func magnetism_called():
	for pos in board:
		var sprite = board[pos]
		if sprite != null:
			sprite.move_down_if_room()

func queue_wo_fill():
	while queue_upcoming.size() < queue_length and \
			max_tiles_avail > 0:
		max_tiles_avail = max_tiles_avail - 1
		# new player will be a random of four colors
		var new_tile_type_ordinal = TileDatabase.random_type()	

		if upcoming_tiles.size() > 1:
			new_tile_type_ordinal = upcoming_tiles.front()
			upcoming_tiles.pop_front()

		# debug overwrites everything and just give same tile
		if self.debug_level == 1:
			new_tile_type_ordinal = 0

		var new_player = Player.new()

		# Tell player what type it is
		new_player.set_type(new_tile_type_ordinal)
		add_child(new_player)

		queue_upcoming.append(new_player)

	# Display queued pieces on top right
	var x = slots_across - queue_length
	for tile in queue_upcoming:
		tile.set_position(Vector2(x,0))
		x += 1


func queue_next():
	queue_wo_fill()
	var next_piece = queue_upcoming.front()
	if next_piece != null:
		queue_upcoming.pop_front()
	return next_piece

# grok_level is not well designed in that it probably should *not* grok
# values that are not used outside GameScene.
# I happened to notice that `min_swipe_len` is not here, but works just
# fine because it is only accessed in GameScene via current_level.min_swipe_len
# Similarly, I am going to leave `time_limit_in_sec` out of here
# because I think it will only be used in GameScene
func grok_level(level_info):
	slots_across = level_info.width
	slots_down = level_info.height
	queue_length = level_info.queue_len + 1 # +1 accounts for current player
	debug_level = level_info.debug_level
	max_tiles_avail = level_info.max_tiles_avail
	print(max_tiles_avail, " tiles remain")
	upcoming_tiles = level_info.tiles

func instantiatePlayer(player_position):
	# queue_next returns null if max_tiles_available has been exceeded
	game_scene.player = queue_next()
	if game_scene.player != null:
		# Move the player
		game_scene.player.set_position(player_position)
		return true		# we had tiles available
	else:
		return false	# no more tiles available

func pixels_to_slot(pixels):
	return Vector2((pixels.x - G.GLOBALleft_space) / (G.SLOT_SIZE + G.GLOBALslot_gap_h),
					(pixels.y - G.GLOBALtop_space) / (G.SLOT_SIZE + G.GLOBALslot_gap_v))

func slot_to_pixels(slot):
	return Vector2(G.GLOBALleft_space+(G.SLOT_SIZE + G.GLOBALslot_gap_h)*(slot.x), 
				    G.GLOBALtop_space+(G.SLOT_SIZE + G.GLOBALslot_gap_v)*(slot.y))

func steering_pad_pixels():
	return Vector2(G.GLOBALleft_space+(G.SLOT_SIZE + G.GLOBALslot_gap_h)*(slots_across / 2), 
				    G.GLOBALtop_space+(G.SLOT_SIZE + G.GLOBALslot_gap_v)*(slots_down))


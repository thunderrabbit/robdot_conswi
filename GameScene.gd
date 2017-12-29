extends Node2D

const level_format = "res://levels/%s_%s_%02d.gd"		# normal_welcome_01
const Buttons = preload("res://SubScenes/Buttons.gd")
const LevelRequirements = preload("res://SubScenes/LevelRequirements.tscn")

# gravity is what pulls the piece down slowly
var GRAVITY_TIMEOUT = 1     # fake constant that will change with level
const MIN_TIME  = 0.07		# wait at least this long between processing inputs
const MIN_DROP_MODE_TIME = 0.004   # wait this long between move-down when in drop_mode
# mganetism pulls the pieces down quickly after swipes have erased pieces below them
const MAGNETISM_TIME = 0.004

var current_level	= null	# will hold level definition
var requested_level = 0		# Will be read from level menu
var elapsed_time = 10		# pretend it has been 10 seconds so input can definitely be processed upon start

var input_x_direction	# -1 = left; 0 = stay; 1 = right
var input_y_direction	# -1 = down; 0 = stay; 1 = up, but not implemented
var drop_mode = false   # true = drop the player
var gravity_called = false # true = move down 1 unit via gravity

var player_position			# Vector2 of slot player is in
var player					# Two (2) tiles: (player and shadow)
var buttons					# Steering Pad / Start buttons
var level_reqs				# HUD showing level requirements
var swipe_color = 0				# the color of the current swipe
var swipe_mode= false			# if true, then we are swiping
var swipe_array = []			# the pieces in the swipe

func _ready():
	buttons = Buttons.new()			# Buttons pre/post level
	Helpers.game_scene = self		# so Players know where to appear
	print("Started Game Scene")

	level_reqs = LevelRequirements.instance()
	add_child(level_reqs)

	requested_level = Helpers.requested_level
	# TODO: add START button overlay
	# which will trigger this call:
	requested_play_level(requested_level)

func requested_replay_level():
	requested_play_level(requested_level)

func requested_next_level():
	Helpers.requested_level = Helpers.requested_level + 1
	requested_play_level(Helpers.requested_level)

func requested_play_level(level):
	start_level(level)					# TODO: add level selection screen.  level 0 is my debug 
	new_player()
	# tell the Magnetism timer to call Helpers.magnetism_called (every MAGNETISM_TIME seconds)
	get_node("Magnetism").connect("timeout", get_node("/root/Helpers"), "magnetism_called", [])

# If a too-large level_num is sent, this will
# spin down through smaller numbers to find one.
# Define levels in `levels/` directory
func getExistingLevelGDScript(level_num):
	var level_difficulty = "normal"		# TODO add Settings (same as Helpers.gd) and put "normal" and "welcome" into it
	var level_group = "welcome"			#      Scene > Project Settings > Autoload
	var level_name = ""
	print("starting Level ", level_name)

	var levelGDScript = null
	var sanityCheck = 100
	while levelGDScript == null:
		level_name = level_format % [level_difficulty, level_group, level_num]
		levelGDScript = load(level_name)
		level_num = level_num - 1
		sanityCheck = sanityCheck - 1
		if sanityCheck == 0:
			level_num = 1
		if sanityCheck < 0:
			print("This level name format isn't working ", level_name)
	return levelGDScript

func start_level(level_num):
	var levelGDScript = getExistingLevelGDScript(level_num)
	current_level = levelGDScript.new()		# load() gets a GDScript and new() instantiates it
	# now that we have loaded the level, we can tell the game how it wants us to run
	Helpers.grok_level(current_level)	# so we have level info available everywhere
	GRAVITY_TIMEOUT = current_level.gravity_timeout

	# TODO deal with the case that the current board is smaller then previous level
	# in which case the slots_across will be too small to clear everything
	Helpers.clear_game_board()

	level_reqs.level_requires(current_level.level_requirements)
	# magnetism makes the nailed pieces fall (all pieces in board{})
	start_magnetism()

	# if level timer runs out the level is lost
	start_level_timer()

	# Fill the level halfway, if max_tiles_avail allows it
	if current_level.fill_level:
		fill_game_board()

	# buttons are kinda like a HUD but for input, not output
	buttons.set_game_scene(self)
	add_child(buttons)

	buttons.prepare_to_play_level(level_num)

	if Helpers.debug_level == 0:
		get_node("/root/GameScene/DebugOutput").hide()

func fill_game_board():
	print("filling level")

	# top corner is 0,0
	for across in range(Helpers.slots_across):
		for down in range(Helpers.slots_down/2, Helpers.slots_down):
			player_position = Vector2(across, down)

			if Helpers.instantiatePlayer(player_position):
				# lock player into position on Helpers.board{}
				nail_player()
			else:
				print("no more tiles available!")

func new_player():
	# turn off drop mode
	drop_mode = false
	stop_moving()

	# select top center position
	player_position = Vector2(Helpers.slots_across/2, 0)
	# check game over
	if Helpers.board[Vector2(player_position.x, player_position.y)] != null:
		level_over(G.LEVEL_NO_ROOM)
		return

	if Helpers.instantiatePlayer(player_position):
		player.set_show_shadow(true)
		set_process(true)		# allows players to be moved
		start_gravity_timer()
	else:
		print("no more tiles available!")

func level_over(reason):
	# gray out block sprites if existing
	stop_magnetism()
	stop_gravity_timer()
	stop_level_timer()
	var existing_sprites = get_tree().get_nodes_in_group("players")
	for sprite in existing_sprites:
		sprite.level_ended()
	buttons.level_ended(reason)

# this is only to handle orphaned swipes
func _on_Orphan_Swipe_Catcher_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT:
		if event.pressed:
			pass
		else: # not event.pressed:
			piece_unclicked()

func _process(delta):

	if gravity_called:
		input_y_direction = 1

	# if it has not been long enough, get out of here
	if (not drop_mode and elapsed_time < MIN_TIME) or (drop_mode and elapsed_time < MIN_DROP_MODE_TIME):
		elapsed_time += delta
		return

	# it has been long enough, so reset the timer before processing
	elapsed_time = 0

	if drop_mode:
		# turn on drop mode
		input_y_direction = 1

	# if we can move, move
	if check_movable(input_x_direction, 0):
		move_player(input_x_direction, 0)
	elif check_movable(0, input_y_direction):
		move_player(0, input_y_direction)
	else:
		if input_y_direction > 0:
			nail_player()
			new_player()

	# now that gravity has done its job, we can turn it off
	if gravity_called:
		input_y_direction = 0
		gravity_called = false

func check_movable(x, y):
	# x is side to side motion.  -1 = left   1 = right
	if x == -1 or x == 1:
		# check border
		if player_position.x + x >= Helpers.slots_across or player_position.x + x < 0:
			return false
		# check collision
		if Helpers.board[Vector2(player_position.x+x, player_position.y)] != null:
			return false
		return true
	# y is up down motion.  1 = down     -1 = up, but key is not connected
	if y == -1 or y == 1:
		# check border
		if player_position.y + y >= Helpers.slots_down or player_position.y + y < 0:
			return false
		if Helpers.board[Vector2(player_position.x, player_position.y+1)] != null:
			return false
		return true

func stop_moving():
	input_x_direction = 0
	input_y_direction = 0

func _gravity_says_its_time():
	gravity_called = true

func start_gravity_timer():
	var le_timer = get_node("GravityTimer")
	le_timer.set_wait_time(GRAVITY_TIMEOUT)
	le_timer.start()

func stop_gravity_timer():
	var le_timer = get_node("GravityTimer")
	le_timer.stop()

func start_level_timer():
	var le_timer = get_node("LevelTimer")
	le_timer.set_wait_time(current_level.time_limit_in_sec)
	le_timer.start()

func stop_level_timer():
	var le_timer = get_node("LevelTimer")
	le_timer.stop()

func start_magnetism():
	var magneto = get_node("Magnetism")
	magneto.set_wait_time(MAGNETISM_TIME)
	magneto.start()

func stop_magnetism():
	var magneto = get_node("Magnetism")
	magneto.stop()

# move player
func move_player(x, y):
	player_position.x += x
	player_position.y += y
	player.set_position(player_position)

# nail player to board
func nail_player():
	set_process(false)			# disable motion until next player is created
	set_process_input(false)	# ignore touches until next player is created
	stop_gravity_timer()
	player.nail_player()		# let player do what it needs when it's nailed

	# tell board{} where the player is
	Helpers.board[Vector2(player_position.x, player_position.y)] = player		## this is the piece so we can find it later

func piece_clicked(position, piece_type):
	swipe_color = piece_type
	swipe_mode = true
	swipe_array.append(position)
	Helpers.board[position].highlight()

func piece_unclicked():
	if swipe_array.size() < current_level.min_swipe_len:
		for pos in swipe_array:
			Helpers.board[pos].unhighlight()
	else:
		if Helpers.debug_level > 0:
			ShapeShifter.givenSwipe_showArray(swipe_array)
		var swipe_name = ShapeShifter.givenSwipe_lookupName(swipe_array)
		level_reqs.swiped_piece(swipe_name)

		for pos in swipe_array:
			if Helpers.board[pos] != null:
				Helpers.board[pos].remove_yourself()
	swipe_array.clear()
	swipe_mode = false

func piece_entered(position, piece_type):
	if not swipe_mode:
		return
	if swipe_color != piece_type:
		return
	# ensure the position is adjacent to the last item in the array
	if not adjacent(swipe_array.back(), position):
		return
	if position == swipe_array[swipe_array.size()-2]:
		# we back tracked
		var old_last = swipe_array.back()
		swipe_array.pop_back()
		Helpers.board[old_last].unhighlight()
	else:
		swipe_array.append(position)
		Helpers.board[position].highlight()

func adjacent(pos1, pos2):
	# https://www.gamedev.net/forums/topic/516685-best-algorithm-to-find-adjacent-tiles/?tab=comments#comment-4359055
	var xOffsets = [ 0, 1, 0, -1]
	var yOffsets = [-1, 0, 1,  0]

	var i = 0
	var offset_pos2 = Vector2(-99,-99)
	while i < xOffsets.size():
		offset_pos2 = Vector2(pos2.x + xOffsets[i], pos2.y + yOffsets[i])
		if pos1 == offset_pos2:
			return true
		i = i + 1
	return false

func piece_exited(position, piece_type):
	pass

func _on_LevelWon():
	print("Apparenlty we won")
	level_over(G.LEVEL_WIN)

func _on_LevelTimer_timeout():
	level_over(G.LEVEL_NO_TIME)

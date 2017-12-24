extends Node2D

const level_format = "res://levels/%s_%s_%02d.gd"		# normal_welcome_01
const Buttons = preload("res://SubScenes/Buttons.gd")

# gravity is what pulls the piece down slowly
var GRAVITY_TIMEOUT = 1     # fake constant that will change with level
const MIN_TIME  = 0.07		# wait at least this long between processing inputs
const MIN_DROP_MODE_TIME = 0.004   # wait this long between move-down when in drop_mode
# mganetism pulls the pieces down quickly after swipes have erased pieces below them
const MAGNETISM_TIME = 0.004

var current_level	= null	# will hold level definition

var elapsed_time = 10		# pretend it has been 10 seconds so input can definitely be processed upon start

var input_x_direction	# -1 = left; 0 = stay; 1 = right
var input_y_direction	# -1 = down; 0 = stay; 1 = up, but not implemented
var drop_mode = false   # true = drop the player
var gravity_called = false # true = move down 1 unit via gravity

var player_position			# Vector2 of slot player is in
var player					# Two (2) tiles: (player and shadow)
var buttons					# Steering Pad / Start buttons

var swipe_color = 0				# the color of the current swipe
var swipe_mode= false			# if true, then we are swiping
var swipe_array = []			# the pieces in the swipe

func _ready():
	buttons = Buttons.new()			# TODO: add level restart button after lose level
	Helpers.game_scene = self		# so Players know where to appear
	print("Started Game Scene")
	start_level(0)					# TODO: add level selection screen.  level 0 is my debug 
	new_player()
	# tell the Magnetism timer to call Helpers.magnetism_called (every MAGNETISM_TIME seconds)
	get_node("Magnetism").connect("timeout", get_node("/root/Helpers"), "magnetism_called", [])


func start_level(level_num):
	var level_difficulty = "normal"		# TODO add Settings (same as Helpers.gd) and put "normal" and "welcome" into it
	var level_group = "welcome"			#      Scene > Project Settings > Autoload
	var level_name = level_format % [level_difficulty, level_group, level_num]
	print("starting Level ", level_name)

	current_level = load(level_name).new()		# load() gets a GDScript and new() instantiates it
	# now that we have loaded the level, we can tell the game how it wants us to run
	Helpers.slots_across = current_level.level_width()
	Helpers.slots_down = current_level.level_height()
	GRAVITY_TIMEOUT = current_level.gravity_timeout
	Helpers.queue_length = current_level.queue_len + 1 # +1 accounts for current player)

	# TODO deal with the case that the current board is smaller then previous level
	# in which case the slots_across will be too small to clear everything
	Helpers.clear_game_board()

	# magnetism makes the nailed pieces fall (all pieces in board{})
	start_magnetism()
	
	# TODO consider allowing the level definition to specify exactly
	# what pieces to place on the board when starting
	if current_level.fill_level:
		fill_game_board()

	# buttons are kinda like a HUD but for input, not output
	buttons.set_game_scene(self)

	# the steering pad is the left/right buttons at bottom
	buttons.add_steering_pad()

func fill_game_board():
	print("filling level")

	# top corner is 0,0
	for across in range(Helpers.slots_across):
		for down in range(Helpers.slots_down/2, Helpers.slots_down):
			player_position = Vector2(across, down)
	

			Helpers.instantiatePlayer(player_position)

			# lock player into position on Helpers.board{}
			nail_player()

func new_player():
	# turn off drop mode
	drop_mode = false
	stop_moving()

	# select top center position
	player_position = Vector2(Helpers.slots_across/2, 0)
	# check game over
	if Helpers.board[Vector2(player_position.x, player_position.y)] != null:
		level_over()
		return

	Helpers.instantiatePlayer(player_position)
	player.set_show_shadow(true)
	set_process(true)		# allows players to be moved
	start_gravity_timer()


func level_over():
	# gray out block sprites if existing
	stop_magnetism()
	var existing_sprites = get_node(".").get_children()
	for sprite in existing_sprites:
		# do not remove slots from board
		if "is_a_game_piece" in sprite:
			## I have no idea why .get_node("TileSprite") is null sometimes
			## It seems to be related to queue_freeing the shadow sprite
			if sprite.get_node("TileSprite") != null:
				sprite.get_node("TileSprite").set_modulate(Color(0.1,0.1,0.1, 1))

# this is only to handle orphaned swipes
func _on_Orphan_Swipe_Catcher_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT:
		if event.pressed:
			print("mouse clicked ", Helpers.pixels_to_slot(get_pos()))
		else: # not event.pressed:
			print("mouse unclicked")
			piece_unclicked("need not","send thises")

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
			print("nailed")
			nail_player()
			new_player()

	# now that gravity has done its job, we can turn it off
	if gravity_called:
		input_y_direction = 0
		gravity_called = false

func check_movable(x, y):
#	print("can we move (",x,",",y,")?")
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
	var le_timer = get_node("Timer")
	le_timer.set_wait_time(GRAVITY_TIMEOUT)
	le_timer.start()

func stop_gravity_timer():
	var le_timer = get_node("Timer")
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
	print("piece clicked", position, piece_type)

func piece_unclicked(position, piece_type):
	if swipe_array.size() < current_level.min_swipe_len:
		for pos in swipe_array:
			Helpers.board[pos].unhighlight()
	else:
		for pos in swipe_array:
			if Helpers.board[pos] != null:
				Helpers.board[pos].remove_yourself()
	swipe_array.clear()
	swipe_mode = false
	print("piece unclicked", position, piece_type)

func piece_entered(position, piece_type):
	if not swipe_mode:
		print("not swipe mode")
		return
	if swipe_color != piece_type:
		print(piece_type, " is not color ", swipe_color)
		return
	# ensure the position is adjacent to the last item in the array
	if not adjacent(swipe_array.back(), position):
		print("not adjacent")
		return
	if position == swipe_array[swipe_array.size()-2]:
		# we back tracked
		var old_last = swipe_array.back()
		swipe_array.pop_back()
		Helpers.board[old_last].unhighlight()
		print("piece backtracked", old_last)
	else:
		swipe_array.append(position)
		Helpers.board[position].highlight()
		print("piece entered", position, piece_type)

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
	print("piece exited", position, piece_type)

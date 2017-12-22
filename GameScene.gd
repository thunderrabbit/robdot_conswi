extends Node2D

const level_format = "res://levels/%s_%s_%02d.gd"		# normal_welcome_01
const Player = preload("res://SubScenes/Player.gd")
const Buttons = preload("res://SubScenes/Buttons.gd")

var GRAVITY_TIMEOUT = 10     # fake constant that will change with level
const MIN_TIME  = 0.07		# wait at least this long between processing inputs
const MIN_DROP_MODE_TIME = 0.004

var elapsed_time = 10		# pretend it has been 10 seconds so input can definitely be processed upon start

var input_x_direction	# -1 = left; 0 = stay; 1 = right
var input_y_direction	# -1 = down; 0 = stay; 1 = up, but not implemented
var drop_mode = false   # true = drop the player
var gravity_called = false # true = move down 1 unit via gravity

var player_position			# Vector2 of slot player is in
var player					# Two (2) tiles: (player and shadow)
var buttons					# Steering Pad / Start buttons

func _ready():
	buttons = Buttons.new()
	print("Started Game Scene")
	start_level(1)
	new_player()


func start_level(level_num):
	var level_difficulty = "normal"
	var level_group = "welcome"
	var level_name = level_format % [level_difficulty, level_group, level_num]
	print("starting Level ", level_name)

	var current_level = load(level_name).new()		# load() gets a GDScript and new() instantiates it
	Helpers.slots_across = current_level.level_width()
	Helpers.slots_down = current_level.level_height()
	# TODO deal with the case that the current board is smaller then previous level
	# in which case the slots_across will be too small to clear everything
	Helpers.clear_game_board()
	buttons.set_game_scene(self)
	buttons.add_steering_pad()

func new_player():
	# turn off drop mode
	drop_mode = false
	stop_moving()

	# select top center position
	player_position = Vector2(Helpers.slots_across/2, 0)
	# check game over
	if Helpers.board[Vector2(player_position.x, player_position.y)] != null:
		game_over()
		return

	# new player will be a random of four colors
	var new_tile_type_ordinal = ItemDatabase.random_type()

	instantiatePlayer(new_tile_type_ordinal, player_position)
	set_process(true)
	start_gravity_timer()

func instantiatePlayer(new_tile_type_ordinal, player_position):
	player = Player.new()

	# Allow player to add itself to the scene
	player.set_game_scene(self)

	# Tell player what type it is
	player.set_type(new_tile_type_ordinal)

	# Move the player
	player.set_position(player_position)

func game_over():
	# gray out block sprites if existing
	var existing_sprites = get_node(".").get_children()
	for sprite in existing_sprites:
		# do not remove slots from board
		if "is_a_game_piece" in sprite:
			## I have no idea why .get_node("TileSprite") is null sometimes
			## It seems to be related to queue_freeing the shadow sprite
			if sprite.get_node("TileSprite") != null:
				sprite.get_node("TileSprite").set_modulate(Color(0.1,0.1,0.1, 1))

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

# move player
func move_player(x, y):
	player_position.x += x
	player_position.y += y
	player.set_position(player_position)

# nail player to board
func nail_player():
	set_process(false)			# deactivate _process
	set_process_input(false)	# deactivate _input
	stop_gravity_timer()
	player.nail_player()		# let player do what it needs when it's nailed

	# tell board{} where the player is
	Helpers.board[Vector2(player_position.x, player_position.y)] = true		## this was the piece, but it just needs to be not null


extends Node2D

const level_format = "res://levels/%s_%s_%02d.gd"		# normal_welcome_01
const Player = preload("res://SubScenes/Player.gd")

var player_position			# Vector2 of slot player is in
var player					# Two (2) tiles: (player and shadow)

func _ready():
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


func new_player():
	# new player will be a random of four colors
	var new_tile_type_ordinal = ItemDatabase.random_type()

	# select top center position
	player_position = Vector2(Helpers.slots_across/2, 0)

	player = Player.new()

	# Allow player to add itself to the scene
	player.set_game_scene(self)

	# Tell player what type it is
	player.set_type(new_tile_type_ordinal)

	# check game over
	if Helpers.board[Vector2(player_position.x, player_position.y)] != null:
		game_over()
		return		
	
	# Move the player
	player.set_position(player_position)
		

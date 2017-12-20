extends Node2D

var Tile = preload("res://SubScenes/Tile.tscn")
const level_format = "res://levels/%s_%s_%02d.gd"		# normal_welcome_01

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
	print(current_level.width)

func new_player():
	# new player will be a random of four colors
	var new_tile_type_ordinal = ItemDatabase.random_type()

	# insantiate new Tile to be our player
	var tile = Tile.instance()

	# randomly choose Tile type (dog, cat, pig, etc)
	tile.set_tile_type(new_tile_type_ordinal)

	# add Tile to scene
	add_child(tile)

	tile.set_pos(Vector2(100,100))		## temporary hardcode until we have game dimensions

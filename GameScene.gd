extends Node2D

var Tile = preload("res://SubScenes/Tile.tscn")

func _ready():
	print("Started Game Scene")
	new_player()

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

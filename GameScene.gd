extends Node2D

var Tile = preload("res://SubScenes/Tile.tscn")

func _ready():
	print("Started Game Scene")

	# new player will be a random of four colors
	var new_tile_type_ordinal = ItemDatabase.random_type()

	var tile = Tile.instance()

	tile.set_tile_type(new_tile_type_ordinal)

	add_child(tile)

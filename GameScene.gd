extends Node2D

var Tile = preload("res://SubScenes/Tile.tscn")

func _ready():
	print("Started Game Scene")
	var tile = Tile.instance()

	add_child(tile)

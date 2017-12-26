extends Node

const ITEM_NAME         = 0
const ITEM_SPRITE       = 3

var TileDatabase = [
	{
		ITEM_NAME : "Dog",
		ITEM_SPRITE : 0
	},
	{
		ITEM_NAME : "Cat",
		ITEM_SPRITE : 1
	},
	{
		ITEM_NAME : "Pig",
		ITEM_SPRITE : 2
	},
	{
		ITEM_NAME : "Sheep",
		ITEM_SPRITE : 3
	}
]

func _ready():
	randomize()

func random_type():
	return randi() % TileDatabase.size()


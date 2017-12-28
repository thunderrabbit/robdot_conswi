extends Node

const ITEM_NAME         = 0
const ITEM_SPRITE       = 3

var TileDatabase = [
	{
		ITEM_NAME : "Dog",
		ITEM_SPRITE : G.TYPE_DOG
	},
	{
		ITEM_NAME : "Cat",
		ITEM_SPRITE : G.TYPE_CAT
	},
	{
		ITEM_NAME : "Pig",
		ITEM_SPRITE : G.TYPE_PIG
	},
	{
		ITEM_NAME : "Sheep",
		ITEM_SPRITE : G.TYPE_SHEEP
	}
]

func _ready():
	randomize()

func random_type():
	return randi() % TileDatabase.size()


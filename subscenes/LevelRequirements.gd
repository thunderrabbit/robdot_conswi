extends Node2D

signal levelwon

var requirements = {}

func _ready():
	var gameScene = get_node("/root/GameScene")
	connect("levelwon", gameScene, "_on_LevelWon")

func level_requires(level_requirements):
	requirements = level_requirements
	_display_requirements()

func _display_requirements():
	print("level requires")
	print(requirements)

func swiped_piece(piece_name):
	var num_required = 0
	if requirements.has(piece_name):
		num_required = requirements[piece_name]
	print("%d %s required" %[num_required, piece_name])
	if num_required > 0:
		requirements[piece_name] = num_required - 1
	clarify_requirements()

# See if we won
func clarify_requirements():
	for name in requirements:
		if requirements[name] == 0:
			requirements.erase(name)
	if requirements.empty():
		print("We won!!")
		emit_signal("levelwon")

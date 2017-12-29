extends Node2D

var game_scene

func set_game_scene(my_game_scene):
	game_scene = my_game_scene

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func level_over_reason(reason):
	print(reason)
	if reason == G.LEVEL_WIN:
		get_node("LevelOverTitle").set_texture(preload("res://images/buttons/you_win.png"))
	if reason == G.LEVEL_NO_ROOM:
		get_node("LevelOverTitle").set_texture(preload("res://images/buttons/no_room.png"))
	if reason == G.LEVEL_NO_TIME:
		get_node("LevelOverTitle").set_texture(preload("res://images/buttons/time_up.png"))
	if reason == G.LEVEL_NO_TILES:
		get_node("LevelOverTitle").set_texture(preload("res://images/buttons/no_tiles.png"))

func _on_TryAgain_pressed():
	game_scene.requested_replay_level()
extends ButtonGroup

var game_scene

func set_game_scene(my_game_scene):
	game_scene = my_game_scene

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_replay_pressed():
	game_scene.requested_replay_level()

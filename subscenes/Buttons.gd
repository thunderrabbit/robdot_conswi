extends Node

var SteeringPad = preload("res://SubScenes/SteeringPad.tscn")
var EndLevelBut = preload("res://SubScenes/LevelEndedButtons.tscn")
var parent_scene

func set_game_scene(game_scene):
	parent_scene = game_scene

func add_steering_pad():
	var steering_pad = SteeringPad.instance()
	steering_pad.set_pos(Helpers.steering_pad_pixels())
	steering_pad.set_game_scene(parent_scene)
	parent_scene.add_child(steering_pad)

func display_level_end_buttons():
	var endLevelButtons = EndLevelBut.instance()
	endLevelButtons.set_alignment(endLevelButtons.ALIGN_CENTER)
	parent_scene.add_child(endLevelButtons)
extends Node

var SteeringPad = preload("res://SubScenes/SteeringPad.tscn")
var parent_scene

func set_game_scene(game_scene):
	parent_scene = game_scene

func add_steering_pad():
	var steering_pad = SteeringPad.instance()
	steering_pad.set_pos(Helpers.steering_pad_pixels())
	print("setting scene" , parent_scene)
	steering_pad.set_game_scene(parent_scene)
	parent_scene.add_child(steering_pad)

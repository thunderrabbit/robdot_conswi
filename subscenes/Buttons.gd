extends Node

var SteeringPad = preload("res://SubScenes/SteeringPad.tscn")
var parent_scene

func set_game_scene(game_scene):
	parent_scene = game_scene

func add_steering_pad():
	var steering_pad = SteeringPad.instance()
	parent_scene.add_child(steering_pad)

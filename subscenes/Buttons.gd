extends Node

const SteeringPad = preload("res://SubScenes/SteeringPad.tscn")
const EndLevelBut = preload("res://SubScenes/LevelEndedButtons.tscn")
var parent_scene
var endLevelButtons = null
var steering_pad = null

func set_game_scene(game_scene):
	parent_scene = game_scene

func prepare_to_play_level(level):
	print("buttons preparing for level ", level)
	# the steering pad is the left/right buttons at bottom
	self.add_steering_pad()
	if self.endLevelButtons != null:
		self.endLevelButtons.queue_free()

func add_steering_pad():
	steering_pad = SteeringPad.instance()
	steering_pad.set_pos(Helpers.steering_pad_pixels())
	steering_pad.set_game_scene(parent_scene)
	parent_scene.add_child(steering_pad)

func level_ended():
	steering_pad.queue_free()
	_display_level_end_buttons()

func _display_level_end_buttons():
	endLevelButtons = EndLevelBut.instance()
	endLevelButtons.set_alignment(endLevelButtons.ALIGN_CENTER)
	endLevelButtons.set_game_scene(parent_scene)
	parent_scene.add_child(endLevelButtons)

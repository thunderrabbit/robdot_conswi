extends Node2D

var Tile = preload("res://SubScenes/Tile.tscn")
const level_format = "res://levels/%s_%s_%02d.gd"		# normal_welcome_01

# width and height of level board
var slots_across
var slots_down
var player_position			# Vector2 of slot player is in

##  http://www.gamefromscratch.com/post/2015/02/23/Godot-Engine-Tutorial-Part-6-Multiple-Scenes-and-Global-Variables.aspx
var GLOBALtop_space = 30		# Might just move the Popup down instead
var GLOBALleft_space = 10		# Space on the left
var GLOBALslot_gap_v = 5
var GLOBALslot_gap_h = 5
const SLOT_SIZE = 52

func _ready():
	print("Started Game Scene")
	start_level(1)
	new_player()

func start_level(level_num):
	var level_difficulty = "normal"
	var level_group = "welcome"
	var level_name = level_format % [level_difficulty, level_group, level_num]
	print("starting Level ", level_name)

	var current_level = load(level_name).new()		# load() gets a GDScript and new() instantiates it
	slots_across = current_level.level_width()
	slots_down = current_level.level_height()

func pixels_to_slot(pixels):
	return Vector2((pixels.x - GLOBALleft_space) / (SLOT_SIZE + GLOBALslot_gap_h),
					(pixels.y - GLOBALtop_space) / (SLOT_SIZE + GLOBALslot_gap_v))

func slot_to_pixels(slot):
	return Vector2(GLOBALleft_space+(SLOT_SIZE + GLOBALslot_gap_h)*(slot.x), 
				    GLOBALtop_space+(SLOT_SIZE + GLOBALslot_gap_v)*(slot.y))

func new_player():
	# new player will be a random of four colors
	var new_tile_type_ordinal = ItemDatabase.random_type()

	# insantiate new Tile to be our player
	var tile = Tile.instance()

	# randomly choose Tile type (dog, cat, pig, etc)
	tile.set_tile_type(new_tile_type_ordinal)

	# select top center position
	player_position = Vector2(slots_across/2, 0)

	# add Tile to scene
	add_child(tile)

	tile.set_pos(slot_to_pixels(player_position))
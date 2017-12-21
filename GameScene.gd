extends Node2D

var Tile = preload("res://SubScenes/Tile.tscn")
const level_format = "res://levels/%s_%s_%02d.gd"		# normal_welcome_01

var board = {}			# board of slots_across x slots_down

# width and height of level board
var slots_across
var slots_down
var player_position			# Vector2 of slot player is in
var player_tile_y_shadow	# Will hold the player and shadow while in motion

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
	# TODO deal with the case that the current board is smaller then previous level
	# in which case the slots_across will be too small to clear everything
	clear_game_board()

# clear the visual board; prepare the Dictionary board{}
func clear_game_board():
	# clear block sprites if existing
	var existing_sprites = get_node(".").get_children()
	for sprite in existing_sprites:
		sprite.queue_free()

	board = {}
	for i in range(slots_across):
		for j in range(slots_down):
			board[Vector2(i, j)] = null


func pixels_to_slot(pixels):
	return Vector2((pixels.x - GLOBALleft_space) / (SLOT_SIZE + GLOBALslot_gap_h),
					(pixels.y - GLOBALtop_space) / (SLOT_SIZE + GLOBALslot_gap_v))

func slot_to_pixels(slot):
	return Vector2(GLOBALleft_space+(SLOT_SIZE + GLOBALslot_gap_h)*(slot.x), 
				    GLOBALtop_space+(SLOT_SIZE + GLOBALslot_gap_v)*(slot.y))

func new_player():
	# new player will be a random of four colors
	var new_tile_type_ordinal = ItemDatabase.random_type()

	# select top center position
	player_position = Vector2(slots_across/2, 0)

	# array to hold both parts of our player
	player_tile_y_shadow = []

	# instantiate 1 Tile each for our player and shadow.  i is unused here
	for i in range(2):
		# insantiate new Tile to be our player
		var tile = Tile.instance()

		# randomly choose Tile type (dog, cat, pig, etc)
		tile.set_tile_type(new_tile_type_ordinal)

		# keep it in player_sprites so we can find them later
		player_tile_y_shadow.append(tile)
	
		# add Tile to scene
		add_child(tile)
	
	# now arrange the blocks making up this player in the right shape
	update_player_sprites(player_tile_y_shadow)

	# check game over
	if board[Vector2(player_position.x, player_position.y)] != null:
		game_over()
		return		
		
# update player sprite display
func update_player_sprites(tile_y_shadow):
	tile_y_shadow[0].set_pos(slot_to_pixels(player_position))
	tile_y_shadow[1].set_pos(slot_to_pixels(Vector2(player_position.x, column_height(player_position.x))))   ## shadow
	tile_y_shadow[1].get_node("TileSprite").set_modulate(Color(1,1,1, 0.3))
	
func column_height(column):
	var height = slots_down-1
	for i in range(slots_down-1,0,-1):
		if board[Vector2(column, i)] != null:
			height = i-1
	return height

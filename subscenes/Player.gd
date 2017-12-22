extends Node

var Tile = preload("res://SubScenes/Tile.tscn")

var tile_y_shadow = []	# Will hold the player and shadow while in motion
var parent_scene
var my_position

func _ready():
	# array to hold both parts of our player
	tile_y_shadow = []

func set_type(new_tile_type_ordinal):
	# instantiate 1 Tile each for our player and shadow.  i is unused here
	for i in range(2):
		# insantiate new Tile to be our player
		var tile = Tile.instance()
		# randomly choose Tile type (dog, cat, pig, etc)
		tile.set_tile_type(new_tile_type_ordinal)
		# keep it in player_sprites so we can find them later
		tile_y_shadow.append(tile)
		# add Tile to scene
		parent_scene.add_child(tile)

	# remove collider from shadow so it ignores mouse
	tile_y_shadow[1].get_node("CollisionShape2D").queue_free()

func set_game_scene(game_scene):
	parent_scene = game_scene

# update player sprite display
func set_position(player_position):
	my_position = player_position
	tile_y_shadow[0].set_pos(Helpers.slot_to_pixels(player_position))
	tile_y_shadow[1].set_pos(Helpers.slot_to_pixels(Vector2(player_position.x, column_height(player_position.x))))   ## shadow
	tile_y_shadow[1].get_node("TileSprite").set_modulate(Color(1,1,1, 0.3))

# player has been nailed so it should animate or whatever
func nail_player():
	# remove player's shadow
	tile_y_shadow[1].get_node("TileSprite").queue_free()
	pass
	
func column_height(column):
	var height = Helpers.slots_down-1
	for i in range(Helpers.slots_down-1,0,-1):
		if Helpers.board[Vector2(column, i)] != null:
			height = i-1
	return height

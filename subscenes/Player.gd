extends Node

const Tile = preload("res://SubScenes/Tile.tscn")

var mytile = null	# visible in queue, while moving, when nailed
var myshadow = null	# only visible when moving
var parent_scene
var my_position
var should_show_shadow = false
var nailed = false

func _ready():
	# array to hold both parts of our player
	tile_y_shadow = []
	set_process_input(false)

func set_type(new_tile_type_ordinal):
	# instantiate 1 Tile each for our player and shadow.  i is unused here
	for i in range(2):
		# insantiate new Tile to be our player
		var tile = Tile.instance()
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
	if not nailed:
		tile_y_shadow[1].set_pos(Helpers.slot_to_pixels(Vector2(player_position.x, column_height(player_position.x))))   ## shadow
		var shadow = tile_y_shadow[1].get_node("TileSprite")
		if shadow != null:
			if should_show_shadow:
				shadow.show()
				shadow.set_modulate(Color(1,1,1, 0.3))
			else:
				shadow.hide()

# player has been nailed so it should animate or whatever
func nail_player():
	# remove player's shadow
	tile_y_shadow[0].become_swipable()
	tile_y_shadow[1].get_node("TileSprite").queue_free()
	nailed = true
	pass
	
func column_height(column):
	var height = Helpers.slots_down-1
	for i in range(Helpers.slots_down-1,0,-1):
		if Helpers.board[Vector2(column, i)] != null:
			height = i-1
	return height

func move_down_if_room():
	var below_me = my_position + Vector2(0,1)
	if below_me.y < Helpers.slots_down:
		if Helpers.board[below_me] == null:
			Helpers.board[below_me] = self
			Helpers.board[my_position] = null
			set_position(below_me)

func set_show_shadow(should_i):
	should_show_shadow = should_i
	# set position forces shdadow to show up or not
	set_position(my_position)

func highlight():
	tile_y_shadow[0].my_sprite.highlight()

func unhighlight():
	tile_y_shadow[0].my_sprite.unhighlight()

func remove_yourself():
	Helpers.board[my_position] = null
	tile_y_shadow[0].queue_free()
	tile_y_shadow[1].queue_free()		# release shadow

extends Node

const Tile = preload("res://SubScenes/Tile.tscn")

var mytile = null	# visible in queue, while moving, when nailed
var myshadow = null	# only visible when moving
var parent_scene
var my_position
var should_show_shadow = false
var nailed = false

func _ready():
	add_to_group("players")		# to simplify clearing game scene
	set_process_input(false)

func set_type(new_tile_type_ordinal):
	# instantiate 1 Tile each for our player and shadow.
	mytile = Tile.instance()
	mytile.set_tile_type(new_tile_type_ordinal)
	# add Tile to scene
	add_child(mytile)

	myshadow = Tile.instance()
	myshadow.set_tile_type(new_tile_type_ordinal)
	# remove collider from shadow so it ignores mouse
	myshadow.get_node("CollisionShape2D").queue_free()
	add_child(myshadow)

func set_game_scene(game_scene):
	parent_scene = game_scene
	parent_scene.add_child(self)

# update player sprite display
func set_position(player_position):
	my_position = player_position
	mytile.set_pos(Helpers.slot_to_pixels(player_position))
	if not nailed:
		myshadow.set_pos(Helpers.slot_to_pixels(Vector2(player_position.x, column_height(player_position.x))))   ## shadow
	#	var shadowsprite = myshadow.get_node("TileSprite")
		if myshadow.my_sprite != null:
			if should_show_shadow:
				myshadow.my_sprite.show()
				myshadow.my_sprite.set_modulate(Color(1,1,1, 0.3))
			else:
				myshadow.my_sprite.hide()

# player has been nailed so it should animate or whatever
func nail_player():
	# remove player's shadow
	mytile.become_swipable()
	myshadow.queue_free()
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
	mytile.my_sprite.highlight()

func unhighlight():
	mytile.my_sprite.unhighlight()

func darken():
	mytile.my_sprite.darken()
	mytile.get_node("CollisionShape2D").queue_free()

func level_ended():
	darken()

func remove_yourself():
	Helpers.board[my_position] = null
	queue_free()		# release yourself

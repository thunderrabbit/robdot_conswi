extends Node2D

# These are basically the same names as in Globals.gd
# But I am not sure if those Globals are useful for GameScene,
# much less this scene.  I am just creating class vars
# here so it is clear that they are only used here.
# Feel free to arrange these buttons in a better way.

const SLOT_SIZE       = 50
var left_space        = 0
var top_space         = 0
var slot_gap          = 15
var slot_gap_h        = slot_gap
var slot_gap_v        = slot_gap
var buttons_across    = 5

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func level_to_pixels(level):
    var slot = Vector2(level / buttons_across, level % buttons_across)
    return Vector2(left_space+(SLOT_SIZE + slot_gap_h)*(slot.x), 
                    top_space+(SLOT_SIZE + slot_gap_v)*(slot.y))

func _on_Button_pressed():
    get_node("/root/SceneChanger").goto_scene("res://GameScene.tscn")

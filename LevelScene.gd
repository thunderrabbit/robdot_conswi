extends Node2D

# These are basically the same names as in Globals.gd
# But I am not sure if those Globals are useful for GameScene,
# much less this scene.  I am just creating class vars
# here so it is clear that they are only used here.
# Feel free to arrange these buttons in a better way.

const SLOT_SIZE       = 70
var left_space        = 30
var top_space         = 30
var slot_gap          = 35
var slot_gap_h        = slot_gap
var slot_gap_v        = slot_gap
var buttons_across    = 5

func _ready():
    var button_loc = Vector2(0,0)
    for level in range(50):
        button_loc = level_to_pixels(level)
        print(button_loc)
        var level_but = Button.new()
        level_but.set_pos(button_loc)
        level_but.set_text(String(level))
        level_but.set_size(Vector2(SLOT_SIZE,SLOT_SIZE))
        level_but.connect("pressed",self,"_on_Button_pressed",[level])
        add_child(level_but)

func level_to_pixels(level):
    var slot = Vector2(level % buttons_across, level / buttons_across)
    return Vector2(left_space+(SLOT_SIZE + slot_gap_h)*(slot.x), 
                    top_space+(SLOT_SIZE + slot_gap_v)*(slot.y))

func _on_Button_pressed(level):
    Helpers.requested_level = level
    get_node("/root/SceneChanger").goto_scene("res://GameScene.tscn")

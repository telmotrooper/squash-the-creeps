extends Node

const MENU_FADE_OUT = "menu_fade_out"
var main_scene: PackedScene = load("res://maps/test_map.tscn")
var button_pressed: String

func _ready():
  var version = Engine.get_version_info()
  $Menu/VersionLabel.text = "DEMO RELEASE – GODOT %d.%d.%d" % [version.major, version.minor, version.patch]

func _on_Button_pressed(button_name):
  button_pressed = button_name
  $AnimationPlayerMenu.play(MENU_FADE_OUT)

func _on_AnimationPlayerMenu_animation_finished(anim_name):
  if anim_name == MENU_FADE_OUT:
    if button_pressed == "new_game":
      GameState.change_map("test_map")
    elif button_pressed == "exit":
      get_tree().quit()

func _on_AnimationPlayerSpaceship_animation_finished(anim_name):
  if anim_name == "coming_in":
    $Spatial/AnimationPlayerSpaceship.play("flying_in_space")


func _on_CenterContainer_gui_input(event: InputEvent):
  if event is InputEventMouseButton and event.button_index == 1 and $Spatial/AnimationPlayerSpaceship.current_animation == "flying_in_space":
    $Spatial/AnimationPlayerAlien.play("spin-y")
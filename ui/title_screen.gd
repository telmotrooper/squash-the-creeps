extends Node

const MENU_FADE_OUT = "menu_fade_out"
var main_scene: PackedScene = load("res://maps/test_map.tscn")
var button_pressed: String

func _on_Button_pressed(button_name):
  button_pressed = button_name
  $AnimationPlayerMenu.play(MENU_FADE_OUT)

func _on_AnimationPlayerMenu_animation_finished(anim_name):
  if anim_name == MENU_FADE_OUT:
    if button_pressed == "new_game":
      GameState.change_map("test_map")
    elif button_pressed == "exit":
      get_tree().quit()

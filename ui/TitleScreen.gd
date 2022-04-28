extends Node

var main_scene: PackedScene = load("res://maps/TestMap.tscn")
const MENU_FADE_OUT = "menu_fade_out"

func _on_NewGameButton_pressed():
  $AnimationPlayerMenu.play(MENU_FADE_OUT)

func _on_ExitButton_pressed():
  get_tree().quit()

func _on_AnimationPlayerMenu_animation_finished(anim_name):
  if anim_name == MENU_FADE_OUT:
    GameState.change_map("TestMap")

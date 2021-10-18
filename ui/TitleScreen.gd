extends Node

var main_scene = load("res://TestMap.tscn")

func _ready():
  $Spatial/AnimationPlayerSkybox.play("rotating_skybox")
  $Spatial/AnimationPlayerSpaceship.play("flying_in_space")

func _on_NewGameButton_pressed():
  $AnimationPlayerMenu.play("menu_fade_out")

func _on_ExitButton_pressed():
  get_tree().quit()

func _on_AnimationPlayerMenu_animation_finished(anim_name):
  get_tree().change_scene("res://TestMap.tscn")

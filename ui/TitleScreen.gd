extends Node

func _ready():
  $Spatial/AnimationPlayerSkybox.play("rotating_skybox")
  $Spatial/AnimationPlayerSpaceship.play("flying_in_space")

func _on_NewGameButton_pressed():
  get_tree().change_scene("res://Main.tscn")

func _on_ExitButton_pressed():
  get_tree().quit()

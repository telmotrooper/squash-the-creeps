extends Node

func _ready():
  $Spatial/AnimationPlayer.play("rotating_skybox")
  $Spatial/AnimationPlayer.playback_speed = 0.2
  

func _on_NewGameButton_pressed():
  get_tree().change_scene("res://Main.tscn")

func _on_ExitButton_pressed():
  get_tree().quit()

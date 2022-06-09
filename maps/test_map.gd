extends Node

func _ready():
  GameState.RetryCamera = $RetryCamera
  GameState.Grass = get_node("%GreenPlatformGrass")
  GameState.update_grass()

func _on_Player_hit():
  GameState.UserInterface.retry()

func _on_RedButton_pressed():
  $Goweti/Manual.move_platforms()

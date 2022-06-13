extends Node

func _ready():
  GameState.RetryCamera = $RetryCamera

func _on_Player_hit():
  GameState.UserInterface.retry()

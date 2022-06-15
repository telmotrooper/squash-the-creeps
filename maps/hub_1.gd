extends Node

export (AudioStream) var map_music

func _ready():
  GameState.play_music(map_music)
  GameState.RetryCamera = $RetryCamera

func _on_Player_hit():
  GameState.UserInterface.retry()

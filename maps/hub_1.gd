extends Node

export (AudioStream) var map_music

func _ready():
  GameState.stop_music()
  if GameState.new_game:
    $AudioStreamPlayer.play() # Crash sound.
    GameState.new_game = false
  
  GameState.RetryCamera = $RetryCamera

func _on_Player_hit():
  GameState.UserInterface.retry()

extends Node

export (AudioStream) var map_music

func _ready():
  GameState.stop_music()
  if GameState.new_game:
    $AudioStreamPlayer.play() # Crash sound.
    GameState.new_game = false
  else:
    GameState.play_music(map_music)
  
  GameState.RetryCamera = $RetryCamera

func _on_Player_hit():
  GameState.UserInterface.retry()

func _on_AudioStreamPlayer_finished():
  GameState.play_music(map_music)

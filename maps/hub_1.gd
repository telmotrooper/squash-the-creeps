extends Node

export (Environment) var day_environment
export (Environment) var night_environment
export (AudioStream) var map_music

func _ready() -> void:
  GameState.stop_music()
  if GameState.hub_1_at_night:
    $WorldEnvironment.environment = night_environment
#    $AudioStreamPlayer.play() # Crash sound.
  else:
    $WorldEnvironment.environment = day_environment
    GameState.play_music(map_music)
    $Spaceship/Smoke.queue_free()
  
  GameState.RetryCamera = $RetryCamera

func _on_Player_hit() -> void:
  GameState.UserInterface.retry()

func _on_AudioStreamPlayer_finished() -> void:
  GameState.play_music(map_music)

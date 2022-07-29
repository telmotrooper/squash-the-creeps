extends Node

export (Environment) var day_environment
export (Environment) var night_environment
export (AudioStream) var map_music

# Notice that the Player node has been put by the end of the tree
# to prevent a bug where the camera (related to the CutsceneAnimationPlayer)
# where restarting the map makes sets the wrong current camera.

func _ready() -> void:
  GameState.stop_music()
  
  # The player start the map paused, until we verify
  # whether the intro cutscene should be played.
  if GameState.intro_cutscene_played:
    $Player.paused = false
  else: # Play cutscene.
    $Cutscene/CutsceneAnimationPlayer.play("spaceship_fall")
    GameState.intro_cutscene_played = true
  
  
  if GameState.hub_1_at_night:
    $WorldEnvironment.environment = night_environment
  else:
    $WorldEnvironment.environment = day_environment
    GameState.play_music(map_music)
    $Spaceship/Smoke.queue_free()

func _on_Player_hit() -> void:
  GameState.UserInterface.retry()

func _on_AudioStreamPlayer_finished() -> void:
  GameState.play_music(map_music)

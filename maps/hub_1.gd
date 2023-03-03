extends Node

@export var day_environment: Environment
@export var night_environment: Environment
@export var map_music: AudioStream

# Notice that the Player node has been put by the end of the tree
# to prevent a bug where the camera (related to the CutsceneAnimationPlayer)
# where restarting the map makes sets the wrong current camera.

func _ready() -> void:
  GameState.stop_music()
  GameState.play_music(map_music)
  
  %SpaceshipLabel3D.hide()
  
  # The player start the map paused, until we verify
  # whether the intro cutscene should be played.
  if GameState.intro_cutscene_played:
    $Player.paused = false
  else: # Play cutscene.
    $Cutscene/CutsceneAnimationPlayer.play("spaceship_fall")
    GameState.intro_cutscene_played = true
  
  
  if GameState.hub_1_at_night:
    $WorldEnvironment.environment = night_environment
    if !$Cutscene/CutsceneAnimationPlayer.is_playing():
      $Spaceship/Smoke.play_sound()
  else:
    $WorldEnvironment.environment = day_environment
    $Spaceship/Smoke.queue_free()

func _on_Player_hit() -> void:
  GameState.UserInterface.retry()

func _on_AudioStreamPlayer_finished() -> void:
  GameState.play_music(map_music)


func _on_CutsceneAnimationPlayer_animation_finished(_anim_name: String) -> void:
  var intro_dialog = Dialogic.start("res://dialogic/timelines/intro.dtl")
  await Dialogic.signal_event
  GameState.Player.paused = false

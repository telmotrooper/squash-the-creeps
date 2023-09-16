extends Node

@export var day_environment: Environment
@export var night_environment: Environment
@export var map_music: AudioStream

@export var minimap: Texture2D

# Notice that the Player node has been put by the end of the tree
# to prevent a bug where the camera (related to the CutsceneAnimationPlayer)
# where restarting the map makes sets the wrong current camera.

func _ready() -> void:
	GameState.stop_music()
	GameState.play_music(map_music)
	
	GameState.UserInterface.set_minimap(minimap, Vector2(0,-25), 2.35)
	%SpaceshipLabel3D.hide()
	
	# The player start the map paused, until we verify
	# whether the intro cutscene should be played.
	if GameState.cutscenes_played.intro:
		$Player.paused = false
		$Cutscene/CutsceneSpaceship.queue_free()
	else: # Play cutscene.
		GameState.UserInterface.get_node("%Minimap").hide()
		$Cutscene/CutsceneAnimationPlayer.play("spaceship_fall")
		GameState.cutscenes_played.intro = true
	
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
	GameState.dialog.set_text("The ship is completely busted... I won't be able to get out of here easily. Where IS here though?")
	GameState.dialog.open_dialog()

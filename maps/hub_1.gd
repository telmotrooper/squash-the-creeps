extends Node3D

@export var day_environment: Environment
@export var night_environment: Environment
@export var map_music: AudioStream

@export var minimap: Texture2D

# Notice that the Player node has been put by the end of the tree
# to prevent a camera bug (related to the CutsceneAnimationPlayer)
# where restarting the map sets the wrong current camera.

func _ready() -> void:
	GameState.stop_music()
	GameState.play_music(map_music)
	
	UserInterface.set_minimap(minimap, Vector2(0,-25), 2.35)
	%SpaceshipLabel3D.hide()
	
	# The player start the map paused, until we verify
	# whether the intro cutscene should be played.
	if GameState.cutscenes_played.intro:
		$Player.paused = false
		$Cutscene.queue_free()
	else: # Play cutscene.
		UserInterface.set_minimap_visible(false)
		$Cutscene/CutsceneAnimationPlayer.play("spaceship_fall")
		GameState.cutscenes_played.intro = true
	
	if GameState.hub_1_at_night:
		$WorldEnvironment.environment = night_environment
		if !$Cutscene/CutsceneAnimationPlayer.is_playing():
			$Spaceship/Smoke.play_sound()
	else:
		$WorldEnvironment.environment = day_environment
		$Spaceship/Smoke.queue_free()

func _on_AudioStreamPlayer_finished() -> void:
	GameState.play_music(map_music)

func _on_CutsceneAnimationPlayer_animation_finished(_anim_name: String) -> void:
	$Cutscene.queue_free()
	UserInterface.show_dialog("The ship is completely busted... I won't be able to get out of here easily. Where IS here though?")

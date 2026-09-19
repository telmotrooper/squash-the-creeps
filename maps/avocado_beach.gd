extends Node3D

@export var map_music: AudioStream
@export var minimap: Texture2D

func _ready() -> void:
	GameState.play_music(map_music)
	GameState.grass = %Grass
	GameState.update_grass()
	UserInterface.set_minimap(minimap, Vector2(0,0), 1.72)
	# 2.35 is a good proportion for a camera with size 550 m
	# 1.72 is a good proportion for a camera with size 750 m
	UserInterface.show_map_name("Avocado Beach")
	
	if not GameState.cutscenes_played.avocado_beach_preview:
		GameState.cutscenes_played.avocado_beach_preview = true
		$CutsceneAnimationPlayer.play("preview")

func _on_RedButton_pressed() -> void:
	$Map/MovingPlatforms/Manual.move_platforms()

func _on_SprintTutorial_body_entered(_body: Node) -> void:
	%SprintTutorial.get_node("AnimationPlayer").play("show_sprint_label")

# Used in cutscene.
func set_minimap_visible(value: bool) -> void:
	UserInterface.set_minimap_visible(value)

func hide_map_name() -> void:
	UserInterface.hide_map_name()

func _on_tiki_freed():
	$CagedTikiNPC/CagedTikiGodotHeadAnimationPlayer.play("appear")

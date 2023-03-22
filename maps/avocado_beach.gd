extends Node

@export var map_music: AudioStream
@export var minimap: Texture2D

func _ready() -> void:
  GameState.play_music(map_music)
  GameState.Grass = %Grass
  GameState.update_grass()
  GameState.UserInterface.set_minimap(minimap, Vector2(0,0), 1.72)
  # 2.35 is a good proportion for a camera with size 550 m
  # 1.72 is a good proportion for a camera with size 750 m
  GameState.UserInterface.get_node("MapName").display("Avocado Beach")

func _on_Player_hit() -> void:
  GameState.UserInterface.retry()

func _on_RedButton_pressed() -> void:
  $Map/MovingPlatforms/Manual.move_platforms()

func _on_SprintTutorial_body_entered(_body: Node) -> void:
  %SprintTutorial.get_node("AnimationPlayer").play("show_sprint_label")

# Used in cutscene.
func set_minimap_visible(value: bool) -> void:
  GameState.minimap.set_visible(value)

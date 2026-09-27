extends Node3D

@export var initial_scene: PackedScene

func _ready() -> void:
	SceneLoader.cover_screen()
	SceneLoader.change_scene(initial_scene.get_path())

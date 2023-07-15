extends Node3D

@export var map_music: AudioStream

func _ready() -> void:
  GameState.play_music(map_music)

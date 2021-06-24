extends Node

func _ready():
  GameState.Audio = self

func play(file):
  $AudioStreamPlayer1.stream = load(file)
  $AudioStreamPlayer1.play()

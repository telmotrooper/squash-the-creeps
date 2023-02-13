extends Node3D
class_name RedButton

signal pressed

enum Direction { FLOOR, WALL }

@export (Direction) var direction = Direction.FLOOR
var is_pressed := false

func press() -> void:
  if !is_pressed:
    $AnimationPlayer.play("press")
    $AudioStreamPlayer.play()
    is_pressed = true
    emit_signal("pressed")

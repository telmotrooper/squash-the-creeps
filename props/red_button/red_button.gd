extends Node3D
class_name RedButton

signal pressed

enum Direction { FLOOR, WALL }

@export var direction: Direction = Direction.FLOOR
var is_pressed := false

func press() -> void:
	if !is_pressed:
		$AnimationPlayer.play("press")
		$AudioStreamPlayer.play()
		is_pressed = true
		pressed.emit()

func interact_on_spin() -> void:
	press()

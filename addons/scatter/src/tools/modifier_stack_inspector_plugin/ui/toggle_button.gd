@tool
extends Button


@export var default_icon: Texture2D
@export var pressed_icon: Texture2D


func _on_ready() -> void:
	_on_toggled(pressed)


func _on_toggled(pressed: bool) -> void:
	if pressed:
		icon = pressed_icon
	else:
		icon = default_icon

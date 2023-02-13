@tool
extends Button


@onready var _popup = $ModifiersPopup
var _modifiers := []


func _ready() -> void:
	_popup.connect("hide",Callable(self,"_on_popup_closed"))


func _toggled(button_pressed):
	if button_pressed:
		_popup.position = global_position + Vector2(0.0, size.y)
		_popup.popup()


func _on_popup_closed() -> void:
	pressed = false

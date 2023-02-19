@tool
extends Button

@export var button_text : String : get = get_button_text, set = set_button_text
@export var button_disabled: bool = false

func get_button_text() -> String:
  if is_instance_valid($Label):
    return $Label.text
  return ""

func set_button_text(value: String) -> void:
  if is_instance_valid($Label):
    $Label.text = value

func get_button_disabled() -> bool:
  return disabled

func set_button_disabled(value: bool) -> void:
  disabled = value
  $Label.add_color_override("font_color", Color(0.43, 0.43, 0.43, 1.00))

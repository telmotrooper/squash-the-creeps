extends Control
class_name Dialog

signal finished

func _ready() -> void:
  set_process(false)

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("interact"):
    close_dialog()

func set_text(text) -> void:
  %DialogText.text = text

func open_dialog() -> void:
  set_process(true)
  show()
  var tween = create_tween()
  tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)

func close_dialog() -> void:
  set_process(false)
  var tween = create_tween()
  tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
  tween.tween_callback(func():
    hide()
    emit_signal("finished")
  )

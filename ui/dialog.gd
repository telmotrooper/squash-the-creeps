extends Control
class_name Dialog

signal finished

var text_to_write := ""
var index = 0

func _ready() -> void:
  set_process(false)
  %DialogText.text = ""

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("skip_dialog"):
    close_dialog()

func set_text(text) -> void:
  text_to_write = text

func open_dialog() -> void:
  GameState.Player.paused = true
  GameState.minimap.hide()
  show()
  var tween = create_tween()
  tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
  tween.tween_callback(func(): set_process(true))
  tween.tween_callback(func():
    while index <= text_to_write.length():
      await get_tree().create_timer(0.05).timeout
      %DialogText.text = text_to_write.substr(0, index)
      index += 1
  )

func close_dialog() -> void:  
  set_process(false)
  var tween = create_tween()
  tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
  tween.tween_callback(func():
    index = 0
    text_to_write = ""
    %DialogText.text = ""
    hide()
    GameState.minimap.show()
    GameState.Player.paused = false
  )

extends Control
class_name Dialog

signal finished

var text_to_write := ""
var is_writing := false
var index = 0

func _ready() -> void:
  set_process(false)
  %DialogText.text = ""

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("skip_dialog"):
    if is_writing:
      index = text_to_write.length()
    else:
      close_dialog()

func set_text(text) -> void:
  text_to_write = text

func open_dialog() -> void:
  GameState.Player.set_cutscene_mode(true)
  GameState.minimap.hide()
  show()
  var tween = create_tween()
  tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
  tween.tween_callback(func(): set_process(true))
  tween.tween_callback(func():
    is_writing = true
    while index <= text_to_write.length():
      if get_tree().paused: # If game is paused, stop typing and recheck every half a second.
        await get_tree().create_timer(0.5).timeout
      else:
        await get_tree().create_timer(0.05).timeout
        %DialogText.text = text_to_write.substr(0, index)
        index += 1
    is_writing = false
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
    GameState.Player.set_cutscene_mode(false)
    emit_signal("finished")
  )

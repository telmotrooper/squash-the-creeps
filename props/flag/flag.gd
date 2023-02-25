extends Node3D

var text_index = 0
var text = "CHECKPOINT"

func _on_text_timer_timeout() -> void:
  $Label3D.text = text.substr(0, text_index)
  text_index += 1
  if text_index > text.length():
    $TextTimer.stop()
    $RestartTimer.start()

func _on_restart_timer_timeout() -> void:
  text_index = 0
  $TextTimer.start()

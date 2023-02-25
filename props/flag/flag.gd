extends Node3D

var text_index = 0
var text = "CHECKPOINT"

func _ready() -> void:
  $Label3D.hide()

func _on_text_timer_timeout() -> void:
  $Label3D.text = text.substr(0, text_index)
  $Label3D.show()
  
  text_index += 1
  if text_index > text.length():
    $TextTimer.stop()
    $RestartTimer.start()

func _on_restart_timer_timeout() -> void:
  text_index = 0
  $TextTimer.start()

func _on_area_3d_body_entered(_body: Node3D) -> void:
  $TextTimer.start()

func _on_area_3d_body_exited(_body: Node3D) -> void:
  $Label3D.hide()
  $TextTimer.stop()
  $RestartTimer.stop()
  text_index = 0

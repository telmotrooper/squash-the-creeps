extends Node3D

@export var material_1: Material
@export var material_2: Material

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
    $VisibilityTimer.start()

func _on_area_3d_body_entered(_body: Node3D) -> void:
  $Flag.set_surface_override_material(0, material_2)
  $TextTimer.start()

func _on_visibility_timer_timeout() -> void:
  $Label3D.hide()
  text_index = 0

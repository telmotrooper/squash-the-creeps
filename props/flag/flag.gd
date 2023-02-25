extends Node3D

@export var material_1: Material
@export var material_2: Material

var text_index = 0
var text = "CHECKPOINT"
var initial_flag_y: float


func _ready() -> void:
  $Label3D.hide()
  initial_flag_y = $Flag.position.y

func _on_text_timer_timeout() -> void:
  $Label3D.text = text.substr(0, text_index)
  $Label3D.show()
  
  text_index += 1
  if text_index > text.length():
    $TextTimer.stop()
    $VisibilityTimer.start()

func _on_area_3d_body_entered(_body: Node3D) -> void:
  var tween = create_tween()
  
  tween.tween_property($Flag, "position:y", -4, 1)
  tween.tween_callback($Flag.set_surface_override_material.bind(0, material_2))
  tween.tween_property($Flag, "position:y", initial_flag_y, 1)
  
  $TextTimer.start()

func _on_visibility_timer_timeout() -> void:
  $Label3D.hide()
  text_index = 0

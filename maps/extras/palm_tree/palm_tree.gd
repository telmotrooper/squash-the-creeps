extends StaticBody3D

var shaking := false

func interact_on_spin() -> void:
  if not shaking:
    shaking = true
    var tween = create_tween().set_loops(2)
    tween.tween_property($Pivot, "rotation_degrees:x", 2.5, 0.2)
    tween.tween_property($Pivot, "rotation_degrees:x", 0, 0.2)
    tween.tween_callback(done)

func done() -> void:
  shaking = false

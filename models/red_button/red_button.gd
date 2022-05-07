extends Spatial
class_name RedButton

signal pressed

var is_pressed := false

func press():
  if !is_pressed:
    $AnimationPlayer.play("press")
    $AudioStreamPlayer.play()
    is_pressed = true
    emit_signal("pressed")

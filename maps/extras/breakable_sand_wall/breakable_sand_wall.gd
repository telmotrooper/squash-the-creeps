extends CSGBox3D

func break_wall() -> void:
  $AudioStreamPlayer3D.play()
  use_collision = false
  hide()
  
  await $AudioStreamPlayer3D.finished
  queue_free()

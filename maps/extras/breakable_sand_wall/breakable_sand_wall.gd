extends CSGBox3D

func interact_on_spin() -> void:
  $AudioStreamPlayer3D.play()
  use_collision = false
  hide()
  
  await $AudioStreamPlayer3D.finished
  queue_free()

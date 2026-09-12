extends CSGBox3D

func interact_on_spin(_player_position: Vector3) -> void:
	$AudioStreamPlayer3D.play()
	use_collision = false
	hide()
	
	await $AudioStreamPlayer3D.finished
	queue_free()

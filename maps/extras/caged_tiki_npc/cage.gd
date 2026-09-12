extends StaticBody3D

func interact_on_spin(_player_position: Vector3) -> void:
	$"..".free_tiki()
	queue_free()

extends RigidBody3D

var just_spun := false

var throw_speed := 1.0
var throw_lift := 0.0
var tumble_torque := 1.0

func interact_on_spin(player_position: Vector3) -> void:
	if just_spun:
		return
	just_spun = true
	
	var direction := global_position - player_position
	direction.y = 0.0
	
	apply_central_impulse(direction * throw_speed * Vector3.UP * throw_lift)
	apply_torque_impulse(Vector3.UP.cross(direction) * tumble_torque)
	
	await get_tree().create_timer(0.5).timeout
	just_spun = false

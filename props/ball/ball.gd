extends RigidBody3D

var just_spun := false

var throw_impulse := 1.25 # affects how far it goes
var lift_impulse := 2.5 # affects how high it goes
var rotational_impulse := 1.0 # affects how much it spins

func interact_on_spin(player_position: Vector3) -> void:
	if just_spun:
		return
	just_spun = true
	
	var direction := global_position - player_position
	direction.y = 0.0
	direction = direction.normalized()
	
	apply_central_impulse(direction * throw_impulse + Vector3.UP * lift_impulse)
	apply_torque_impulse(Vector3.UP.cross(direction) * rotational_impulse)
	
	await get_tree().create_timer(0.5).timeout
	just_spun = false

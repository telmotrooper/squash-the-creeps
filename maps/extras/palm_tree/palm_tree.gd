extends StaticBody3D

const tilt_degrees := 2.5
const tilt_duration := 0.2 # seconds

var shaking := false

func _ready() -> void:
	for child in get_children():
		if child is Gem:
			child.freeze = true

func interact_on_spin(player_position: Vector3) -> void:
	if shaking:
		return
	
	shaking = true
	
	for child in get_children(): # Drop gem.
		if child is Gem:
			child.freeze = false
	
	var to_player := to_local(player_position)
	
	# Horizontal axis perpendicular to the hit direction.
	var axis := to_player.cross(Vector3.UP).normalized()
	
	var tween := create_tween().set_loops(2)
	tween.tween_method(tilt.bind(axis), 0.0, tilt_degrees, tilt_duration)
	tween.tween_method(tilt.bind(axis), tilt_degrees, 0.0, tilt_duration)
	
	await tween.finished
	
	shaking = false

func tilt(angle_degrees: float, axis: Vector3) -> void:
	$Pivot.basis = Basis(axis, deg_to_rad(angle_degrees))

extends StaticBody3D

const tilt_degrees := 2.5
const tilt_duration := 0.2 # seconds

var shaking := false
var initial_basis: Basis

func _ready() -> void:
	set_process(false)
	initial_basis = basis

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and not GameState.player.paused:
		GameState.dialog.set_text("It isn't going anywhere soon...")
		GameState.dialog.open_dialog()

func _on_SpaceshipArea_body_entered(_player: Node) -> void:
	%SpaceshipLabel3D.show()
	set_process(true)

func _on_SpaceshipArea_body_exited(_player: Node) -> void:
	%SpaceshipLabel3D.hide()
	set_process(false)

func interact_on_spin(player_position: Vector3) -> void:
	if shaking:
		return
	
	shaking = true
	
	var to_player := to_local(player_position)
	
	# Horizontal axis perpendicular to the hit direction.
	var axis := to_player.cross(Vector3.UP).normalized()
	
	var tween := create_tween().set_loops(2)
	tween.tween_method(tilt.bind(axis), 0.0, tilt_degrees, tilt_duration)
	tween.tween_method(tilt.bind(axis), tilt_degrees, 0.0, tilt_duration)
	
	await tween.finished
	
	shaking = false

func tilt(angle_degrees: float, axis: Vector3) -> void:
	basis = initial_basis * Basis(axis, deg_to_rad(angle_degrees))

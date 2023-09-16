extends Node3D
class_name TurretEnemy

@export var bullet_scene: PackedScene

enum { IDLE, ALERT, ATTACKING, ATTACKING_BUT_NOT_AIMING, STOPPED }

var state := IDLE
var pilot_alive := true

func _physics_process(_delta: float) -> void:
	match state:
		IDLE:
			$GunTimer.stop()
		ALERT:
			$ExclamationMark.show()
			$AlertTimer.start()
			set_physics_process(false)
		ATTACKING:
			if is_instance_valid(GameState.Player):
				aim_at_player(GameState.Player.transform.origin)
				
				if $GunTimer.is_stopped():
					_on_gun_timer_timeout() # Trigger first shot immediately.
					$GunTimer.start()
		ATTACKING_BUT_NOT_AIMING:
				if $GunTimer.is_stopped():
					$GunTimer.start()
		STOPPED:
			$GunTimer.stop()

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if state == IDLE:
		state = ALERT

func _on_area_3d_body_exited(_body: Node3D) -> void:
	if state != STOPPED: # Only become idle if pilot is still in the cockpit.
		state = IDLE

func aim_at_player(player_position) -> void:
	look_at(player_position, Vector3.UP)
	rotation.x = clamp(rotation.x, 0, 0.6)
	
func _on_alert_timer_timeout() -> void:
	$ExclamationMark.hide()
	state = ATTACKING
	set_physics_process(true)

func _on_gun_timer_timeout() -> void:
	if is_instance_valid(GameState.Player):
		# The position (Vector3) passed to the bullet is an approximation
		# of where we want it to spawn relative to this node.
		var bullet = bullet_scene.instantiate().setup(Vector3(0,3,-10), GameState.Player.transform.origin)
		add_child(bullet)

func _on_pilot_area_3d_body_exited(_body: Node3D) -> void:
	# If the pilot left the cockpit, stop turret.
	state = STOPPED
	pilot_alive = false

func _on_player_detection_body_entered(_body: Node3D) -> void:
	if pilot_alive:
		state = ATTACKING_BUT_NOT_AIMING

func _on_player_detection_body_exited(_body: Node3D) -> void:
	if pilot_alive:
		state = ATTACKING

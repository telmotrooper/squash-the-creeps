extends CharacterBody3D
class_name Player

signal hit

# Exports
@export var full_health_material: Material
@export var mid_health_material: Material
@export var low_health_material: Material
@export var hurt_sound: AudioStream
@export var walk_speed := 14.0
@export var run_speed := 22.0
@export var jump_impulse := 25.0
@export var fall_acceleration := 75.0
@export var bounce_impulse := 16.0
@export var dash_duration := 0.2
@export var dash_speed := 150
@export var bounce_cap := 87
@export var body_slam_speed := 30
@export var throw_back_y_impulse := 25
@export var throw_back_speed := 20
@export var paused := false
@export var spawn_animation := true

# State
var last_direction: Vector3
var initial_position: Vector3
var last_safe_position: Vector3
var health := 3
var speed := 0.0
var is_jumping := false
var is_double_jumping := false
var dash_available := true
var is_dashing := false
var is_body_slamming := false
var just_thrown_back := false
var being_thrown_back := false
var floating := false

func _ready() -> void:
	GameState.Player = self
	initial_position = global_transform.origin
	$DashDurationTimer.wait_time = dash_duration
	
	# Calculate the initial value for "last_direction" based on the rotation of the camera.
	# This guarantees that if the player dashes before moving, they'll dash forward.
	last_direction = Vector3.FORWARD.rotated(Vector3.UP,
		$CameraPivot/Horizontal.global_transform.basis.get_euler().y).normalized()
	
	# Initial position will always be considered a safe position, even if the raycasts do not indicate it.
	last_safe_position = global_transform.origin
	if spawn_animation:
		$EffectsAnimationPlayer.play("grow")

func _physics_process(delta: float) -> void:
	update_minimap()
	
	if get_parent() is PathFollow3D: # Prevent movement when bouncing.
		$AnimationPlayer.speed_scale = 1.0
		return
	
	if paused: # Used to prevent movement during a cutscene.
		return
	
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("float") # Idle animation.
	
	if Input.is_action_just_pressed("attack") and not is_dashing:
		$AnimationPlayer.play("spin-y")
	
	# Get direction vector based checked input.
	var direction = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward"))
	
	# Rotate direction based checked camera.
	var horizontal_rotation = $CameraPivot/Horizontal.global_transform.basis.get_euler().y
	direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()
	
	if direction != Vector3.ZERO and !is_spinning(): # Player is moving.
		if not being_thrown_back: # Last direction is used for throw back.
			last_direction = direction
		
		$ModelPivot.look_at(position + direction, Vector3.UP)
		
		if is_dashing:
			if is_on_floor() and get_floor_angle(Vector3.UP) > 0: # Ramp bounce.
				velocity.y = get_floor_angle(Vector3.UP) * 200
				if velocity.y > bounce_cap: # Prevent the bounce from going too high.
					velocity.y = bounce_cap
			$AnimationPlayer.speed_scale = 1.0
		elif Input.is_action_pressed("sprint"): # Running.
			speed = run_speed
			$AnimationPlayer.speed_scale = 3.0
		else: # Walking.
			speed = walk_speed
			$AnimationPlayer.speed_scale = 2.25
	else: # Idle
		$AnimationPlayer.speed_scale = 1.0
	
	if GameState.upgrades["mid_air_dash"]:
		if is_on_floor():
			dash_available = true
		
		if dash_available and !is_on_floor() and Input.is_action_just_pressed("sprint"):
			if $DashDurationTimer.is_stopped():
				$AnimationPlayer.play("dash")
				is_dashing = true
				dash_available = false
				$DashDurationTimer.start()
				being_thrown_back = false # Dash cancels throw back.

		if is_dashing:
			speed = dash_speed
	
	if direction.x == 0 and direction.z == 0 and is_dashing:
		direction = last_direction
	
	if just_thrown_back: # If just thrown back, throw player up.
		take_damage()
		velocity.y = throw_back_y_impulse
		just_thrown_back = false
	elif is_on_floor():
		being_thrown_back = false
	
	if being_thrown_back:
		is_jumping = true
		velocity.x = -last_direction.x * throw_back_speed
		velocity.z = -last_direction.z * throw_back_speed
	else: # Move player.
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	
	if is_body_slamming and is_on_floor():
		$BodySlamParticles.restart()
		$BodySlamParticles.emitting = true
		is_body_slamming = false
	
	if not is_jumping and Input.is_action_pressed("jump"): # Single jump.
		velocity.y = jump_impulse
		is_jumping = true
	elif is_on_floor() and get_slide_collision_count() > 0 and not get_slide_collision(0).get_collider() is Enemy: # Reset both jumps.
		is_jumping = false
		is_double_jumping = false

		var safe_position_condition = (
			$RayCasts/RayCast.get_collider() and $RayCasts/RayCast.is_colliding() and
			not $RayCasts/RayCast.get_collider().get_collision_layer_value(GameState.collision_layers["Water"]) and
			not $RayCasts/RayCast.get_collider().is_in_group("breakable_floor") and
			$RayCasts/RayCast.get_collider() == $RayCasts/RayCast2.get_collider() and
			$RayCasts/RayCast.get_collider() == $RayCasts/RayCast3.get_collider() and
			$RayCasts/RayCast.get_collider() == $RayCasts/RayCast4.get_collider()
		)
		if safe_position_condition:
			last_safe_position = global_transform.origin
	elif is_on_floor() and get_slide_collision_count() > 0 and get_slide_collision(0).get_collider() is Enemy: # Reset double jump.
		is_double_jumping = false
	elif GameState.upgrades["double_jump"] and (is_jumping and not is_double_jumping
		and velocity.y <= 20 # Only allow double jump after player slows down a bit.
		and Input.is_action_just_pressed("jump")):
		is_double_jumping = true
		velocity.y = jump_impulse * 1.3 # Double jump goes higher than single jump.
		being_thrown_back = false # Double jump cancels throw back.
	elif GameState.upgrades["body_slam"] and is_double_jumping and not is_body_slamming and Input.is_action_just_pressed("body_slam"):
		is_body_slamming = true
		velocity.y = -body_slam_speed
	
	if floating:
		velocity.y = 10
	else: # Apply gravity.
		velocity.y -= fall_acceleration * delta
	
	move_and_slide()
	
	# Handling events related to colliding with nodes below player.
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		
		if collision.get_collider().is_in_group("enemies"):
			var enemy = collision.get_collider()
			
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				enemy.squash()
				if Input.is_action_pressed("jump"):
					velocity.y = jump_impulse + bounce_impulse # Bounce when squashing an enemy and holding "jump".
				else:
					velocity.y = jump_impulse
				is_jumping = true
		
		elif collision.get_collider() is RedButton: # A red button in the floor.
			var red_button = collision.get_collider()
			
			if red_button.direction == RedButton.Direction.FLOOR and not red_button.is_pressed:
				red_button.press()
		
		elif is_body_slamming and collision.get_collider().is_in_group("breakable_floor"):
			var parent = collision.get_collider().get_parent()
			if parent is MeshInstance3D:
				parent.queue_free()
	
	# Rotate character vertically alongside a fall.
	var rotation_x = PI / 6.0 * velocity.y / jump_impulse
	if rotation_x > -1.25: # Prevent rotating 360 degrees.
		$ModelPivot.rotation.x = rotation_x
	
	if is_spinning():
		for entity in $SpinArea.get_overlapping_bodies():
			if entity.is_in_group("enemies"):
				entity.squash()
			elif entity.is_in_group("spinnable"):
				entity.interact_on_spin()

func is_spinning() -> bool:
	return $AnimationPlayer.current_animation == "spin-y" and $AnimationPlayer.is_playing()

func die() -> void:
	hit.emit()
	queue_free()

func _on_EnemyDetector_body_entered(_body: Node) -> void: # hurt
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stream = hurt_sound
		$AudioStreamPlayer.play()
	just_thrown_back = true
	being_thrown_back = true

func set_draw_distance(value: int) -> void:
	%Camera3D.far = value

func _on_DashDurationTimer_timeout() -> void:
	is_dashing = false

func move_to_last_safe_position() -> void:
	paused = true
	
	if health == 1:
		GameState.reload_current_scene()
	else:
		var fade_transition = get_node_or_null("/root/Main/FadeTransition")
		if fade_transition: # Always available when started from "main" scene.
			fade_transition.fade_out()
			await fade_transition.faded_out
			take_damage() # Player changes color while the screen is black.
			fade_transition.fade_in()
		else: # If not started from "main" scene, still call "take_damage".
			take_damage()
		$EffectsAnimationPlayer.play("grow")
		global_transform.origin = last_safe_position
		paused = false

func update_color() -> void:
	if health == 3:
		$ModelPivot/player/Body.set_surface_override_material(0, full_health_material)
	elif health == 2:
		$ModelPivot/player/Body.set_surface_override_material(0, mid_health_material)
	elif health == 1:
		$ModelPivot/player/Body.set_surface_override_material(0, low_health_material)

func take_damage() -> void:
	$AnimationPlayer2.play("hurt")
	health -= 1
	update_color()

	if health <= 0:
		GameState.reload_current_scene()

func set_health(value: int) -> void:
	health = value
	update_color()

func update_minimap() -> void:
	if is_instance_valid(GameState.UserInterface):
		GameState.UserInterface.move_minimap(global_transform.origin - initial_position)
		var minimap_pivot = GameState.UserInterface.get_node("%MinimapPivot")
		minimap_pivot.rotation = $CameraPivot/Horizontal.rotation.y
		var player_cursor_pivot = GameState.UserInterface.get_node("%PlayerCursorPivot")
		player_cursor_pivot.rotation = $CameraPivot/Horizontal.rotation.y + $ModelPivot.rotation.y * -1

func set_cutscene_mode(enabled: bool) -> void:
	if enabled:
		GameState.Player.paused = true
		$AnimationPlayer.speed_scale = 1.0
	else:
		GameState.Player.paused = false

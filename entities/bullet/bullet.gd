extends CharacterBody3D

var target: Node3D
var return_target: Node3D

var speed := 35
var direction := Vector3.ZERO
var just_spun := false

func _ready() -> void:
	set_physics_process(false)

func setup(new_position: Vector3, new_target: Node3D, new_return_target: Node3D) -> void:
	position = new_position
	target = new_target
	return_target = new_return_target

func start() -> void:
	look_at(target.global_position)
	set_physics_process(true)
	$Timer.start()

func _physics_process(_delta: float) -> void:
	velocity = -transform.basis.z * speed
	
	# Store before move_and_slide(), so it's not affected by collisions.
	direction = velocity.normalized()
	
	move_and_slide()
	
	# Check if bullet hit the player.
	if get_slide_collision_count() > 0:
		var collider = get_slide_collision(0).get_collider()
		if collider is Player:
			var player = collider
			player._on_EnemyDetector_body_entered(self, direction)
			queue_free()
		elif collider is Enemy:
			collider.squash()

func _on_timer_timeout() -> void:
	queue_free()

func interact_on_spin(_player_position: Vector3) -> void:
	if just_spun:
		return
	just_spun = true
	
	if is_instance_valid(return_target): # Send it back to the return target (e.g. enemy inside the turret).
		look_at(return_target.global_position)
	else:
		rotate_object_local(Vector3.UP, PI) # Otherwise, just return it to the direction it came from.
	
	await get_tree().create_timer(0.5).timeout
	just_spun = false

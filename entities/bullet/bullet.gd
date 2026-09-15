extends CharacterBody3D

var target: Vector3

var speed := 35
var direction := Vector3.ZERO
var just_spun := false

func setup(new_position, new_target) -> Node3D:
	position = new_position
	target = new_target # Currently target is not doing anything.
	return self

func _ready() -> void:
	set_up_direction(Vector3.UP)
	set_physics_process(false)

func start() -> void:
	set_physics_process(true)
	$Timer.start()

func _physics_process(_delta: float) -> void:
	# look_at(target, Vector3.UP)
	velocity = Vector3.FORWARD * speed
	# TODO: Current the bullet ignores the height the player is in, fix this.
	velocity = velocity.rotated(Vector3.UP, rotation.y) # Aim at player horizontally.
	
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

func _on_timer_timeout() -> void:
	queue_free()

func interact_on_spin(_player_position: Vector3) -> void:
	if just_spun:
		return
	just_spun = true
	
	rotation.y += PI
	
	await get_tree().create_timer(0.5).timeout
	just_spun = false

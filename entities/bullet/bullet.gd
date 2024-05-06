extends CharacterBody3D

var target: Vector3

var speed := 2000

func setup(new_position, new_target) -> Node3D:
	position = new_position
	target = new_target # Currently target is not doing anything.
	return self

func _ready() -> void:
	set_up_direction(Vector3.UP)

func _physics_process(delta: float) -> void:
	#  look_at(target, Vector3.UP)
	velocity = Vector3.FORWARD * speed * delta
	# TODO: Current the bullet ignores the height the player is in, fix this.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	move_and_slide()
	
	# Check if bullet hit the player.
	if get_slide_collision_count() > 0:
		var collider = get_slide_collision(0).get_collider()
		if collider is Player:
			var player = collider
			player._on_EnemyDetector_body_entered(self)
			queue_free()

func _on_timer_timeout() -> void:
	queue_free()

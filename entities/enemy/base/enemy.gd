extends CharacterBody3D
class_name Enemy

var already_squashed := false

@export var squash_sound: AudioStream
@export var min_speed := 10.0
@export var max_speed := 18.0
@export var affected_by_gravity := true

#var velocity = Vector3.ZERO

func _physics_process(_delta: float) -> void:
  if affected_by_gravity:
    if not is_on_floor():
      velocity.y = -10
    else:
      velocity.y = 0
  set_velocity(velocity)
  set_up_direction(Vector3.UP)
  move_and_slide()
  velocity = velocity

func initiliaze(start_position: Vector3, player_position: Vector3, should_rotate = true, speed = null) -> void:
  position = start_position
  look_at(player_position, Vector3.UP)
  # Ignore height of player position, spawn looking straight.
  rotation.x = 0
  
  # Rotate between -45 degrees and 45 degrees.
  if should_rotate:
    rotate_y(randf_range(-PI / 4.0, PI / 4.0))
  
  if speed == null:
    speed = randf_range(min_speed, max_speed)
  
  velocity = Vector3.FORWARD * speed
  velocity = velocity.rotated(Vector3.UP, rotation.y)
  $AnimationPlayer.speed_scale = speed / min_speed

func squash() -> void:
  if !already_squashed:
    already_squashed = true
    velocity = Vector3.ZERO
    $CollisionShape3D.disabled = true
    $AnimationPlayer.speed_scale = 1
    $AnimationPlayer.play("squash")
    GameState.play_audio(squash_sound)

func kill() -> void: # Triggered by animation "squash'.
  queue_free()

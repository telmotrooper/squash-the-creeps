extends CharacterBody3D
class_name Slime

var already_squashed := false

@export var squash_sound: AudioStream
@export var patrolling_speed = 4

enum {
  PATROLLING,
  DYING
}

var state = PATROLLING

#var velocity = Vector3.ZERO

func _ready() -> void:
  if get_parent() is PathFollow3D:
    # This will make the enemy look to the correct direction along the path.
    get_parent().set_rotation_mode(4)

func _physics_process(delta: float) -> void:
  if not is_on_floor():
    velocity.y = -20
  else:
    velocity.y = 0
  
  set_velocity(velocity)
  set_up_direction(Vector3.UP)
  move_and_slide()
  velocity = velocity
  
  match state:
    PATROLLING:
      if get_parent() is PathFollow3D:
        get_parent().progress += patrolling_speed * delta
    DYING:
      set_physics_process(false)

func squash() -> void:
  if !already_squashed:
    already_squashed = true
    $AnimationPlayer.play("squash")
    state = DYING
    GameState.play_audio(squash_sound)

func kill() -> void: # Triggered by animation "squash'.
  queue_free()

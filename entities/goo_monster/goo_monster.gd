extends KinematicBody

export var patrolling_speed = 4

enum {
  PATROLLING,
  DYING
}

var state = PATROLLING

var velocity = Vector3.ZERO

func _ready():
  if get_parent() is PathFollow:
    # This will make the enemy look to the correct direction along the path.
    get_parent().set_rotation_mode(4)

func _physics_process(delta):
  if not is_on_floor():
    velocity.y = -10
  else:
    velocity.y = 0
  
  velocity = move_and_slide(velocity, Vector3.UP)
  
  match state:
    PATROLLING:
      if get_parent() is PathFollow:
        get_parent().set_offset(get_parent().get_offset() + patrolling_speed * delta)
    DYING:
      set_physics_process(false)

func squash():
  $AnimationPlayer.play("squash")
  state = DYING

func kill(): # Triggered by animation "squash'.
  queue_free()

extends KinematicBody

var velocity = Vector3.ZERO

export var affected_by_gravity := true

func _physics_process(_delta):
  if affected_by_gravity:
    if not is_on_floor():
      velocity.y = -10
    else:
      velocity.y = 0
  velocity = move_and_slide(velocity, Vector3.UP)

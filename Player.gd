extends KinematicBody

export var speed := 14.0
export var jump_impulse := 20.0
export var fall_acceleration := 75.0

var velocity = Vector3.ZERO

func _physics_process(delta):
  var direction = Vector3.ZERO
  if Input.is_action_pressed("move_right"):
    direction.x += 1
  if Input.is_action_pressed("move_left"):
    direction.x -= 1
  if Input.is_action_pressed("move_back"):
    direction.z += 1
  if Input.is_action_pressed("move_forward"):
    direction.z -= 1

  if direction != Vector3.ZERO:
    direction = direction.normalized()
    $Pivot.look_at(translation + direction, Vector3.UP)
  
  velocity.x = direction.x * speed
  velocity.z = direction.z * speed
  
  if is_on_floor() and Input.is_action_pressed("jump"):
    velocity.y += jump_impulse
  
  velocity.y -= fall_acceleration * delta
  velocity = move_and_slide(velocity, Vector3.UP)

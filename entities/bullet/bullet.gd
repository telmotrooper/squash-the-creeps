extends CharacterBody3D

var target: Vector3

var speed := 15

func setup(new_target) -> Node3D:
  # Currently target is not doing anything.
  target = new_target
  return self

func _physics_process(_delta: float) -> void:
  set_velocity(velocity)
  set_up_direction(Vector3.UP)
  move_and_slide()
  velocity = velocity

func shoot() -> void:
#  look_at(target, Vector3.UP)
  velocity = Vector3.FORWARD * speed
  velocity = velocity.rotated(Vector3.UP, rotation.y)

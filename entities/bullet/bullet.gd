extends CharacterBody3D

var target: Vector3

var speed := 1000

func setup(new_position, new_target) -> Node3D:
  position = new_position
  target = new_target  # Currently target is not doing anything.
  return self

func _ready() -> void:
  set_up_direction(Vector3.UP)

func _physics_process(delta: float) -> void:
  #  look_at(target, Vector3.UP)
  velocity = Vector3.FORWARD * speed * delta
  # TODO: Current the bullet ignores the height the player is in, fix this.
  velocity = velocity.rotated(Vector3.UP, rotation.y)
  
  move_and_slide()

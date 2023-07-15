extends RigidBody3D
class_name PlayerBall

# Reference: https://youtu.be/G6OGM4fdF3M

var initial_position: Vector3
var initial_camera_position: Vector3
var force = 40

func _ready() -> void:
  initial_position = global_transform.origin

func _physics_process(delta: float) -> void:
  %CameraPivot.position = initial_position + position
  if Input.is_action_pressed("move_forward"):
    angular_velocity.x -= force * delta
  elif Input.is_action_pressed("move_back"):
    angular_velocity.x += force * delta
  
  if Input.is_action_pressed("move_left"):
    angular_velocity.z += force * delta
  elif Input.is_action_pressed("move_right"):
    angular_velocity.z -= force * delta

func move_to_last_safe_position() -> void:
  position = Vector3.ZERO # Start of the map.
  sleeping = true # Make ball stop moving.

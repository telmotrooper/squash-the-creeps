extends RigidBody3D

# Reference: https://youtu.be/G6OGM4fdF3M

var initial_camera_position: Vector3
var force = 40

func _ready() -> void:
  initial_camera_position = %Camera3D.position

func _physics_process(delta: float) -> void:
  %Camera3D.position = initial_camera_position + position

  if Input.is_action_pressed("move_forward"):
    self.angular_velocity.x -= force * delta
  elif Input.is_action_pressed("move_back"):
    self.angular_velocity.x += force * delta
  
  if Input.is_action_pressed("move_left"):
    self.angular_velocity.z += force * delta
  elif Input.is_action_pressed("move_right"):
    self.angular_velocity.z -= force * delta

extends KinematicBody
class_name Player

signal hit

export var speed := 14.0
export var jump_impulse := 25.0
export var fall_acceleration := 75.0
export var bounce_impulse := 16.0

var velocity = Vector3.ZERO

func _ready():
  GameState.Player = self

func _physics_process(delta):
  if not $AnimationPlayer.is_playing():
    $AnimationPlayer.play("float")
  
  var horizontal_rotation = $CameraPivot/Horizontal.global_transform.basis.get_euler().y
  
  if Input.is_action_just_pressed("attack"):
    $AnimationPlayer.play("spin-y")
  
  # Get direction vector based on input.
  var direction = Vector3(
      Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
      0,
      Input.get_action_strength("move_back") - Input.get_action_strength("move_forward"))
  
  # Rotate direction based on camera.
  direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()

  if direction != Vector3.ZERO and !is_spinning(): # Player is moving.
    direction = direction.normalized()
    $Pivot.look_at(translation + direction, Vector3.UP)
    
    # Move origin of CollisionShape (x,z) to origin of Pivot, so we can rotate it properly.
    # This removes the transform made to the CollisionShape (which shouldn't be in the center
    # of the character) when the player moves, but I haven't got an easy fix for that yet.
    $CollisionShape.global_transform.origin.x = $Pivot.global_transform.origin.x
    $CollisionShape.global_transform.origin.z = $Pivot.global_transform.origin.z
    $CollisionShape.rotation.y = $Pivot.rotation.y
    
    if Input.is_action_pressed("ui_sprint"): # Running.
      speed = 22
      $AnimationPlayer.playback_speed = 3.0
    else: # Walking.
      speed = 14
      $AnimationPlayer.playback_speed = 2.25
  else:
    speed = 14
    $AnimationPlayer.playback_speed = 1.0
  
  velocity.x = direction.x * speed
  velocity.z = direction.z * speed
  
  if is_on_floor() and Input.is_action_pressed("jump"):
    velocity.y += jump_impulse
  
  velocity.y -= fall_acceleration * delta
  # Assign move_and_slide to velocity prevents the velocity from accumulating.
  velocity = move_and_slide(velocity, Vector3.UP)
  
  # Handling events related to colliding with nodes below player.
  for index in get_slide_count():
    var collision = get_slide_collision(index)
    
    if collision.collider.is_in_group("enemies"):
      var enemy = collision.collider
      
      if Vector3.UP.dot(collision.normal) > 0.1:
        enemy.squash()
        velocity.y = bounce_impulse
    
    elif (collision.collider is RedButton and
          collision.collider.direction == RedButton.Direction.FLOOR and
          not collision.collider.is_pressed):
      var red_button = collision.collider
      red_button.press()
  
  # Rotate character vertically alongside a jump.
  $Pivot.rotation.x = PI / 6.0 * velocity.y / jump_impulse
  
  if is_spinning():
    for entity in $SpinArea.get_overlapping_bodies():
      if entity is Enemy:
        entity.squash()
      elif entity is RedButton:
        entity.press()

func is_spinning():
  return $AnimationPlayer.current_animation == "spin-y" and $AnimationPlayer.is_playing()

func die():
  emit_signal("hit")
  queue_free()

func _on_EnemyDetector_body_entered(_body):
    die()

func set_draw_distance(value: int):
  $CameraPivot/Horizontal/Vertical/ClippedCamera.far = value

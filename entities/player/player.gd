extends KinematicBody
class_name Player

signal hit

export var walk_speed := 14.0
export var run_speed := 22.0

export var jump_impulse := 25.0
export var fall_acceleration := 75.0
export var bounce_impulse := 16.0
export var dash_duration := 0.2
export var dash_speed := 150
export var bounce_cap := 87
export var body_slam_speed := 30

export var throw_back_y_impulse := 25
export var throw_back_speed := 20

# Starts as "forward", might behave weird depending on spawn direction.
var last_direction := Vector3(0,0,-1)

var last_safe_position := Vector3(0,0,0)

var velocity = Vector3.ZERO
var speed = 0

var is_jumping := false
var is_double_jumping := false

var dash_available := true
var is_dashing := false

var is_body_slamming := false

var just_thrown_back := false
var being_thrown_back := false

func _ready():
  GameState.Player = self
  $DashDurationTimer.wait_time = dash_duration

func _physics_process(delta):
  if not $AnimationPlayer.is_playing():
    $AnimationPlayer.play("float") # Idle animation.
  
  if Input.is_action_just_pressed("attack") and not is_dashing:
    $AnimationPlayer.play("spin-y")
  
  # Get direction vector based on input.
  var direction = Vector3(
      Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
      0,
      Input.get_action_strength("move_back") - Input.get_action_strength("move_forward"))
  
  # Rotate direction based on camera.
  var horizontal_rotation = $CameraPivot/Horizontal.global_transform.basis.get_euler().y
  direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()

  if direction != Vector3.ZERO and !is_spinning(): # Player is moving.
    direction = direction.normalized()
    
    if not being_thrown_back: # Last direction is used for throw back.
      last_direction = direction
    
    $Pivot.look_at(translation + direction, Vector3.UP)
    
    # Move origin of CollisionShape (x,z) to origin of Pivot, so we can rotate it properly.
    # This removes the transform made to the CollisionShape (which shouldn't be in the center
    # of the character) when the player moves, but I haven't got an easy fix for that yet.
    $CollisionShape.global_transform.origin.x = $Pivot.global_transform.origin.x
    $CollisionShape.global_transform.origin.z = $Pivot.global_transform.origin.z
    $CollisionShape.rotation.y = $Pivot.rotation.y
    
    if is_dashing:
      $AnimationPlayer.playback_speed = 1.0
    elif Input.is_action_pressed("sprint"): # Running.
      speed = run_speed
      $AnimationPlayer.playback_speed = 3.0
    else: # Walking.
      speed = walk_speed
      $AnimationPlayer.playback_speed = 2.25
  else: # Idle
    $AnimationPlayer.playback_speed = 1.0
  
  if GameState.upgrades["mid_air_dash"]:
    if is_on_floor():
      dash_available = true
    
    if dash_available and !is_on_floor() and Input.is_action_just_pressed("sprint"):
      if $DashDurationTimer.is_stopped():
        $AnimationPlayer.play("dash")
        is_dashing = true
        dash_available = false
        $DashDurationTimer.start()
        being_thrown_back = false # Dash cancels throw back.

    if is_dashing:
      speed = dash_speed
  
  if direction.x == 0 and direction.z == 0 and is_dashing:
    direction = last_direction
  
  if just_thrown_back: # If just thrown back, throw player up.
    velocity.y = throw_back_y_impulse
    just_thrown_back = false
  elif is_on_floor():
    being_thrown_back = false
  
  if being_thrown_back:
    is_jumping = true
    velocity.x = -last_direction.x * throw_back_speed
    velocity.z = -last_direction.z * throw_back_speed
  else: # Move player.
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed
  
  if is_on_floor():
    is_body_slamming = false
  
  if not is_jumping and Input.is_action_pressed("jump"): # Single jump.
    velocity.y = jump_impulse
    is_jumping = true
  elif is_on_floor() and not get_slide_collision(0).collider is Enemy: # Reset both jumps.
    is_jumping = false
    is_double_jumping = false
    var safe_position = (
      is_instance_valid($RayCasts/RayCast.get_collider()) and
      $RayCasts/RayCast.get_collider() == $RayCasts/RayCast2.get_collider() and
      $RayCasts/RayCast.get_collider() == $RayCasts/RayCast3.get_collider() and
      $RayCasts/RayCast.get_collider() == $RayCasts/RayCast4.get_collider()
    )
    if safe_position:
      last_safe_position = Vector3(global_transform.origin.x, global_transform.origin.y, global_transform.origin.z)
  elif is_on_floor() and get_slide_collision(0).collider is Enemy: # Reset double jump.
    is_double_jumping = false
  elif GameState.upgrades["double_jump"] and (is_jumping and not is_double_jumping
        and velocity.y <= 20 # Only allow double jump after player slows down a bit.
        and Input.is_action_just_pressed("jump")):
    is_double_jumping = true
    velocity.y = jump_impulse * 1.3 # Double jump goes higher than single jump.
    being_thrown_back = false # Double jump cancels throw back.
  elif GameState.upgrades["body_slam"] and is_double_jumping and Input.is_action_just_pressed("body_slam"):
    is_body_slamming = true
    velocity.y = -body_slam_speed
  
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
        if Input.is_action_pressed("jump"):
          velocity.y = jump_impulse + bounce_impulse # Bounce when squashing an enemy and holding "jump".
        else:
          velocity.y = jump_impulse
        is_jumping = true
    
    elif collision.collider is RedButton:
      var red_button = collision.collider
      
      if red_button.direction == RedButton.Direction.FLOOR and not red_button.is_pressed:
        red_button.press()
    
    elif is_body_slamming and collision.collider.is_in_group("breakable_floor"):
      var parent = collision.collider.get_parent()
      if parent.get_class() == "MeshInstance":
        parent.queue_free()
  
  # Rotate character vertically alongside a jump.
  $Pivot.rotation.x = PI / 6.0 * velocity.y / jump_impulse
  
  if is_spinning():
    for entity in $SpinArea.get_overlapping_bodies():
      if entity.is_in_group("enemies"):
        entity.squash()
      elif entity is RedButton:
        entity.press()
  
  # Prevent the player from going too high when bouncing off a slope.
  if velocity.y > bounce_cap:
    velocity.y = bounce_cap

func is_spinning():
  return $AnimationPlayer.current_animation == "spin-y" and $AnimationPlayer.is_playing()

func die():
  emit_signal("hit")
  queue_free()

func _on_EnemyDetector_body_entered(_body): # hurt
  just_thrown_back = true
  being_thrown_back = true

func set_draw_distance(value: int):
  $CameraPivot/Horizontal/Vertical/ClippedCamera.far = value

func _on_DashDurationTimer_timeout():
  is_dashing = false

func move_to_last_safe_position():
  global_transform.origin = Vector3(last_safe_position.x, last_safe_position.y, last_safe_position.z)

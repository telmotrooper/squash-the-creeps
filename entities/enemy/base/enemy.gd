extends KinematicBody
class_name Enemy

var already_squashed := false

export (AudioStream) var squash_sound
export var min_speed := 10.0
export var max_speed := 18.0
export var affected_by_gravity := true

var velocity = Vector3.ZERO

func _physics_process(_delta):
  if affected_by_gravity:
    if not is_on_floor():
      velocity.y = -10
    else:
      velocity.y = 0
  velocity = move_and_slide(velocity, Vector3.UP)

func initiliaze(start_position, player_position, rotate = true, speed = null):
  translation = start_position
  look_at(player_position, Vector3.UP)
  # Ignore height of player position, spawn looking straight.
  rotation.x = 0
  
  # Rotate between -45 degrees and 45 degrees.
  if rotate:
    rotate_y(rand_range(-PI / 4.0, PI / 4.0))
  
  if speed == null:
    speed = rand_range(min_speed, max_speed)
  
  velocity = Vector3.FORWARD * speed
  velocity = velocity.rotated(Vector3.UP, rotation.y)
  $AnimationPlayer.playback_speed = speed / min_speed

func squash():
  if !already_squashed:
    already_squashed = true
    velocity = Vector3.ZERO
    $CollisionShape.disabled = true
    $AnimationPlayer.playback_speed = 1
    $AnimationPlayer.play("squash")
    GameState.play_audio(squash_sound)

func _on_VisibilityNotifier_screen_exited():
  queue_free()

func kill(): # Triggered by animation "squash'.
  queue_free()

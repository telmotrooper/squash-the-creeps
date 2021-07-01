extends KinematicBody

signal squashed

export var min_speed := 10.0
export var max_speed := 18.0

var velocity = Vector3.ZERO

func _physics_process(_delta):
  move_and_slide(velocity, Vector3.UP)

func initiliaze(start_position, player_position):
  translation = start_position
  look_at(player_position, Vector3.UP)
  # Rotate between -45 degrees and 45 degrees.
  rotate_y(rand_range(-PI / 4.0, PI / 4.0))
  
  var random_speed = rand_range(min_speed, max_speed)
  velocity = Vector3.FORWARD * random_speed
  velocity = velocity.rotated(Vector3.UP, rotation.y)
  $AnimationPlayer.playback_speed = random_speed / min_speed

func squash():
  emit_signal("squashed")
  velocity = Vector3.ZERO
  $CollisionShape.disabled = true
  $AnimationPlayer.playback_speed = 1
  $AnimationPlayer.play("squash")
  GameState.Audio.play("res://art/slimejump.ogg")

func _on_VisibilityNotifier_screen_exited():
  queue_free()

func kill():
  queue_free()

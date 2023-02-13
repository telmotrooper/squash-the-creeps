extends Enemy
class_name BlueEnemy

@export var patrolling_speed := 9
@export var chasing_speed := 13
enum {
  PATROLLING,
  ALERT,
  CHASING
}

var state = PATROLLING

func _ready() -> void:
  if get_parent() is PathFollow3D:
    # This will make the enemy look to the correct direction along the path.
    get_parent().set_rotation_mode(4)

func _physics_process(delta: float) -> void:
  match state:
    PATROLLING:
      if get_parent() is PathFollow3D:
        get_parent().set_offset(get_parent().get_offset() + patrolling_speed * delta)
    ALERT:
      $ExclamationMark.visible = true
      $AlertTimer.start()
      set_physics_process(false)
    CHASING:
      if get_parent() is PathFollow3D:
        # Reset rotation, otherwise enemy won't be able to chase player.
        get_parent().rotation = Vector3.ZERO
      if is_instance_valid(GameState.Player) and not already_squashed:
        initiliaze(self.transform.origin, GameState.Player.transform.origin, false, chasing_speed)

func _on_VisibilityNotifier_screen_exited() -> void:
  pass # Prevent "queue_free()" from parent.

func _on_PrismArea_body_entered(_body: Node) -> void:
  if state != CHASING:
    state = ALERT

func squash() -> void:
  # When squashed, always hide exclamation mark.
  $ExclamationMark.visible = false
  super.squash()

func _on_AlertTimer_timeout() -> void:
  $ExclamationMark.visible = false
  state = CHASING
  set_physics_process(true)

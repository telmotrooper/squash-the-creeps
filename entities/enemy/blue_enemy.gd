extends Enemy

export var patrolling_speed = 9
export var chasing_speed = 13
enum {
  PATROLLING,
  ALERT,
  CHASING
}

var state = PATROLLING

func _ready():
  if get_parent() is PathFollow:
    # This will make the enemy look to the correct direction along the path.
    get_parent().set_rotation_mode(4)

func _process(delta):
  match state:
    PATROLLING:
      if get_parent() is PathFollow:
        get_parent().set_offset(get_parent().get_offset() + patrolling_speed * delta)
    ALERT:
      $ExclamationMark.visible = true
      $AlertTimer.start()
      set_process(false)
    CHASING:
      if get_parent() is PathFollow:
        # Reset rotation, otherwise enemy won't be able to chase player.
        get_parent().rotation = Vector3.ZERO
      if is_instance_valid(GameState.Player):
        initiliaze(self.transform.origin, GameState.Player.transform.origin, false, chasing_speed)

func _on_VisibilityNotifier_screen_exited():
  pass # Prevent "queue_free()" from parent.

func _on_PrismArea_body_entered(_body):
  if state != CHASING:
    state = ALERT

func _on_AlertTimer_timeout():
  $ExclamationMark.visible = false
  state = CHASING
  set_process(true)

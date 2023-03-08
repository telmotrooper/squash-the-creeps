extends Enemy
class_name BlueEnemy

@export var patrolling_speed := 9
@export var chasing_speed := 13

enum { PATROLLING, ALERT, CHASING }
enum { GOING, RETURNING }

var state = PATROLLING
var path_state = GOING

func _ready() -> void:
  if get_parent() is PathFollow3D:
    # Make the enemy look to the correct direction along the path.
    get_parent().set_rotation_mode(4)

func _physics_process(delta: float) -> void:
  super._physics_process(delta)
  
  if get_parent() is PathFollow3D and not get_parent().loop:
    # If path follow doesn't loop, go in reverse.
    var progress_ratio = get_parent().progress_ratio
    
    if progress_ratio <= 0 and path_state == RETURNING:
      path_state = GOING
      rotation_degrees.y += 180
    elif progress_ratio >= 1 and path_state == GOING:
      path_state = RETURNING
      rotation_degrees.y -= 180
  
  match state:
    PATROLLING:
      if get_parent() is PathFollow3D:
        if path_state == GOING:
          get_parent().progress += patrolling_speed * delta
        elif path_state == RETURNING:
          get_parent().progress -= patrolling_speed * delta
    ALERT:
      $ExclamationMark.show()
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
  $ExclamationMark.hide()
  super.squash()

func _on_AlertTimer_timeout() -> void:
  $ExclamationMark.hide()
  state = CHASING
  set_physics_process(true)

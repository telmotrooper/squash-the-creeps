extends Enemy

enum { PATROLLING, ALERT }

var state = PATROLLING

export var patrolling_speed = 4
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0

func _ready():
  if patrol_path:
    patrol_points = get_node(patrol_path).curve.get_baked_points()

func _physics_process(delta):
  var position = self.transform.origin
  
  match state:
    PATROLLING:
      if !patrol_path:
        return
      var target = patrol_points[patrol_index]
      if position.distance_to(target) < 1:
        patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
        target = patrol_points[patrol_index]
      velocity = (target - position).normalized() * patrolling_speed
      velocity = move_and_slide(velocity)
      look_at(transform.origin + velocity, Vector3.UP)
    ALERT:
      if is_instance_valid(GameState.Player):
        initiliaze(position, GameState.Player.transform.origin, false)

func _on_VisibilityNotifier_screen_exited():
  pass # Prevent "queue_free()" from parent.

func _on_PrismArea_body_entered(body):
  if body is Player:
    state = ALERT

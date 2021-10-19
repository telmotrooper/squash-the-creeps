extends Enemy

onready var raycast = $RayCast

enum {
  IDLE,
  PATROLLING,
  ALERT
}

var state = PATROLLING
export var point1 = Vector3(-7, 0, -13)
export var point2 = Vector3(7, 0, -13)

var going_to = point1

func _process(delta):
  if going_to.distance_to(self.transform.origin) < 0.1:
    going_to = point1 if going_to == point2 else point2

  if raycast.is_colliding():
    state = ALERT
  
  match state:
    IDLE:
      print("IDLE")
    PATROLLING:
      initiliaze(self.transform.origin, going_to, false)
    ALERT:
      if is_instance_valid(GameState.Player):
        initiliaze(self.transform.origin, GameState.Player.transform.origin, false)

func _on_VisibilityNotifier_screen_exited():
  pass # Prevent "queue_free()" from parent.

extends Enemy

onready var raycast = $RayCast

enum {
  IDLE,
  PATROLLING,
  ALERT
}

var state = IDLE

func _ready():
  pass

func _process(delta):
  if raycast.is_colliding():
    state = ALERT
  
  match state:
    IDLE:
      print("IDLE")
    PATROLLING:
      print("PATROLLING")
    ALERT:
      print("ALERT")
      if is_instance_valid(GameState.Player):
        initiliaze(self.transform.origin, GameState.Player.transform.origin, false)

func _on_VisibilityNotifier_screen_exited():
  pass # Prevent "queue_free()" from parent.

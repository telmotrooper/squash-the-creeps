extends Enemy

enum {
  IDLE,
  PATROLLING,
  ALERT
}

var state = PATROLLING

export var point1 = Vector3(-7, 0, 0)
export var point2 = Vector3(7, 0, 0)
export var patrolling_speed = 9

var initial_position
var global_point_1
var global_point_2
var going_to

func _ready():
  initial_position = Vector3(
    self.global_transform.origin.x,
    self.global_transform.origin.y,
    self.global_transform.origin.z)
  
  global_point_1 = Vector3(
    initial_position.x + point1.x,
    initial_position.y + point1.y,
    initial_position.z + point1.z)
    
  global_point_2 = Vector3(
    initial_position.x + point2.x,
    initial_position.y + point2.y,
    initial_position.z + point2.z)
  
  going_to = global_point_1

func _process(delta):
  match state:
    IDLE:
      pass
    PATROLLING:
      if going_to != null:
        if going_to.distance_to(self.transform.origin) < 0.2:
          going_to = global_point_1 if going_to == global_point_2 else global_point_2
        initiliaze(self.transform.origin, going_to, false, patrolling_speed)
    ALERT:
      if is_instance_valid(GameState.Player):
        initiliaze(self.transform.origin, GameState.Player.transform.origin, false)

func _on_VisibilityNotifier_screen_exited():
  pass # Prevent "queue_free()" from parent.

func _on_PrismArea_body_entered(body):
  if body is Player:
    state = ALERT

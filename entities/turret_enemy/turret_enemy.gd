extends Node3D

enum { IDLE, ALERT, ATTACKING }

var state = IDLE

func _ready() -> void:
  pass

func _physics_process(_delta: float) -> void:
  match state:
    IDLE:
      pass
    ALERT:
      pass
    ATTACKING:
      pass


func _on_area_3d_body_entered(body: Node3D) -> void:
  print("body entered")
  state = ALERT

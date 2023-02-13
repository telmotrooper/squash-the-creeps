extends StaticBody3D

@onready var tween = get_node("Tween")

@export var duration: float = 3
@export var move_y: float = -1

var transition_type := Tween.TRANS_BACK
var initial_y: float
var final_y: float
var last: String

func _ready() -> void:
  initial_y = position.y
  final_y = position.y + move_y
  
  go_final()

func go_final() -> void:
  last = "final"
  tween.interpolate_property(self, "position:y", null,
    final_y, duration, transition_type)
  tween.start()

func go_initial() -> void:
  last = "initial"
  tween.interpolate_property(self, "position:y", null,
    initial_y, duration, transition_type)
  tween.start()

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
  if last == "final":
    go_initial()
  else:
    go_final()

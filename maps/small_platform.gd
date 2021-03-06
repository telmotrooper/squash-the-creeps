extends StaticBody

onready var tween = get_node("Tween")

export var duration: float = 3
export var move_y: float = -1

var transition_type := Tween.TRANS_BACK
var initial_y: float
var final_y: float
var last

func _ready():
  initial_y = translation.y
  final_y = translation.y + move_y
  
  go_final()

func go_final():
  last = "final"
  tween.interpolate_property(self, "translation:y", null,
    final_y, duration, transition_type)
  tween.start()

func go_initial():
  last = "initial"
  tween.interpolate_property(self, "translation:y", null,
    initial_y, duration, transition_type)
  tween.start()

func _on_Tween_tween_completed(_object, _key):
  if last == "final":
    go_initial()
  else:
    go_final()

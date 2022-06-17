extends StaticBody

onready var tween = get_node("Tween")

var duration: float = 3
var initial_y: float
var final_y: float
var last

func _ready():
  initial_y = translation.y
  final_y = translation.y - 1
  
  go_down()


func _on_Tween_tween_completed(object, key):
  if last == "down":
    go_up()
  else:
    go_down()

func go_down():
  last = "down"
  tween.interpolate_property(self, "translation:y", null, final_y, duration, Tween.TRANS_BACK)
  tween.start()

func go_up():
  last = "up"
  tween.interpolate_property(self, "translation:y", null, initial_y, duration, Tween.TRANS_BACK)
  tween.start()

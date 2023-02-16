extends StaticBody3D

@export var duration: float = 3
@export var move_y: float = -1

var initial_y: float
var final_y: float
var tween: Tween

func _ready() -> void:
  initial_y = position.y
  final_y = position.y + move_y
  
  tween = create_tween().set_loops().set_trans(Tween.TRANS_BACK)

  tween.tween_property(self, "position:y", final_y, duration)
  tween.tween_property(self, "position:y", initial_y, duration)

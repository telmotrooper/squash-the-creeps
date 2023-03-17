extends ColorRect

signal finished

@export var duration = 1 # seconds

func fade_in() -> void:
  var tween = create_tween()
  tween.tween_property(self, "modulate", Color(0,0,0,0), duration) # transparent
  tween.tween_callback(func():
    hide()
    emit_signal("finished")
  )

func fade_out() -> void:
  show()
  var tween = create_tween()
  tween.tween_property(self, "modulate", Color(0,0,0,1), duration) # black
  tween.tween_callback(func(): emit_signal("finished"))

extends Label

const WHITE_TRANSPARENT := Color(1,1,1,0)
const WHITE := Color(1,1,1,1)

const fade_duration = 0.75 # seconds
const duration = 2 # seconds

signal done

func _ready() -> void:
  hide()

func fade_in() -> void:
  modulate = WHITE_TRANSPARENT
  show()
  var tween = create_tween()
  tween.tween_property(self, "modulate", WHITE, fade_duration)
  tween.tween_callback(func(): emit_signal("done"))

func fade_out() -> void:
  var tween = create_tween()
  tween.tween_property(self, "modulate", WHITE_TRANSPARENT, fade_duration)
  tween.tween_callback(hide)

func display(map_name: StringName) -> void:
  text = map_name
  fade_in()
  await done
  await get_tree().create_timer(duration).timeout
  fade_out()

extends Control

@export var animation_player: AnimationPlayer

var first_time := true

func _ready() -> void:
  hide()
  animation_player.connect("animation_started", enable)
  animation_player.connect("animation_finished", disable)
  set_process(false)

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("attack"):
    if first_time:
      show()
      first_time = false
    else:
      animation_player.play("RESET") # Skip cutscene.
      first_time = true # Reset counter for future cutscenes.
      hide()
      set_process(false)

func enable(_anim_name: StringName) -> void:
  set_process(true)

func disable(_anim_name: StringName) -> void:
  set_process(false)

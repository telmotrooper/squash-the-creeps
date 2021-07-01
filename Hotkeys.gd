extends Spatial

func _process(_delta):
  if Input.is_action_just_pressed("ui_toggle_fullscreen"):
    OS.window_fullscreen = !OS.window_fullscreen

  if Input.is_action_just_pressed("ui_fast_forward"):
    Engine.time_scale = 2.25
  elif Input.is_action_just_released("ui_fast_forward"):
    Engine.time_scale = 1

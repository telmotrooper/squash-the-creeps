extends Spatial

# Actions defined in "Project > Project Settings... > Input Map".

func _process(_delta):
  if Input.is_action_just_pressed("ui_toggle_fullscreen"):
    toggle_fullscreen()

  if Input.is_action_just_pressed("ui_fast_forward"):
    Engine.time_scale = 2.25
  elif Input.is_action_just_released("ui_fast_forward"):
    Engine.time_scale = 1
  
  if get_node_or_null("/root/Main/WorldScene/TitleScreen") and Input.is_action_just_pressed("ui_cancel"):
    get_tree().quit()

func toggle_fullscreen():
  OS.window_fullscreen = !OS.window_fullscreen
  Configuration.update_setting("graphics", "fullscreen", OS.window_fullscreen)

extends Control

func _ready():
  get_node("%MidAirDashCheckButton").pressed = Configuration.get_value("debug", "mid_air_dash")
  GameState.upgrades["mid_air_dash"] = Configuration.get_value("debug", "mid_air_dash")
  
  get_node("%DoubleJumpCheckButton").pressed = Configuration.get_value("debug", "double_jump")
  GameState.upgrades["double_jump"] = Configuration.get_value("debug", "double_jump")
  
  get_node("%BodySlamCheckButton").pressed = Configuration.get_value("debug", "body_slam")
  GameState.upgrades["body_slam"] = Configuration.get_value("debug", "body_slam")

func pause():
  get_tree().paused = not get_tree().paused
  visible = get_tree().paused
  if visible:
    get_parent().show_hud()
    GameState.get_node("BGM").volume_db = GameState.get_node("BGM").volume_db - 10
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  else:
    get_parent().hide_hud()
    GameState.get_node("BGM").volume_db = GameState.get_node("BGM").volume_db + 10
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
  if event.is_action_pressed("pause"):
    if $PauseMenu.visible:
      pause()
    else:
      return_to_pause_menu()
  
  if get_tree().paused and Input.is_action_just_pressed("ui_toggle_fullscreen"):
    Hotkeys.toggle_fullscreen()

func _on_ResumeButton_pressed():
  pause()

func _on_MainMenuButton_pressed():
  var title_screen = "res://ui/title_screen.tscn"
  if is_instance_valid($"/root/Main"):
    $"/root/Main".load_world(title_screen)
  else:
    var _error = get_tree().change_scene(title_screen)
  
  pause()
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_ExitButton_pressed():
  get_tree().quit()

func return_to_pause_menu():
  $PauseMenu.visible = true
  for submenu in $Submenus.get_children():
    submenu.visible = false

func open_submenu(node_path):
  $PauseMenu.visible = false
  get_node(node_path).visible = true

func _on_RestartMapButton_pressed():
  GameState.reload_current_scene()
  pause()

func _on_DoubleJumpCheckButton_toggled(button_pressed):
  Configuration.update_setting("debug", "double_jump", button_pressed)
  GameState.upgrades["double_jump"] = button_pressed

func _on_MidAirDashCheckButton_toggled(button_pressed: bool):
  Configuration.update_setting("debug", "mid_air_dash", button_pressed)
  GameState.upgrades["mid_air_dash"] = button_pressed

func _on_BodySlamCheckButton_toggled(button_pressed):
  Configuration.update_setting("debug", "body_slam", button_pressed)
  GameState.upgrades["body_slam"] = button_pressed

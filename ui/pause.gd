extends Control

const draw_distance_text = "Draw Distance: %d"
const sensitivity_text = "Mouse Sensitivity: %.2f"
const music_volume_text = "Music Volume: %d"
const sound_volume_text = "Sound Volume: %d"

func _ready():
  get_node("%GrassOptionButton").select(Configuration.get_value("graphics", "grass_amount"))
  
  if GameState.MapName: # TODO: Find a way to find option from label (maybe iterate through the items?)
    if GameState.MapName == 'hub_1':
      get_node("%MapOptionButton").select(0)
    elif (GameState.MapName == 'test_map'):
      get_node("%MapOptionButton").select(1)
    elif (GameState.MapName == 'lake_map'):
      get_node("%MapOptionButton").select(2)
  
  get_node("%DrawDistanceLabel").text = draw_distance_text % Configuration.get_value("graphics", "draw_distance")
  get_node("%DrawDistanceSlider").value = Configuration.get_value("graphics", "draw_distance")
  
  get_node("%SensitivityLabel").text = sensitivity_text % Configuration.get_value("controls", "mouse_sensitivity")
  get_node("%SensitivitySlider").value = Configuration.get_value("controls", "mouse_sensitivity")
  
  get_node("%MusicVolumeLabel").text = music_volume_text % Configuration.get_value("audio", "music_volume")
  get_node("%MusicVolumeSlider").value = Configuration.get_value("audio", "music_volume")
  
  get_node("%SoundVolumeLabel").text = sound_volume_text % Configuration.get_value("audio", "sound_volume")
  get_node("%SoundVolumeSlider").value = Configuration.get_value("audio", "sound_volume")

  get_node("%MidAirDashCheckButton").pressed = Configuration.get_value("debug", "mid_air_dash")
  GameState.upgrades["mid_air_dash"] = Configuration.get_value("debug", "mid_air_dash")
  
  get_node("%DoubleJumpCheckButton").pressed = Configuration.get_value("debug", "double_jump")
  GameState.upgrades["double_jump"] = Configuration.get_value("debug", "double_jump")
  
  get_node("%BodySlamCheckButton").pressed = Configuration.get_value("debug", "body_slam")
  GameState.upgrades["body_slam"] = Configuration.get_value("debug", "body_slam")

func _on_DrawDistanceSlider_value_changed(value):
  Configuration.update_setting("graphics", "draw_distance", value)
  get_node("%DrawDistanceLabel").text = draw_distance_text % value
  GameState.Player.set_draw_distance(value)

func _on_SensitivitySlider_value_changed(value):
  Configuration.update_setting("controls", "mouse_sensitivity", value)
  get_node("%SensitivityLabel").text = sensitivity_text % value

func _on_MusicVolumeSlider_value_changed(value):
  Configuration.update_setting("audio", "music_volume", value)
  get_node("%MusicVolumeLabel").text = music_volume_text % value
  Configuration.set_volume("Music", value)

func _on_SoundVolumeSlider_value_changed(value):
  Configuration.update_setting("audio", "sound_volume", value)
  get_node("%SoundVolumeLabel").text = sound_volume_text % value
  Configuration.set_volume("Sound", value)

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

func _on_ToggleFullscreenButton_pressed():
  OS.window_fullscreen = !OS.window_fullscreen
  Configuration.update_setting("graphics", "fullscreen", OS.window_fullscreen)

func _on_GrassOptionButton_item_selected(index):
  GameState.update_grass(index)

func _on_MapOptionButton_item_selected(index):
  var map_name = get_node("%MapOptionButton").get_item_text(index)
  GameState.change_map(map_name)
  pause()

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

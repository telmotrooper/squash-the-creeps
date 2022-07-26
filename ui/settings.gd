extends VBoxContainer

export (bool) var is_title_screen = false

const draw_distance_text = "Draw Distance: %d"
const sensitivity_text = "Mouse Sensitivity: %.2f"
const music_volume_text = "Music Volume: %d"
const sound_volume_text = "Sound Volume: %d"

signal back_button_pressed
signal unpause

func _ready():
  if is_title_screen:
    get_node("%MapLabel").visible = false
    get_node("%MapOptionButton").visible = false
  
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

func _on_DrawDistanceSlider_value_changed(value):
  Configuration.update_setting("graphics", "draw_distance", value)
  get_node("%DrawDistanceLabel").text = draw_distance_text % value
  if is_instance_valid(GameState.Player):
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

func _on_GrassOptionButton_item_selected(index):
  GameState.update_grass(index)

func _on_MapOptionButton_item_selected(index):
  var map_name = get_node("%MapOptionButton").get_item_text(index)
  GameState.change_map(map_name)
  emit_signal("unpause")

func _on_ToggleFullscreenButton_pressed():
  OS.window_fullscreen = !OS.window_fullscreen
  Configuration.update_setting("graphics", "fullscreen", OS.window_fullscreen)

func _on_BackButton_pressed():
  emit_signal("back_button_pressed")

func _on_ResetButton_pressed() -> void:
  $ConfirmationDialog.popup_centered()

func _on_ConfirmationDialog_confirmed() -> void:
  print("reset settings")

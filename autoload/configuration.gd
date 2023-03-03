extends Node

var file_path = "user://settings.cfg"
@onready var config = ConfigFile.new()

const min_volume := -60
const max_volume := 0

var defaults: Dictionary = {
  "audio": {
    "music_volume": 80,
    "sound_volume": 80
  },
  "controls": {
    "mouse_sensitivity": 0.5
  },
  "graphics": {
    "fullscreen": false,
    "draw_distance": 200,
    "grass_amount": 0
  },
  "debug": {
    "body_slam": true,
    "double_jump": true,
    "mid_air_dash": true
  }
}

func _ready() -> void:
  if OS.get_name() == "Windows" or OS.get_name() == "UWP":
    defaults.controls.mouse_sensitivity = 0.3
  
  var load_file = config.load(file_path)
  
  if load_file != OK:
    config.save(file_path)
  
  set_default_values(defaults)
  
  # Handle fullscreen
  if config.get_value("graphics", "fullscreen") == true:
    get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (true) else Window.MODE_WINDOWED
  
  # Handle music volume
  var music_volume = config.get_value("audio", "music_volume")
  set_volume("Music", music_volume)
  
  # Handle sound volume
  var sound_volume = config.get_value("audio", "sound_volume")
  set_volume("Sound", sound_volume)

func update_setting(section: String, key: String, value) -> void:
  config.set_value(section, key, value)
  config.save(file_path)

func get_value(section: String, key: String):
  return config.get_value(section, key)

func denormalize_volume(volume: float) -> float:
  return (max_volume - min_volume) * volume/100 + min_volume

func set_volume(bus_name: String, volume: float) -> void:
  var bus_index = AudioServer.get_bus_index(bus_name)
  var volume_in_db = denormalize_volume(volume)
  
  if volume == 0:
    volume_in_db = -80

  AudioServer.set_bus_volume_db(bus_index, volume_in_db)

func set_default_values(new_defaults: Dictionary) -> void:
  for section in new_defaults:
    for key in new_defaults[section]:
      if not config.has_section_key(section, key):
        config.set_value(section, key, new_defaults[section][key])

func reset_settings() -> void:
  for section in defaults:
    if section != "debug": # For now we don't reset player upgrades.
      for key in defaults[section]:
        config.set_value(section, key, defaults[section][key])
        
  GameState.update_grass()

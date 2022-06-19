extends Node

var file_path = "user://settings.cfg"
onready var config = ConfigFile.new()

const min_volume = -60
const max_volume = 0

func _ready():
  var load_file = config.load(file_path)
  
  if load_file != OK:
    config.save(file_path)
  
  # Set default values if missing
  if not config.has_section_key("audio", "music_volume"):
    config.set_value("audio", "music_volume", 80)
  
  if not config.has_section_key("audio", "sound_volume"):
    config.set_value("audio", "sound_volume", 80)
  
  if not config.has_section_key("controls", "mouse_sensitivity"):
    config.set_value("controls", "mouse_sensitivity", 0.5)
  
  if not config.has_section_key("graphics", "fullscreen"):
    config.set_value("graphics", "fullscreen", false)
  
  if not config.has_section_key("graphics", "draw_distance"):
    config.set_value("graphics", "draw_distance", 200)
  
  if not config.has_section_key("graphics", "grass_amount"):
    config.set_value("graphics", "grass_amount", 0)
    
  if not config.has_section_key("debug", "double_jump"):
    config.set_value("debug", "double_jump", false)
  
  if not config.has_section_key("debug", "mid_air_dash"):
    config.set_value("debug", "mid_air_dash", false)
  
  # Handle fullscreen
  if config.get_value("graphics", "fullscreen") == true:
    OS.window_fullscreen = true
  
  # Handle music volume
  var music_volume = config.get_value("audio", "music_volume")
  set_volume("Music", music_volume)
  
  # Handle sound volume
  var sound_volume = config.get_value("audio", "sound_volume")
  set_volume("Sound", sound_volume)

func update_setting(section, key, value):
  config.set_value(section, key, value)
  config.save(file_path)

func get_value(section, key):
  return config.get_value(section, key)

func denormalize_volume(volume: float):
  return (max_volume - min_volume) * volume/100 + min_volume

func set_volume(bus_name: String, volume: float):
  var bus_index = AudioServer.get_bus_index(bus_name)
  var volume_in_db = denormalize_volume(volume)
  
  if volume == 0:
    volume_in_db = -80

  AudioServer.set_bus_volume_db(bus_index, volume_in_db)

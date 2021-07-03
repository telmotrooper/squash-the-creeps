extends Node

var file_path = "user://settings.cfg"
onready var config = ConfigFile.new()

func _ready():
  var load_file = config.load(file_path)
  
  if load_file != OK:
    config.set_value("audio", "music_volume", 100)
    config.set_value("audio", "sound_volume", 100)
    config.set_value("controls", "mouse_sensitivity", 0.5)
    config.set_value("display", "fullscreen", false)
    config.save(file_path)
  
  if config.get_value("display", "fullscreen") == true:
    OS.window_fullscreen = true

func update_setting(section, key, value):
  config.set_value(section, key, value)
  config.save(file_path)

func get_value(section, key):
  return config.get_value(section, key)

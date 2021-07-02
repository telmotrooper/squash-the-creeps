extends Node

var file_path = "user://settings.cfg"
onready var config = ConfigFile.new()

func _ready():
  var load_file = config.load(file_path)
  
  if load_file == OK:
    GameState.mouse_sensitivity = config.get_value("controls", "mouse_sensitivity", 0.5)
  else:
    config.set_value("controls", "mouse_sensitivity", 0.5) 
    config.save(file_path)

func update_setting(section, key, value):
  config.set_value(section, key, value)
  config.save(file_path)

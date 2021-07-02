extends Node

var file_path = "user://settings.cfg"
onready var config = ConfigFile.new()

func _ready():
  var load_file = config.load(file_path)
  
  if load_file == OK:
    var mouse_sensitivity = config.get_value("controls", "mouse_sensitivity")
  else:
    config.set_value("controls", "mouse_sensitivity", 0.5) 
    config.save(file_path)

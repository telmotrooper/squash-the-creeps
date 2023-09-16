extends Node3D

# Actions defined in "Project > Project Settings... > Input Map".

var title_screen: Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_toggle_fullscreen"):
		toggle_fullscreen()

#  if Input.is_action_just_pressed("ui_fast_forward"):
#    Engine.time_scale = 2.25
#  elif Input.is_action_just_released("ui_fast_forward"):
#    Engine.time_scale = 1
	
	if Input.is_action_just_pressed("print_screen"):
		var screenshot = get_viewport().get_texture().get_data()
		screenshot.flip_y()
		screenshot.save_png("user://squash_%s.png" % Time.get_unix_time_from_system())
	
	if Input.is_action_just_pressed("show_hud") and is_instance_valid(GameState.UserInterface):
		GameState.UserInterface.show_hud()
	
	title_screen = get_node_or_null("/root/Main/WorldScene/TitleScreen")
	
	if title_screen and not title_screen.submenu_open and Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func toggle_fullscreen() -> void:
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	Configuration.update_setting("graphics", "fullscreen", ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))
	if is_instance_valid(GameState.UserInterface):
		GameState.UserInterface.resize_minimap()

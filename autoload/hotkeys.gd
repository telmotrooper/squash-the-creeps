extends Node3D

# Actions defined in "Project > Project Settings... > Input Map".

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_toggle_fullscreen"):
		toggle_fullscreen()

	# if Input.is_action_just_pressed("ui_fast_forward"):
	# 	Engine.time_scale = 2.25
	# elif Input.is_action_just_released("ui_fast_forward"):
	# 	Engine.time_scale = 1
	
	if Input.is_action_just_pressed("print_screen"):
		var screenshot = get_viewport().get_texture().get_data()
		screenshot.flip_y()
		screenshot.save_png("user://squash_%s.png" % Time.get_unix_time_from_system())
	
	if Input.is_action_just_pressed("show_hud"):
		UserInterface.show_hud()

func toggle_fullscreen() -> void:
	get_window().mode = Window.MODE_FULLSCREEN if (!((get_window().mode == Window.MODE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	Configuration.update_setting("graphics", "fullscreen", ((get_window().mode == Window.MODE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))
	UserInterface.resize_minimap()

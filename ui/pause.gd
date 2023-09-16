extends Control

func _ready() -> void:
	%MidAirDashCheckButton.button_pressed = Configuration.get_value("debug", "mid_air_dash")
	GameState.upgrades["mid_air_dash"] = Configuration.get_value("debug", "mid_air_dash")
	
	%DoubleJumpCheckButton.button_pressed = Configuration.get_value("debug", "double_jump")
	GameState.upgrades["double_jump"] = Configuration.get_value("debug", "double_jump")
	
	%BodySlamCheckButton.button_pressed = Configuration.get_value("debug", "body_slam")
	GameState.upgrades["body_slam"] = Configuration.get_value("debug", "body_slam")

func pause() -> void:
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused
	if visible:
		get_parent().show_hud()
		GameState.change_bgm_volume(-10)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		get_parent().hide_hud()
		GameState.change_bgm_volume(+10)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if $PauseMenu.visible:
			pause()
		else:
			return_to_pause_menu()
	
	if get_tree().paused and Input.is_action_just_pressed("ui_toggle_fullscreen"):
		Hotkeys.toggle_fullscreen()

func _on_ResumeButton_pressed() -> void:
	pause()

func _on_MainMenuButton_pressed() -> void:
	var title_screen = "res://ui/title_screen.tscn"
	if is_instance_valid($"/root/Main"):
		$"/root/Main".load_scene(title_screen)
	else:
		var _error = get_tree().change_scene_to_file(title_screen)
	
	pause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_ExitButton_pressed() -> void:
	get_tree().quit()

func return_to_pause_menu() -> void:
	$PauseMenu.show()
	for submenu in $Submenus.get_children():
		submenu.hide()

func open_submenu(node_path: NodePath) -> void:
	$PauseMenu.hide()
	get_node(node_path).show()

func _on_RestartMapButton_pressed() -> void:
	GameState.reload_current_scene()
	pause()

func _on_DoubleJumpCheckButton_toggled(button_pressed: bool) -> void:
	Configuration.update_setting("debug", "double_jump", button_pressed)
	GameState.upgrades["double_jump"] = button_pressed

func _on_MidAirDashCheckButton_toggled(button_pressed: bool) -> void:
	Configuration.update_setting("debug", "mid_air_dash", button_pressed)
	GameState.upgrades["mid_air_dash"] = button_pressed

func _on_BodySlamCheckButton_toggled(button_pressed: bool) -> void:
	Configuration.update_setting("debug", "body_slam", button_pressed)
	GameState.upgrades["body_slam"] = button_pressed

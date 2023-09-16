extends Node

const MENU_FADE_OUT = "menu_fade_out"
@export var new_game_scene: PackedScene
@export var menu_music: AudioStream

var submenu_open := false
var button_pressed: String

func _ready() -> void:
	# Workaround so menu button labels are correctly displayed when the game is exported.
	%NewGameButton.button_text = "NEW GAME"
	%ContinueButton.button_text = "CONTINUE"
	%SettingsButton.button_text = "SETTINGS"
	%ExitButton.button_text = "EXIT"
	
	GameState.play_music(menu_music)
	var version = Engine.get_version_info()
	%VersionLabel.text = "DEMO RELEASE – GODOT %d.%d.%d" % [version.major, version.minor, version.patch]
	
	%Settings.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and submenu_open:
		_on_Settings_back_button_pressed()

func _on_menu_button_pressed(button_name: String) -> void:
	submenu_open = true
	button_pressed = button_name
	$AnimationPlayerMenu.play(MENU_FADE_OUT)

func _on_AnimationPlayerMenu_animation_finished(anim_name: String) -> void:
	if anim_name == MENU_FADE_OUT:
		if button_pressed == "new_game":
			GameState.MapName = "hub_1"
			if is_instance_valid($"/root/Main"):
				$"/root/Main".load_scene(new_game_scene.get_path())
				GameState.initialize()
			else:
				var _error = get_tree().change_scene_to_file(new_game_scene.get_path())
		elif button_pressed == "settings":
			%Settings.show()
		elif button_pressed == "exit":
			get_tree().quit()

func _on_AnimationPlayerSpaceship_animation_finished(anim_name: String) -> void:
	if anim_name == "coming_in":
		$Node3D/AnimationPlayerSpaceship.play("flying_in_space")

func _on_CenterContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and $Node3D/AnimationPlayerSpaceship.current_animation == "flying_in_space":
		$Node3D/AnimationPlayerAlien.play("spin_y")

func _on_Settings_back_button_pressed() -> void:
	%Settings.hide()
	submenu_open = false
	$AnimationPlayerMenu.play("menu_fade_in_fast")

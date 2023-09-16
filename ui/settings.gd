extends VBoxContainer

@export var is_title_screen: bool = false

const draw_distance_text = "Draw Distance: %d"
const sensitivity_text = "Mouse Sensitivity: %.2f"
const music_volume_text = "Music Volume: %d"
const sound_volume_text = "Sound Volume: %d"

signal back_button_pressed
signal unpause

func _ready() -> void:
	if is_title_screen:
		%MapLabel.hide()
		%MapOptionButton.hide()
	
	refresh_values()

func refresh_values() -> void:
	%GrassOptionButton.select(Configuration.get_value("graphics", "grass_amount"))

	if GameState.MapName: # TODO: Find a way to find option from label (maybe iterate through the items?)
		if GameState.MapName == 'hub_1':
			%MapOptionButton.select(0)
		elif (GameState.MapName == 'avocado_beach'):
			%MapOptionButton.select(1)
		elif (GameState.MapName == 'lake_map'):
			%MapOptionButton.select(2)
	
	%DrawDistanceLabel.text = draw_distance_text % Configuration.get_value("graphics", "draw_distance")
	%DrawDistanceSlider.value = Configuration.get_value("graphics", "draw_distance")
	
	%SensitivityLabel.text = sensitivity_text % Configuration.get_value("controls", "mouse_sensitivity")
	%SensitivitySlider.value = Configuration.get_value("controls", "mouse_sensitivity")
	
	%MusicVolumeLabel.text = music_volume_text % Configuration.get_value("audio", "music_volume")
	%MusicVolumeSlider.value = Configuration.get_value("audio", "music_volume")
	
	%SoundVolumeLabel.text = sound_volume_text % Configuration.get_value("audio", "sound_volume")
	%SoundVolumeSlider.value = Configuration.get_value("audio", "sound_volume")

func _on_DrawDistanceSlider_value_changed(value):
	Configuration.update_setting("graphics", "draw_distance", value)
	%DrawDistanceLabel.text = draw_distance_text % value
	if is_instance_valid(GameState.Player):
		GameState.Player.set_draw_distance(value)

func _on_SensitivitySlider_value_changed(value):
	Configuration.update_setting("controls", "mouse_sensitivity", value)
	%SensitivityLabel.text = sensitivity_text % value

func _on_MusicVolumeSlider_value_changed(value):
	Configuration.update_setting("audio", "music_volume", value)
	%MusicVolumeLabel.text = music_volume_text % value
	Configuration.set_volume("Music", value)

func _on_SoundVolumeSlider_value_changed(value):
	Configuration.update_setting("audio", "sound_volume", value)
	%SoundVolumeLabel.text = sound_volume_text % value
	Configuration.set_volume("Sound", value)

func _on_GrassOptionButton_item_selected(index):
	GameState.update_grass(index)

func _on_MapOptionButton_item_selected(index):
	var map_name = %MapOptionButton.get_item_text(index)
	GameState.change_map(map_name)
	emit_signal("unpause")

func _on_ToggleFullscreenButton_pressed():
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	Configuration.update_setting("graphics", "fullscreen", ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))

func _on_BackButton_pressed():
	emit_signal("back_button_pressed")

func _on_ResetButton_pressed() -> void:
	$ConfirmationDialog.popup_centered()

func _on_ConfirmationDialog_confirmed() -> void:
	Configuration.reset_settings()
	refresh_values()

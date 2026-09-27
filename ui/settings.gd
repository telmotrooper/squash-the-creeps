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
	
	visibility_changed.connect(_on_visibility_changed)

func refresh_values() -> void:
	var grass_option := 0 if Configuration.grass_enabled() else 1
	%GrassOptionButton.select(grass_option)

	var map_index := find_map_index(GameState.current_map_name)
	if map_index != -1:
		%MapOptionButton.select(map_index)
	
	%DrawDistanceLabel.text = draw_distance_text % Configuration.draw_distance()
	%DrawDistanceSlider.value = Configuration.draw_distance()
	
	%SensitivityLabel.text = sensitivity_text % Configuration.get_value("controls", "mouse_sensitivity")
	%SensitivitySlider.value = Configuration.get_value("controls", "mouse_sensitivity")
	
	%MusicVolumeLabel.text = music_volume_text % Configuration.get_value("audio", "music_volume")
	%MusicVolumeSlider.value = Configuration.get_value("audio", "music_volume")
	
	%SoundVolumeLabel.text = sound_volume_text % Configuration.get_value("audio", "sound_volume")
	%SoundVolumeSlider.value = Configuration.get_value("audio", "sound_volume")

func find_map_index(map_name: String) -> int:
	for i in range(%MapOptionButton.item_count):
		if %MapOptionButton.get_item_text(i) == map_name:
			return i
	return -1

func _on_visibility_changed() -> void:
	if visible:
		refresh_values()

func _on_DrawDistanceSlider_value_changed(value):
	Configuration.update_draw_distance(value)
	%DrawDistanceLabel.text = draw_distance_text % value

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
	var enabled: bool = index == 0
	Configuration.update_grass(enabled)

func _on_MapOptionButton_item_selected(index):
	var map_name = %MapOptionButton.get_item_text(index)
	GameState.change_map(map_name)
	unpause.emit()

func _on_ToggleFullscreenButton_pressed():
	get_window().mode = Window.MODE_FULLSCREEN if (!((get_window().mode == Window.MODE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	Configuration.update_setting("graphics", "fullscreen", ((get_window().mode == Window.MODE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))

func _on_BackButton_pressed():
	back_button_pressed.emit()

func _on_ResetButton_pressed() -> void:
	$ConfirmationDialog.popup_centered()

func _on_ConfirmationDialog_confirmed() -> void:
	Configuration.reset_settings()
	refresh_values()

extends Camera3D

@export var generate : bool : get = get_generate, set = set_generate

@export var texture_resolution = Vector2i(1000, 1000) # Can't be higher than the computer resolution.
@export var save_to: String = "test.png"
	
func set_generate(value: bool) -> void:
	current = value

func get_generate() -> bool:
	return current

# This script saves the view of the camera to be used as minimap texture.
func _ready() -> void:
	if current:
		GameState.UserInterface.hide()
		get_window().mode = Window.MODE_WINDOWED
		DisplayServer.window_set_size(texture_resolution)
		await get_tree().create_timer(0.5).timeout

		var texture = get_viewport().get_texture().get_image()
		texture.save_png(save_to)
		print("minimap texture saved with resolution ", get_viewport().get_visible_rect().size, " at path ", save_to)
		get_tree().quit()

extends Camera3D

var texture_resolution = Vector2i(1000, 1000)
@export var save_to: String = "test.png"

func _ready() -> void:
  # This script is activated by setting this camera as the current one.
  if current:
    GameState.UserInterface.hide()
    get_window().mode = Window.MODE_WINDOWED
    DisplayServer.window_set_size(texture_resolution)
    await get_tree().create_timer(0.2).timeout

    var texture = get_viewport().get_texture().get_image()
    texture.save_png(save_to)
    print("minimap texture saved with resolution ", get_viewport().get_visible_rect().size, " at path ", save_to)
    get_tree().quit()

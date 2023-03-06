extends Camera3D

var texture_resolution = Vector2i(1000, 1000)

func _ready() -> void:
  if current:
    get_window().mode = Window.MODE_WINDOWED
    DisplayServer.window_set_size(texture_resolution)
    await get_tree().create_timer(0.2).timeout

    var texture = get_viewport().get_texture().get_image()
    texture.save_png("map_texture.png")
    print("minimap texture saved at resolution ", get_viewport().get_visible_rect().size)
    get_tree().quit()

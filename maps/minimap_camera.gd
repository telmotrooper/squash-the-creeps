extends Camera3D

func _ready() -> void:
  if current:
    $Timer.start()

func _on_timer_timeout() -> void:
  var texture = get_viewport().get_texture().get_image()
  texture.save_png("test.png")
  print("texture saved at resolution ", get_viewport().get_visible_rect().size)
  get_tree().quit()

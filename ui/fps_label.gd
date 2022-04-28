extends Label

func _process(_delta):
  text = "FPS: %s" % Engine.get_frames_per_second()

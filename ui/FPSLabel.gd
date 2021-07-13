extends Label

func _process(delta):
  text = "FPS: %s" % Engine.get_frames_per_second()

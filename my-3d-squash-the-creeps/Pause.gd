extends Control

func pause():
  get_tree().paused = not get_tree().paused
  visible = get_tree().paused
  if visible:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  else:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
  if event.is_action_pressed("pause"):
    pause()

func _on_ResumeButton_pressed():
  pause()

func _on_ExitButton_pressed():
  get_tree().quit()

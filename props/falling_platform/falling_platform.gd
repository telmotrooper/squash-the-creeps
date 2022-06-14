extends CSGBox

func _on_DetectArea_body_entered(_body):
  $Timer.start()

func _on_Timer_timeout():
#  $AnimationPlayer.play("fall")
  print("%s - fall" % get_path())

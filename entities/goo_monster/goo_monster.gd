extends KinematicBody

func squash():
  $AnimationPlayer.play("squash")

func kill(): # Triggered by animation "squash'.
  queue_free()

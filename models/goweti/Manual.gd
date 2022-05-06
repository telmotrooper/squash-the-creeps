extends Node

var move_forward := false

func _on_AnimationPlayer_animation_finished(anim_name: String):
  if anim_name == "move_platforms":
    $FloatingPlatformTimer.start()

func _on_FloatingPlatformTimer_timeout():
  if move_forward:
    $AnimationPlayer.play("move_platforms")
  else:
    $AnimationPlayer.play_backwards("move_platforms")
  move_forward = !move_forward

extends Node

# If re-importing from Blender, remember to "Clear inheritance" and make the
# floating platforms of type "KinematicBody". Also, adjust the "move_platforms"
# animation and make "RESET" go to meeting position.

enum { MOVING_CLOSER, MOVING_AWAY }

var direction := MOVING_AWAY

func move_platforms():
  _on_FloatingPlatformTimer_timeout()

func _on_AnimationPlayer_animation_finished(anim_name: String):
  if anim_name == "move_platforms":
    $FloatingPlatformTimer.start()

func _on_FloatingPlatformTimer_timeout():
  if direction == MOVING_CLOSER:
    $AnimationPlayer.play("move_platforms")
  else: # MOVING_AWAY
    $AnimationPlayer.play_backwards("move_platforms")
  direction = !direction

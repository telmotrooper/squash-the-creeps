extends Node

enum { MOVING_CLOSER, MOVING_AWAY }

var direction := MOVING_AWAY

func move_platforms() -> void:
	_on_FloatingPlatformTimer_timeout()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "move_platforms":
		$MovingPlatformTimer.start()

func _on_FloatingPlatformTimer_timeout() -> void:
	if direction == MOVING_AWAY:
		$AnimationPlayer.play("move_platforms")
		direction = MOVING_CLOSER
	else: # MOVING_CLOSER
		$AnimationPlayer.play_backwards("move_platforms")
		direction = MOVING_AWAY

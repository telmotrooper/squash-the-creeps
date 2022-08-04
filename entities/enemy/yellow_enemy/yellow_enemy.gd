extends BlueEnemy

func squash() -> void:
  $RespawnTimer.start()
  .squash()

func kill() -> void: # Do not kill, just hide.
  self.visible = false
  $CollisionShape.disabled = true
  $AnimationPlayer.play("RESET")

func _on_RespawnTimer_timeout() -> void:
  already_squashed = false
  self.visible = true
  $CollisionShape.disabled = false
  $AnimationPlayer.play("float")

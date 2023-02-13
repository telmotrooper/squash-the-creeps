extends BlueEnemy

func squash() -> void:
  $RespawnTimer.start()
  super.squash()

func kill() -> void: # Do not kill, just hide.
  self.visible = false
  $CollisionShape3D.disabled = true
  $AnimationPlayer.play("RESET")

func _on_RespawnTimer_timeout() -> void:
  already_squashed = false
  self.visible = true
  $CollisionShape3D.disabled = false
  $AnimationPlayer.play("float")

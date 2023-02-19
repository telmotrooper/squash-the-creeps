extends BlueEnemy

func squash() -> void:
  $RespawnTimer.start()
  super.squash()

func kill() -> void: # Do not kill, just hide.
  self.hide()
  $CollisionShape3D.disabled = true
  $AnimationPlayer.play("RESET")

func _on_RespawnTimer_timeout() -> void:
  already_squashed = false
  self.show()
  $CollisionShape3D.disabled = false
  $AnimationPlayer.play("float")

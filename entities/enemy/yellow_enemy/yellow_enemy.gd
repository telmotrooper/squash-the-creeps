extends BlueEnemy

func squash():
  $RespawnTimer.start()
  .squash()

func kill(): # Do not kill, just hide.
  self.visible = false
  $CollisionShape.disabled = true
  $AnimationPlayer.play("RESET")

func _on_RespawnTimer_timeout():
  already_squashed = false
  self.visible = true
  $CollisionShape.disabled = false
  $AnimationPlayer.play("float")

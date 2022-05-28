extends Spatial

func _on_GodotPowerUp_body_entered(_body):
  $AudioStreamPlayer.play()
  $CollisionShape.disabled = true
  self.visible = false

func _on_AudioStreamPlayer_finished():
  queue_free()

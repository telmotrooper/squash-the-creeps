extends Spatial

func _on_GodotPowerUp_body_entered(body):
  queue_free()

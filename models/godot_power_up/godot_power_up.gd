extends Spatial

func _on_GodotPowerUp_body_entered(_body):
  queue_free()

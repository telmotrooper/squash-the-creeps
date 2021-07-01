extends Spatial

func _ready():
  $AnimationPlayer.play("rotate")
  $AnimationPlayer.playback_speed = 0.5

func _on_GodotPowerUp_body_entered(body):
  queue_free()

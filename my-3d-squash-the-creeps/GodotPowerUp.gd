extends Spatial

func _ready():
  $AnimationPlayer.play("rotate")
  $AnimationPlayer.playback_speed = 0.5

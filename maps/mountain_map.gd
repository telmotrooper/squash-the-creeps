extends Spatial

export (AudioStream) var drain_water_sound

func _on_RedButton_pressed():
  $AnimationPlayer.play("drain_water")

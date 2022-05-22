extends Spatial

export (AudioStream) var drain_water_sound

func _ready():
  GameState.RetryCamera = $RetryCamera

func _on_RedButton_pressed():
  $AnimationPlayer.play("drain_water")

func _on_Player_hit():
  $UserInterface/Retry.show()
  GameState.RetryCamera.current = true

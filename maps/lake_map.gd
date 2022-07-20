extends Spatial

export (AudioStream) var map_music
export (AudioStream) var drain_water_sound

func _ready():
  GameState.play_music(map_music)
  GameState.RetryCamera = $RetryCamera

func _on_RedButton_pressed():
  $AnimationPlayer.play("drain_water")

func _on_Player_hit():
  GameState.UserInterface.retry()

func _on_Area_body_entered(body):
  get_node("%TunnelFloatingParticles").emitting = true
  print("Emitting particles.")

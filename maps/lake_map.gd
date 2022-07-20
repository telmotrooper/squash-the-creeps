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

func _on_AreaToStartParticles_body_entered(_body):
  get_node("%TunnelFloatingParticles").emitting = true
  print("Emitting particles.")

func _on_AreaToMakePlayerFloat_body_entered(_body):
  print("entered")
  if get_node("%TunnelFloatingParticles").emitting:
    GameState.Player.floating = true

func _on_AreaToMakePlayerFloat_body_exited(_body):
  print("exitted")
  get_node("%TunnelFloatingParticles").emitting = false
  GameState.Player.floating = false

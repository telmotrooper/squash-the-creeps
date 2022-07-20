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

func emit_particles(value: bool):
  get_node("%TunnelFloatingParticles").emitting = value
  get_node("%TunnelFloatingParticles").visible = value

func _on_AreaToStartParticles_body_entered(_body):
  emit_particles(true)

func _on_AreaToStopParticles_body_entered(player):
  if player.is_on_floor():
    emit_particles(false)

func _on_AreaToStopParticles_body_exited(player):
  if player.is_on_floor():
    emit_particles(false)

func _on_AreaToMakePlayerFloat_body_entered(_body):
  if get_node("%TunnelFloatingParticles").emitting:
    GameState.Player.floating = true

func _on_AreaToMakePlayerFloat_body_exited(_body):
  GameState.Player.floating = false

extends Spatial

export (AudioStream) var map_music
export (AudioStream) var drain_water_sound

func _ready() -> void:
  GameState.play_music(map_music)
  GameState.RetryCamera = $RetryCamera

func _on_RedButton_pressed() -> void:
  $AnimationPlayer.play("drain_water")

func _on_Player_hit() -> void:
  GameState.UserInterface.retry()

func emit_particles(value: bool) -> void:
  get_node("%TunnelFloatingParticles").emitting = value
  get_node("%TunnelFloatingParticles").visible = value

func _on_AreaToStartParticles_body_entered(_body: Node) -> void:
  emit_particles(true)

func _on_AreaToStopParticles_body_entered(player: Node) -> void:
  if player.is_on_floor():
    emit_particles(false)

func _on_AreaToStopParticles_body_exited(player: Node) -> void:
  if player.is_on_floor():
    emit_particles(false)

func _on_AreaToMakePlayerFloat_body_entered(_body: Node) -> void:
  if get_node("%TunnelFloatingParticles").emitting:
    GameState.Player.floating = true

func _on_AreaToMakePlayerFloat_body_exited(_body: Node) -> void:
  GameState.Player.floating = false

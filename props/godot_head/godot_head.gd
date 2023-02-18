extends Node3D

func _ready() -> void:
  GameState.register_godot_head(owner.name, name)
  
  # If already collected, remove_at node.
  if GameState.godot_heads_collected[owner.name][name]:
    queue_free()

func _on_GodotPowerUp_body_entered(_body: Node) -> void:
  GameState.collect_godot_head(owner.name, name)
  $AudioStreamPlayer.play()
  $CollisionShape3D.disabled = true
  self.visible = false

func _on_AudioStreamPlayer_finished() -> void:
  queue_free()

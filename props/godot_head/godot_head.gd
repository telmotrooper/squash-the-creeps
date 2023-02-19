extends Node3D

var collected := false

func _ready() -> void:
  GameState.register_godot_head(owner.name, name)
  
  # If already collected, remove_at node.
  if GameState.godot_heads_collected[owner.name][name]:
    queue_free()

func _on_GodotPowerUp_body_entered(_body: Node) -> void:
  if !collected:
    collected = true
    GameState.collect_godot_head(owner.name, name)
    $AudioStreamPlayer.play()
    self.hide()
    await $AudioStreamPlayer.finished
    queue_free()

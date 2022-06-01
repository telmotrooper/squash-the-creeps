extends Spatial

func _ready():
  GameState.register_godot_head(owner.name, name)
  
  # If already collected, remove node.
  if GameState.godot_heads_collected[owner.name][name]:
    queue_free()

func _on_GodotPowerUp_body_entered(_body):
  GameState.collect_godot_head(owner.name, name)
  $AudioStreamPlayer.play()
  $CollisionShape.disabled = true
  self.visible = false

func _on_AudioStreamPlayer_finished():
  queue_free()

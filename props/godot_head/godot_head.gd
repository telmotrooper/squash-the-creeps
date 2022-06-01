extends Spatial

onready var id = "%s_%s" % [owner.name, name]

func _ready():
  GameState.register_godot_head(id)
  
  # If already collected, remove node.
  if GameState.godot_heads_collected[id]:
    queue_free()

func _on_GodotPowerUp_body_entered(_body):
  GameState.collect_godot_head(id)
  $AudioStreamPlayer.play()
  $CollisionShape.disabled = true
  self.visible = false

func _on_AudioStreamPlayer_finished():
  queue_free()

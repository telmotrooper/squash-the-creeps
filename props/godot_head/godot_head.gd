extends Spatial

onready var id = "%s_%s" % [owner.name, name]

func _ready():
  if not id in GameState.godot_heads_collected:
    print("Registering '%s' in GameState" % id)
    GameState.godot_heads_collected[id] = false

func _on_GodotPowerUp_body_entered(_body):
  GameState.godot_heads_collected[id] = true
  print(GameState.godot_heads_collected)
  $AudioStreamPlayer.play()
  $CollisionShape.disabled = true
  self.visible = false

func _on_AudioStreamPlayer_finished():
  queue_free()

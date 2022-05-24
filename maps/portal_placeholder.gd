extends CSGCylinder

export var map_name: String

func _on_Portal_entered(_body):
  GameState.Player.get_node("EffectsAnimationPlayer").play("shrink")
  GameState.change_map(map_name)

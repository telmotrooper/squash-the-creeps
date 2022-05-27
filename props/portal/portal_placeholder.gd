extends CSGCylinder

export var map_name: String

func _ready():
  $Label3D.text = map_name

func _on_Portal_entered(_body):
  $AnimationPlayer.play("shrink")
  #$AudioStreamPlayer.play()
  GameState.Player.get_node("EffectsAnimationPlayer").play("shrink")
  GameState.change_map(map_name)

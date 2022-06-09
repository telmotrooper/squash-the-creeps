extends CSGCylinder

export var label: String
export var map_name: String
export var godot_heads_required: int

func _ready():
  $Label3D.text = label if label else map_name
  
  if godot_heads_required >= 1:
    $RequirementLabel.text = "Godot Heads x %d" % godot_heads_required
  else:
    $RequirementLabel.text = ""

func _on_Portal_entered(_body):
  if GameState.global_progress.collected >= godot_heads_required:
    $LabelAnimationPlayer.play("shrink")
    $RequirementLabel.visible = false
    #$AudioStreamPlayer.play()
    GameState.Player.get_node("EffectsAnimationPlayer").play("shrink")
    GameState.change_map(map_name)
  else:
    GameState.UserInterface.show_hud()

func _on_DetectArea_body_entered(_body):
  if GameState.global_progress.collected >= godot_heads_required:
    $RequirementAnimationPlayer.play("fade_out")

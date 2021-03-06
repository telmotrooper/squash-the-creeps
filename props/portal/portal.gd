extends CSGCylinder

export var label: String
export var map_name: String
export var godot_heads_required: int

func _ready():
  $Label3D.text = label if label else map_name
  
  if godot_heads_required >= 1 and portal_locked():
    $RequirementLabel.text = "Godot Heads x %d" % godot_heads_required
  else:
    $RequirementLabel.text = ""
  
  if godot_heads_required > 0 and requirement_met() and portal_locked():
    var child_camera = get_node_or_null("Camera")
  
    if is_instance_valid(child_camera): # Cutscene
      child_camera.make_current()
      var timer = get_tree().create_timer(1, false)
      yield(timer, "timeout")
      $RequirementAnimationPlayer.play("fade_out")
      timer = get_tree().create_timer(2, false)
      yield(timer, "timeout")
      GameState.Player.get_node("%ClippedCamera").make_current()
      GameState.portal_unlocked[get_path()] = true

func _on_Portal_entered(_body):
  GameState.hub_1_at_night = false
  if requirement_met():
    $LabelAnimationPlayer.play("shrink")
    $RequirementLabel.visible = false
    #$AudioStreamPlayer.play()
    GameState.Player.get_node("EffectsAnimationPlayer").play("shrink")
    GameState.change_map(map_name)
  else:
    GameState.UserInterface.show_hud()

func _on_DetectArea_body_entered(_body):
  if requirement_met() and portal_locked():
    $RequirementAnimationPlayer.play("fade_out")

func requirement_met():
  return GameState.global_progress.collected >= godot_heads_required

func portal_locked():
  return not GameState.portal_unlocked.has(get_path())

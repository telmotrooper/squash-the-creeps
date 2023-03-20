extends CSGCylinder3D

@export var label: String
@export var map_name: String
@export var godot_heads_required: int
@export var skip_cutscene: SkipCutscene

func _ready() -> void:
  $Label3D.text = label if label else map_name
  
  if skip_cutscene:
    skip_cutscene.connect("skip", finish_cutscene)
  
  if godot_heads_required >= 1 and portal_locked():
    $RequirementLabel.text = "Godot Heads x %d" % godot_heads_required
  else:
    $RequirementLabel.text = ""
  
  if godot_heads_required > 0 and requirement_met() and portal_locked():
    var child_camera = get_node_or_null("Camera3D")
  
    if is_instance_valid(child_camera): # Cutscene
      child_camera.make_current()
      skip_cutscene.set_mode(SkipCutscene.Mode.SIGNAL)
      skip_cutscene.enable()
      await get_tree().create_timer(1, false).timeout
      $RequirementAnimationPlayer.play("fade_out")
      await get_tree().create_timer(2, false).timeout
      finish_cutscene()
      skip_cutscene.disable()
      skip_cutscene.set_mode(SkipCutscene.Mode.ANIMATION_PLAYER)

func _on_Portal_entered(_body: Node) -> void:
  GameState.hub_1_at_night = false
  if requirement_met():
    $LabelAnimationPlayer.play("shrink")
    $RequirementLabel.hide()
    #$AudioStreamPlayer.play()
    GameState.Player.get_node("EffectsAnimationPlayer").play("shrink")
    GameState.change_map(map_name)
  else:
    GameState.UserInterface.show_hud()

func _on_DetectArea_body_entered(_body: Node) -> void:
  if requirement_met() and portal_locked():
    $RequirementAnimationPlayer.play("fade_out")

func requirement_met() -> bool:
  return GameState.global_progress.collected >= godot_heads_required

func portal_locked() -> bool:
  return not GameState.portal_unlocked.has(get_path())

func finish_cutscene() -> void:
  GameState.portal_unlocked[get_path()] = true
  GameState.Player.get_node("%Camera3D").make_current()

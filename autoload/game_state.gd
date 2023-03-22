extends Node

var Player: CharacterBody3D
var Grass: MultiMeshInstance3D
var MapName: String
var UserInterface: Control
var dialog: Dialog
var minimap: Control

var hub_1_at_night := true
var camera_distance := 10

var upgrades = {
  "body_slam": false,
  "double_jump": false,
  "mid_air_dash": false
}

var portal_unlocked = {}

var godot_heads_counter := 0
var total_godot_heads_in_map := 0

var godot_heads_collected = {
  "AvocadoBeach": {
    "FloatingGodotHead": false,
    "GrassGodotHead": false,
    "BeachGodotHead": false,
    "BridgeGodotHead": false,
    "PalmTreeGodotHead": false,
    "SandRampGodotHead": false
   },
  "LakeMap": {
    "GodotHead": false,
    "GodotHead2": false,
    "TunnelGodotHead": false
   }
}

var global_progress = { "collected": 0, "total": 0, "percentage": 0.0 }
var progress = {}

var amount_of_gems := 0
var gems_collected = {}

var global_gem_progress = { "collected": 0, "total": 102+52, "percentage": 0.0 }
var gem_progress = {
  "AvocadoBeach": { "collected": 0, "total": 102, "percentage": 0.0 },
  "LakeMap": { "collected": 0, "total": 52, "percentage": 0.0 }
}

# Backup this value so it can be used to start a new game.
var initial_godot_heads_collected = var_to_bytes(godot_heads_collected)
var initial_gem_progress = var_to_bytes(gem_progress)
var initial_global_gem_progress = var_to_bytes(global_gem_progress)

var cutscenes_played = {
  "intro": false,
  "avocado_beach_preview": false
}

var collision_layers = {}

const initial_grass = 3000

func _ready() -> void:
  var fallback_scene = "res://maps/avocado_beach.tscn"
  var current_scene = get_tree().get_current_scene().get_name()
  
  # List named collision layers for easy access.
  for i in range(1, 33):
    var property_path = "layer_names/3d_physics/layer_%d" % i
    var layer_name = ProjectSettings.get_setting(property_path)
    if layer_name != "":
      collision_layers[layer_name] = i - 1

  # If scene with no camera loaded, load fallback scene.
  if current_scene == "Player" or (current_scene != "Main" and current_scene != "TestTimelineScene" and not is_instance_valid(get_viewport().get_camera_3d())):
    print("Scene \"%s\" has no default camera, loading fallback scene at \"%s\"." % [current_scene, fallback_scene])
    var _error = get_tree().change_scene_to_file(fallback_scene)

func collect_gem(map_name: String, path: NodePath) -> void:
  gems_collected[map_name][path].collected = true
  
  gem_progress[map_name].collected += gems_collected[map_name][path].value
  global_gem_progress.collected += gems_collected[map_name][path].value
  
  gem_progress[map_name].percentage = float(gem_progress[map_name].collected) / gem_progress[map_name].total
  global_gem_progress.percentage = float(global_gem_progress.collected) / global_gem_progress.total
  
  if gem_progress[map_name].percentage == 1.0:
    UserInterface.show_all_gems_collected()
  
  if gem_progress[map_name].percentage > 1.0:
    print("Player has more gems than expected for this map.")
  
  UserInterface.show_hud()
  amount_of_gems += gems_collected[map_name][path].value
  UserInterface.get_node("%GemLabel").text = "%d" % amount_of_gems
  generate_progress_report(map_name)

func initialize() -> void: # Used in "New Game".
  for property in cutscenes_played:
    cutscenes_played[property] = false
  
  hub_1_at_night = true
  gems_collected = {}
  godot_heads_collected = bytes_to_var(initial_godot_heads_collected)
  gem_progress = bytes_to_var(initial_gem_progress)
  global_gem_progress = bytes_to_var(initial_global_gem_progress)
  initialize_progress()
  amount_of_gems = 0
  camera_distance = 10

func initialize_progress() -> void:
  global_progress = { "collected": 0, "total": 0, "percentage": 0.0 }
  progress = {}
  
  for map_name in godot_heads_collected:
    progress[map_name] = { "collected": 0, "total": 0 }
    for entry in godot_heads_collected[map_name]:
      if godot_heads_collected[map_name][entry]:
        progress[map_name].collected += 1
        global_progress.collected += 1
      progress[map_name].total += 1
      global_progress.total += 1
    progress[map_name].percentage = float(progress[map_name].collected) / progress[map_name].total
  
  global_progress.percentage = float(global_progress.collected) / global_progress.total

func generate_progress_report(current_map: String) -> void:
  if progress.is_empty(): # Useful when starting map from editor.
    initialize_progress()
  
  # This function reads the "progress" dictionary and updates the "Progress" menu accordingly.
  # If current map is provided, we also update the HUD with map-specific progress.
  
  assert(is_instance_valid(UserInterface))

  var text := ""
  
  for map_name in godot_heads_collected:
    var map_progress = progress[map_name].percentage * 0.5 + gem_progress[map_name].percentage * 0.5
    text += map_name + " (%.f%%)\n" % [map_progress * 100]
    text += "• Godot Heads: %d/%d\n" % [progress[map_name].collected, progress[map_name].total]
    
    text += "• Gems: %d/%d\n\n" % [gem_progress[map_name].collected, gem_progress[map_name].total]
  
  # Remove last two new lines.
  text = text.substr(0, text.length() - 2)
  
  var overall_progress = global_progress.percentage * 0.5 + global_gem_progress.percentage * 0.5
  
  if overall_progress == 1:
    GameState.UserInterface.show_congratulations()
  
  UserInterface.get_node("%ProgressButton").text = "Progress: %.f%%" % [overall_progress * 100]
  UserInterface.get_node("%World1Progress").text = text
  
  if progress.has(current_map):
    UserInterface.get_node("%ScoreLabel").text = "%s / %s" % [progress[current_map].collected, progress[current_map].total]
  else:
    UserInterface.get_node("%ScoreLabel").text = "%s" % global_progress.collected

func collect_godot_head(map_name: String, id: String) -> void:
  UserInterface.show_hud()
  GameState.godot_heads_collected[map_name][id] = true
  
  # Update progress.
  progress[map_name].collected += 1
  global_progress.collected += 1
  
  progress[map_name].percentage = float(progress[map_name].collected) / progress[map_name].total
  global_progress.percentage = float(global_progress.collected) / global_progress.total
  
  if progress[map_name].percentage == 1.0:
    UserInterface.show_all_godot_heads_collected()
  
  generate_progress_report(map_name)

func register_godot_head(map_name: String, id: String) -> void:
  if not map_name in godot_heads_collected:
    print("Warning: Update GameState to include '%s'." % map_name)
    godot_heads_collected[map_name] = {}
  
  if not id in godot_heads_collected[map_name]:
    print("Warning: Update GameState to include '%s'." % id)
    GameState.godot_heads_collected[map_name][id] = false

func register_gem(map_name: String, path: NodePath, gem_value: int) -> void:
  if not map_name in gems_collected:
    gems_collected[map_name] = {}
  
  if not path in gems_collected[map_name]:
    gems_collected[map_name][path] = { "collected": false, "value": gem_value }

func update_grass(index: int = -1) -> void:
  if index == -1: # If called with no index, set the one from the configuration file.
    index = Configuration.get_value("graphics", "grass_amount")
  
  if is_instance_valid(GameState.Grass):
    if index == 0: # Enabled
      GameState.Grass.show()
    else: # Disabled
      GameState.Grass.hide()

  Configuration.update_setting("graphics", "grass_amount", index)

func change_map(map_name: String) -> void:
  GameState.MapName = map_name
  var map_file = "res://maps/%s.tscn" % map_name
  #Utils.exists(map_file) 
  if is_instance_valid($"/root/Main"): # Game started normally, use background loading.
    $"/root/Main".load_scene(map_file)
  else: # Game started through "Play Scene" in editor.
    var _error = get_tree().change_scene_to_file(map_file)

func play_audio(stream: AudioStream) -> void:
  if !$Audio/AudioStreamPlayer1.playing:
    $Audio/AudioStreamPlayer1.stream = stream
    $Audio/AudioStreamPlayer1.play()
  elif !$Audio/AudioStreamPlayer2.playing:
    $Audio/AudioStreamPlayer2.stream = stream
    $Audio/AudioStreamPlayer2.play()
  elif !$Audio/AudioStreamPlayer3.playing:
    $Audio/AudioStreamPlayer3.stream = stream
    $Audio/AudioStreamPlayer3.play()
  elif !$Audio/AudioStreamPlayer4.playing:
    $Audio/AudioStreamPlayer4.stream = stream
    $Audio/AudioStreamPlayer4.play()
  elif !$Audio/AudioStreamPlayer5.playing:
    $Audio/AudioStreamPlayer5.stream = stream
    $Audio/AudioStreamPlayer5.play()
  else:
    print("Error: No AudioStreamPlayer was available to play sound.")

func play_music(stream: AudioStream) -> void:
  if $BGM.stream != stream:
    $BGM.stream = stream
    $BGM.play()
  elif not $BGM.playing:
    $BGM.play()

func stop_music() -> void:
  $BGM.stop()

func reload_current_scene() -> void:
  var Main = get_node_or_null("/root/Main")
  if is_instance_valid(Main): # Game started normally, use background loading.
    var WorldScene = $"/root/Main/WorldScene"
    Main.load_scene(WorldScene.get_child(0).scene_file_path)
  else: # Game started through "Play Scene" in editor.
    var _error = get_tree().reload_current_scene()

func change_bgm_volume(amount: float) -> void:
  $BGM.volume_db += amount

extends Node

var Player: KinematicBody
var Grass: Node
var MapName: String
var UserInterface: Control

const initial_grass = 3000

func update_grass(index: int = -1):
  if index == -1: # If called with no index, set the one from the configuration file.
    index = Configuration.get_value("graphics", "grass_amount")
    
  var multiplier = grass_index_to_multiplier(index)
  
  if is_instance_valid(GameState.Grass):
    if not GameState.Grass.modifier_stack.stack.empty():
      GameState.Grass.modifier_stack.stack[0].instance_count = GameState.initial_grass * multiplier
      GameState.Grass._do_update()
  
  Configuration.update_setting("graphics", "grass_amount", index)

func grass_index_to_multiplier(index: int):
  var multiplier = 1
  match index:
    0: # Maximum
      multiplier = 1
    1: # High
      multiplier = 0.75
    2: # Medium
      multiplier = 0.5
    3: # Low
      multiplier = 0.25
    4: # None
      multiplier = 0
  return multiplier

func change_map(map_name: String):
  #print("[DEPRECATED] Changing to map %s" % map_name)
  GameState.MapName = map_name
  var map_file = "res://maps/%s.tscn" % map_name
  #Utils.exists(map_file)
  
  $"/root/Main".load_world(map_file)
  
  #var error = get_tree().change_scene(map_file)
  #if error:
  #  print("Error: Unable to load map '%s'." % map_file)

func play_audio(stream):
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

func reload_current_scene():
  var world_scene = $"/root/Main/WorldScene"
  var my_current_scene = world_scene.get_child(0)
  var file_path = my_current_scene.filename
  world_scene.remove_child(my_current_scene)
  my_current_scene.queue_free()
  
  var new_scene = load(file_path)
  world_scene.add_child(new_scene.instance())

extends Node3D

@export var initial_scene: PackedScene

var current_scene = null
var loading_scene = null

func _ready() -> void:
  set_process(false)
  load_scene(initial_scene.get_path())

func load_scene(scene_to_load: NodePath) -> void:
  loading_scene = scene_to_load
  
  if not ResourceLoader.has_cached(loading_scene):
    $ProgressBar.value = 0
    $ProgressBar.show()
  
  ResourceLoader.load_threaded_request(loading_scene)
  
  $FadeTransition.fade_out()
  await $FadeTransition.faded_out
  
  if current_scene:
    $WorldScene.remove_child(current_scene)
    if is_instance_valid(current_scene):
      current_scene.queue_free()
    current_scene = null
  set_process(true)

func _process(_delta: float) -> void:
  # Waiting until loading is done.

  if ResourceLoader.load_threaded_get_status(loading_scene) == 3: # If resource is available.
    var new_scene = ResourceLoader.load_threaded_get(loading_scene)
    $ProgressBar.value = 100
    
    current_scene = new_scene.instantiate()
    $WorldScene.add_child(current_scene)
    $ProgressBar.hide()
    
    $FadeTransition.fade_in()
    set_process(false)

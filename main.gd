extends Node3D

@export var initial_scene: PackedScene

enum { LOADING, LOADED, PLAYING }

var state := PLAYING
var current_scene = null
var loading_scene = null

func _ready() -> void:
  set_process(false)
  ResourceQueue.start()
  load_scene(initial_scene.get_path())

func load_scene(scene_to_load: NodePath) -> void:
  loading_scene = scene_to_load
  ResourceQueue.queue_resource(loading_scene)
  
  state = LOADING
  $FadeTransition.fade_out()
  
  if not ResourceLoader.has_cached(loading_scene):
    $ProgressBar.value = 0
    $ProgressBar.show()
#    while not ResourceQueue.is_ready(loading_scene):
#      $ProgressBar.value = ResourceQueue.get_progress(loading_scene) * 100

func _on_fade_transition_faded_out() -> void:
  if state == LOADING:
    $WorldScene.hide()
    
    if current_scene:
      $WorldScene.remove_child(current_scene)
      if is_instance_valid(current_scene):
        current_scene.queue_free()
      current_scene = null
    set_process(true)

func _on_fade_transition_faded_in() -> void:
  state = PLAYING

func _process(_delta: float) -> void:
  # Waiting until loading is done.
  var new_world = ResourceQueue.get_resource(loading_scene)
  
  if new_world: # If resource is available.
    $ProgressBar.value = 100
    current_scene = new_world.instantiate()
    
    $WorldScene.add_child(current_scene)
    $WorldScene.show()
    
    $ProgressBar.value = 100
    $ProgressBar.hide()
    
    state = LOADED
    $FadeTransition.fade_in()
    
    set_process(false)

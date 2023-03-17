extends Node3D

@export var initial_scene: PackedScene

enum LoadingStates {
  FADE_TO_BLACK_1,
  LOADING,
  FADE_TO_BLACK_2,
  FADE_TO_WORLD,
  PLAYING
}

var loading_state := LoadingStates.PLAYING
var current_world = null
var loading_world = null

func _ready() -> void:
  ResourceQueue.start()
  load_world(initial_scene.get_path())

func load_world(scene_to_load: NodePath) -> void:
  loading_world = scene_to_load
  ResourceQueue.queue_resource(loading_world)
  
  loading_state = LoadingStates.FADE_TO_BLACK_1
  $FadeTransition.fade_out()
  
  if not ResourceLoader.has_cached(loading_world):
    $ProgressBar.value = 0
    $ProgressBar.show()
    
    while not ResourceQueue.is_ready(loading_world):
      $ProgressBar.value = ResourceQueue.get_progress(loading_world) * 100

func _on_FadeToBlack_finished_fading() -> void:
  match loading_state:
    LoadingStates.FADE_TO_BLACK_1:
      $WorldScene.hide()
      
      if current_world:
        $WorldScene.remove_child(current_world)
        if is_instance_valid(current_world):
          current_world.queue_free()
        current_world = null
      
      loading_state = LoadingStates.LOADING
      set_process(true)
    LoadingStates.FADE_TO_BLACK_2:
      $WorldScene.add_child(current_world)
      $WorldScene.show()
      
      $ProgressBar.value = 100
      $ProgressBar.hide()
      
      loading_state = LoadingStates.FADE_TO_WORLD
      $FadeTransition.fade_in()
    LoadingStates.FADE_TO_WORLD:
      loading_state = LoadingStates.PLAYING

func _process(_delta: float) -> void:
  if loading_state == LoadingStates.LOADING:
    # We could do something with a progress bar here.
    
    # Check if our resource is available.
    var new_world = ResourceQueue.get_resource(loading_world)
    if new_world:
      # If we're finished, create a new instance.
      current_world = new_world.instantiate()
      
      # Fade to black.
      loading_state = LoadingStates.FADE_TO_BLACK_2
      _on_FadeToBlack_finished_fading()
      set_process(false)

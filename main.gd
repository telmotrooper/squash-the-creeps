extends Node3D

@export var initial_scene: PackedScene

enum LoadingStates {
  FADE_TO_BLACK_1,
  FADE_TO_LOADING,
  LOADING,
  FADE_TO_BLACK_2,
  FADE_TO_WORLD,
  PLAYING
}

var loading_state = LoadingStates.PLAYING
var current_world = null
var loading_world = null

func _ready() -> void:
  ResourceQueue.start()
  
  # Load our first scene.
  load_world(initial_scene.get_path())


func load_world(scene_to_load: NodePath) -> void:
  # Remember which scene we're loading.
  loading_world = scene_to_load
  
  # Start loading.
  ResourceQueue.queue_resource(loading_world)
  
  # Fade to black, if we've already faded to black (startup) we get our signal immediately.
  loading_state = LoadingStates.FADE_TO_BLACK_1
  $FadeToBlack.is_faded = true
  
  if not ResourceLoader.has_cached(loading_world):
    $ProgressBar.value = 0
    $ProgressBar.visible = true
    
    while not ResourceQueue.is_ready(loading_world):
      $ProgressBar.value = ResourceQueue.get_progress(loading_world) * 100

func _on_FadeToBlack_finished_fading() -> void:
  match loading_state:
    LoadingStates.FADE_TO_BLACK_1:
      # Hide our world scene.
      $WorldScene.visible = false
      
      # Remove our current world.
      if current_world:
        $WorldScene.remove_child(current_world)
        if is_instance_valid(current_world):
          current_world.queue_free()
        current_world = null
      
      # Fade to transparent.
      loading_state = LoadingStates.FADE_TO_LOADING
      # This is where it goes to gray if we set "is_faded" to "false".
      # Setting this variable starts processing in node FadeToBlack.
      $FadeToBlack.is_faded = true
      #$FadeToBlack.is_faded = false
    LoadingStates.FADE_TO_LOADING:
      # Simply change the state to loading.
      loading_state = LoadingStates.LOADING
      set_process(true)
    LoadingStates.FADE_TO_BLACK_2:
      
      # Add our new scene.
      $WorldScene.add_child(current_world)
      $WorldScene.visible = true
      
      $ProgressBar.value = 100
      $ProgressBar.visible = false
      
      # Fade to transparent.
      loading_state = LoadingStates.FADE_TO_WORLD
      $FadeToBlack.is_faded = false
    LoadingStates.FADE_TO_WORLD:
      # Simply set the state to playing.
      loading_state = LoadingStates.PLAYING
    _:
      # Nothing to do in all other states.
      pass

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
      $FadeToBlack.is_faded = true
      set_process(false)

extends Control

func _ready():
  # If every map is gonna have its own UserInterface instance,
  # we'll need a reference to the current one.
  GameState.UserInterface = self
  
  get_tree().paused = false
  $Pause.visible = false
  $Pause/MainPause.visible = true
  $Pause/PauseControls.visible = false
  
  # Update Godot Heads counter
  $ScoreLabel.text = "x %s" % GameState.godot_heads_counter

func _process(_delta):
  $FPSLabel.text = "FPS: %s" % Engine.get_frames_per_second()

func increase_counter():
  GameState.godot_heads_counter +=1
  $ScoreLabel.text = "x %s" % GameState.godot_heads_counter

func _on_Enemy_squashed():
  pass

func _unhandled_input(event):
  if $Retry.visible and event.is_action_pressed("ui_accept"):
    GameState.reload_current_scene()

func retry():
  $Retry.show()
  GameState.RetryCamera.current = true

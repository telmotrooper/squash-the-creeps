extends Control

var score = 0

func _ready():
  # If every map is gonna have its own UserInterface instance,
  # we'll need a reference to the current one.
  GameState.UserInterface = self
  
  get_tree().paused = false
  $Pause.visible = false
  $Pause/MainPause.visible = true
  $Pause/PauseControls.visible = false

func _process(_delta):
  $FPSLabel.text = "FPS: %s" % Engine.get_frames_per_second()

func _on_Enemy_squashed():
  score += 1
  $ScoreLabel.text = "Score: %s" % score

func _unhandled_input(event):
  if $Retry.visible and event.is_action_pressed("ui_accept"):
    GameState.reload_current_scene()

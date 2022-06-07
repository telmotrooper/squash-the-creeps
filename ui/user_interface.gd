extends Control

var hud_visible := false

func _ready():
  # If every map is gonna have its own UserInterface instance,
  # we'll need a reference to the current one.
  GameState.UserInterface = self
  
  get_tree().paused = false
  $Pause.visible = false
  
  $Pause/PauseMenu.visible = true

  # Guarantee all submenus are initially closed.  
  for submenu in $Pause/Submenus.get_children():
    submenu.visible = false
  
  GameState.generate_progress_report(owner.name)
  get_node("%GemLabel").text = "%d" % GameState.amount_of_gems

func _process(_delta):
  $FPSLabel.text = "FPS: %s" % Engine.get_frames_per_second()

func _unhandled_input(event):
  if $Retry.visible and event.is_action_pressed("ui_accept"):
    GameState.reload_current_scene()

func retry():
  $Retry.show()
  GameState.RetryCamera.current = true

func show_hud():
  $Timer.start()
  if not hud_visible:
    $AnimationPlayer.play_backwards("hide_hud")
    hud_visible = true

func _on_Timer_timeout():
  if hud_visible:
    $AnimationPlayer.play("hide_hud")
    hud_visible = false

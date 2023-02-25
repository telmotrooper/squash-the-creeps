extends Control

var hud_visible := false

func _ready() -> void:
  # If every map is gonna have its own UserInterface instance,
  # we'll need a reference to the current one.
  GameState.UserInterface = self
  
  get_tree().paused = false
  $Pause.hide()
  
  $Pause/PauseMenu.show()

  # Guarantee all submenus are initially closed.  
  for submenu in $Pause/Submenus.get_children():
    submenu.hide()

  $CongratulationsDialog.hide()
  
  if is_instance_valid(owner):
    GameState.generate_progress_report(owner.name)
  %GemLabel.text = "%d" % GameState.amount_of_gems

func _process(_delta: float) -> void:
  $FPSLabel.text = "FPS: %s" % Engine.get_frames_per_second()

func _unhandled_input(event):
  if $Retry.visible and event.is_action_pressed("ui_accept"):
    GameState.reload_current_scene()

func retry() -> void:
  $Retry.show()
  GameState.RetryCamera.current = true

func show_hud() -> void:
  $HUDTimer.start()
  if not hud_visible:
    $HUDAnimationPlayer.play_backwards("hide_hud")
    hud_visible = true

func hide_hud() -> void: # Triggered by HUDTimer.
  if hud_visible:
    $HUDAnimationPlayer.play("hide_hud")
    hud_visible = false

func show_all_godot_heads_collected() -> void:
  show_announcement("100% Godot Heads collected")

func show_all_gems_collected() -> void:
  show_announcement("100% gems collected")

func show_announcement(text: String) -> void:
  if $AnnouncementAnimationPlayer.is_playing():
    # If another announcement is underway, wait 5 seconds and try again.
    var timer = get_tree().create_timer(5, false)
    await timer.timeout
  
  $Announcement.text = text
  $AnnouncementAnimationPlayer.play("show_all_godot_heads_collected")

func show_congratulations() -> void:
  $CongratulationsDialog.popup_centered()
  GameState.change_bgm_volume(-10)
  $CongratulationsDialog/AnimationPlayer.play("congratulations")
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  get_tree().paused = true

func _on_congratulations_dialog_confirmed() -> void:
  GameState.change_bgm_volume(+10)
  $CongratulationsDialog/AnimationPlayer.stop()
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  get_tree().paused = false

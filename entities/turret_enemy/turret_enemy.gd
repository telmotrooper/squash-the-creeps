extends Node3D

enum { IDLE, ALERT, ATTACKING }

var state = IDLE

func _physics_process(_delta: float) -> void:
  match state:
    IDLE:
      pass
    ALERT:
      $ExclamationMark.visible = true
      $AlertTimer.start()
      set_physics_process(false)
    ATTACKING:
      if is_instance_valid(GameState.Player):
        aim_at_player(GameState.Player.transform.origin)

func _on_area_3d_body_entered(body: Node3D) -> void:
  state = ALERT

func aim_at_player(player_position) -> void:
  look_at(player_position, Vector3.UP)

func _on_alert_timer_timeout() -> void:
  $ExclamationMark.visible = false
  state = ATTACKING
  set_physics_process(true)

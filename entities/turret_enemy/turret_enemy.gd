extends Node3D
class_name TurretEnemy

@export var bullet_scene: PackedScene

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
        
        if $GunTimer.is_stopped():
          _on_gun_timer_timeout() # Trigger first shot immediately.
          $GunTimer.start()      

func _on_area_3d_body_entered(_body: Node3D) -> void:
  if state == IDLE:
    state = ALERT

func aim_at_player(player_position) -> void:
  look_at(player_position, Vector3.UP)

func _on_alert_timer_timeout() -> void:
  $ExclamationMark.visible = false
  state = ATTACKING
  set_physics_process(true)

func _on_gun_timer_timeout() -> void:
  if is_instance_valid(GameState.Player):
    var bullet = bullet_scene.instantiate().setup(GameState.Player.transform.origin)
    add_child(bullet)
    bullet.shoot()

extends StaticBody3D

var shaking := false
var initial_rotation: Vector3

func _ready() -> void:
  set_process(false)
  initial_rotation = self.rotation_degrees

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("interact") and not GameState.Player.paused:
    GameState.dialog.set_text("It isn't going anywhere soon...")
    GameState.dialog.open_dialog()

func _on_SpaceshipArea_body_entered(_player: Node) -> void:
  %SpaceshipLabel3D.show()
  set_process(true)

func _on_SpaceshipArea_body_exited(_player: Node) -> void:
  %SpaceshipLabel3D.hide()
  set_process(false)

func interact_on_spin() -> void:
  if not shaking:
    shaking = true
    var tween = create_tween().set_loops(2)
    tween.tween_property(self, "rotation_degrees:z", initial_rotation.z + 2.5, 0.2)
    tween.tween_property(self, "rotation_degrees:z", initial_rotation.z, 0.2)
    tween.tween_callback(done_shaking)

func done_shaking() -> void:
  shaking = false

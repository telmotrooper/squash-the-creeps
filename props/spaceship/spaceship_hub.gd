extends StaticBody3D

func _ready() -> void:
  set_process(false)

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

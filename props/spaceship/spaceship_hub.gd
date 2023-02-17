extends StaticBody3D

func _ready() -> void:
  set_process(false)

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("interact"):
    print("interact")
#    GameState.Player.paused = true
#    var new_dialog = Dialogic.start("BrokenSpaceship")
#    add_child(new_dialog)
#    await new_dialog.dialogic_signal
#    GameState.Player.paused = false

func _on_SpaceshipArea_body_entered(_player: Node) -> void:
  get_node("%SpaceshipLabel3D").visible = true
  set_process(true)

func _on_SpaceshipArea_body_exited(_player: Node) -> void:
  get_node("%SpaceshipLabel3D").visible = false
  set_process(false)

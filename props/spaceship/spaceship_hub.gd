extends StaticBody3D

func _ready() -> void:
  set_process(false)

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("interact") and not GameState.Player.paused:
    if GameState.UserInterface.get_node("Dialog").visible:
      print("switch_from_dialog")
      GameState.UserInterface.switch_from_dialog()
    else:
      print("switch_to_dialog")
      GameState.UserInterface.switch_to_dialog()
#    GameState.Player.paused = true
#    Dialogic.start("res://dialogic/timelines/broken_spaceship.dtl")
#    await Dialogic.signal_event
#    GameState.Player.paused = false

func _on_SpaceshipArea_body_entered(_player: Node) -> void:
  %SpaceshipLabel3D.show()
  set_process(true)

func _on_SpaceshipArea_body_exited(_player: Node) -> void:
  %SpaceshipLabel3D.hide()
  set_process(false)

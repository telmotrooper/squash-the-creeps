extends Control

@export var animation_player: AnimationPlayer

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("attack"):
    animation_player.play("RESET")
    set_process(false)

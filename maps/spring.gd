extends CSGBox3D

@export var speed := 35
var running := false
var listening := true
var player_parent: Node
var player: Node3D
var fall_acceleration: float


func _ready() -> void:
  set_physics_process(false)

func _physics_process(delta: float) -> void:
  $SpringPath/PathFollow3D.progress += speed * delta
  if $SpringPath/PathFollow3D.progress_ratio >= 1:
    reset()

func _on_area_3d_body_entered(body: Node3D) -> void:
  if listening:
    listening = false
    player = body
    # Backup player parent and fall acceleration.
    player_parent = player.get_parent()
    fall_acceleration = player.fall_acceleration
    player.fall_acceleration = 0
    player.reparent($SpringPath/PathFollow3D)
    set_physics_process(true)

func reset() -> void:
  player.fall_acceleration = fall_acceleration
  player.reparent(player_parent)
  $SpringPath/PathFollow3D.progress_ratio = 0
  listening = true
  set_physics_process(false)

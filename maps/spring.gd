extends CSGBox3D

@export var speed := 30
var running := false
var player: Node3D

func _ready() -> void:
  set_physics_process(false)

func _physics_process(delta: float) -> void:
  player.fall_acceleration = 0
  $SpringPath/PathFollow3D.progress += speed * delta

func _on_area_3d_body_entered(body: Node3D) -> void:
  player = body
  player.reparent($SpringPath/PathFollow3D)
  set_physics_process(true)

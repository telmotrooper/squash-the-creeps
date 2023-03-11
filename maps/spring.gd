extends CSGBox3D

@export var speed := 9
var running := false

func _ready() -> void:
  set_physics_process(false)

func _physics_process(delta: float) -> void:
  $SpringPath/PathFollow3D.progress += speed * delta

func _on_area_3d_body_entered(player: Node3D) -> void:
  player.reparent($SpringPath/PathFollow3D)
  set_physics_process(true)

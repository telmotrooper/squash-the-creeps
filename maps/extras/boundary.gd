tool
extends Area
class_name Boundary

export (bool) var mesh_visible setget set_visible, get_visible

func set_visible(value: bool) -> void:
  $MeshInstance.visible = value

func get_visible() -> bool:
  return $MeshInstance.visible

func _on_Boundary_body_entered(body: Node) -> void:
  if body is Player:
    get_tree().call_group("players", "move_to_last_safe_position")
  elif body is Enemy or body is Slime:
    body.kill()

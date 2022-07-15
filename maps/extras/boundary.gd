tool
extends Area
class_name Boundary

export (bool) var mesh_visible setget set_visible, get_visible

func set_visible(value):
  $MeshInstance.visible = value

func get_visible():
  return $MeshInstance.visible

func _on_Boundary_body_entered(body):
  if body is Player:
    get_tree().call_group("players", "move_to_last_safe_position")
  elif body is Enemy:
    body.kill()

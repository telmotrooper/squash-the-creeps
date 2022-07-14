tool
extends Area

export (bool) var mesh_visible setget set_visible, get_visible

func set_visible(value):
  $MeshInstance.visible = value

func get_visible():
  return $MeshInstance.visible

func _on_Boundary_body_entered(body):
  if body is Player:
    get_tree().call_group("players", "die")
  elif body is Enemy:
    body.kill()

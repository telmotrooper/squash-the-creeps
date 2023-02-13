@tool
extends Area3D
class_name Boundary

@export (bool) var mesh_visible : get = get_visible, set = set_visible

func set_visible(value: bool) -> void:
  $MeshInstance3D.visible = value

func get_visible() -> bool:
  return $MeshInstance3D.visible

func _on_Boundary_body_entered(body: Node) -> void:
  if body is Player:
    get_tree().call_group("players", "move_to_last_safe_position")
    
    # TODO: Make this more generic. Currently only used in TestMap.
    var falling_bridge = get_node_or_null("%FallingBridge")
    if is_instance_valid(falling_bridge):
      falling_bridge.reset()
      
  elif body is Enemy or body is Slime:
    body.kill()

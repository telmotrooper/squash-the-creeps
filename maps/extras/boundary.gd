@tool
extends Area3D
class_name Boundary

@export var mesh_visible : bool : get = get_visible, set = _set_visible

func _set_visible(value: bool) -> void:
  $MeshInstance3D.visible = value

func get_visible() -> bool:
  return $MeshInstance3D.visible

func _on_Boundary_body_entered(body: Node) -> void:
  if body is Player or body is PlayerBall:
    get_tree().call_group("players", "move_to_last_safe_position")
    
    # TODO: Make this more generic. Currently only used in Avocado Beach.
    var falling_bridge = get_node_or_null("%FallingBridge")
    if is_instance_valid(falling_bridge):
      falling_bridge.reset()
      
  elif body is Enemy or body is Slime:
    body.kill()

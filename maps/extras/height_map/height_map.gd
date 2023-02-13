extends Node3D

func _ready() -> void:
  # This code is here so we can re-import "height_map.glb" from Blender without losing our changes.
  
  setup_collision_layers($height_map/Plane/Plane)
  setup_collision_layers($height_map/Hole/Hole)
  setup_collision_layers($height_map/TunnelRoom/TunnelRoom)

  $height_map/Hole/Hole.add_to_group("breakable_floor")

func setup_collision_layers(node: Node) -> void:
  node.set_collision_layer_value(0, false) # Remove from "Player"
  node.set_collision_layer_value(2, true)  # Add to "World3D"

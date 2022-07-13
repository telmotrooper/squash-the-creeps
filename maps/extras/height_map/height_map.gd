extends Spatial

func _ready():  
  $height_map/Plane/Plane.set_collision_layer_bit(0, false) # Remove from "Player"
  $height_map/Plane/Plane.set_collision_layer_bit(2, true) # Add to "World"
  
  $height_map/Hole/Hole.set_collision_layer_bit(0, false) # Remove from "Player"
  $height_map/Hole/Hole.set_collision_layer_bit(2, true) # Add to "World"
  
  $height_map/Hole/Hole.add_to_group("breakable")

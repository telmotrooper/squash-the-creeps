extends MeshInstance

func _process(_delta):
  if is_instance_valid(GameState.Player):  
    var player_camera = GameState.Player.get_node("%ClippedCamera")
    var copy_of_camera_position = player_camera.global_transform.origin
    copy_of_camera_position.y = 100
    look_at(copy_of_camera_position, Vector3.UP)

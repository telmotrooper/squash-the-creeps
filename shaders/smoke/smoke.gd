extends MeshInstance

func _process(_delta):
  if is_instance_valid(GameState.Player):  
    var copy_of_player_position = GameState.Player.transform.origin
    copy_of_player_position.y = 100
    look_at(copy_of_player_position, Vector3.UP)

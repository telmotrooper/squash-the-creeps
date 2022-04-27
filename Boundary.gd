extends Area

func _on_Boundary_body_entered(_body):
  get_tree().call_group("players", "die")

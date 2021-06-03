extends Area

func _on_Boundary_body_entered(body):
  get_tree().call_group("players", "die")

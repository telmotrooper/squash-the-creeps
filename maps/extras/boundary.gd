extends Area

func _on_Boundary_body_entered(body):
  if body is Player:
    get_tree().call_group("players", "die")
  elif body is Enemy:
    body.kill()

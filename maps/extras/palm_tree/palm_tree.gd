extends StaticBody3D

var shaking := false

func interact_on_spin() -> void:
  if not shaking:
    shaking = true
    print("interact_on_spin")

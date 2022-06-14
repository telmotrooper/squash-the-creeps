extends CSGBox

signal body_entered

var falling := false
var speed := 20
var lower_limit := 5

func _physics_process(delta):
  if falling:
    self.global_transform.origin.y -= delta * speed  

  if self.global_transform.origin.y < lower_limit:
    queue_free()

func _on_DetectArea_body_entered(_body):
  emit_signal("body_entered")

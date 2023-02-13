extends CSGBox

signal body_entered

var falling := false
var speed := 20
var lower_limit := 5
var initial_pos: Vector3

func _ready() -> void:
  initial_pos = Vector3(
    self.global_transform.origin.x,
    self.global_transform.origin.y,
    self.global_transform.origin.z
  )

func _physics_process(delta: float) -> void:
  if falling:
    self.global_transform.origin.y -= delta * speed  

  if self.global_transform.origin.y < lower_limit:
    visible = false
    #queue_free()

func _on_DetectArea_body_entered(_body: Node) -> void:
  emit_signal("body_entered")

func reset() -> void:
  falling = false
  visible = true
  self.global_transform.origin = Vector3(initial_pos.x, initial_pos.y, initial_pos.z)

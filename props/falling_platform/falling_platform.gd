extends CSGBox3D

signal body_entered

var falling := false
var speed := 20
var lower_limit := 5
var initial_pos: Vector3

func _ready() -> void:
	initial_pos = global_transform.origin

func _physics_process(delta: float) -> void:
	if falling:
		global_transform.origin.y -= delta * speed

	if global_transform.origin.y < lower_limit:
		visible = false
		#queue_free()

func _on_DetectArea_body_entered(_body: Node) -> void:
	body_entered.emit()

func reset() -> void:
	falling = false
	visible = true
	global_transform.origin = initial_pos

extends StaticBody3D

var shaking := false

func _ready() -> void:
	for child in get_children():
		if child is Gem:
			child.freeze = true

func interact_on_spin() -> void:
	if not shaking:
		for child in get_children(): # Drop gem.
			if child is Gem:
				child.freeze = false
	
	shaking = true
	var tween = create_tween().set_loops(2)
	tween.tween_property($Pivot, "rotation_degrees:x", 2.5, 0.2)
	tween.tween_property($Pivot, "rotation_degrees:x", 0, 0.2)
	tween.tween_callback(done)

func done() -> void:
	shaking = false

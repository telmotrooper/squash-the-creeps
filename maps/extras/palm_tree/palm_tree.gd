extends StaticBody3D

const tilt_degrees := 2.5
var shaking := false

func _ready() -> void:
	for child in get_children():
		if child is Gem:
			child.freeze = true

func interact_on_spin(_player_position: Vector3) -> void:
	if not shaking:
		shaking = true
		
		for child in get_children(): # Drop gem.
			if child is Gem:
				child.freeze = false
	
		var tween = create_tween().set_loops(2)
		tween.tween_property($Pivot, "rotation_degrees:x", tilt_degrees, 0.2)
		tween.tween_property($Pivot, "rotation_degrees:x", 0, 0.2)
		await tween.finished
		
		shaking = false

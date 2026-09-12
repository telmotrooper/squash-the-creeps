extends TextureButton

const colors = [Color.WHITE, Color.RED, Color.GREEN]

var current_color := 0

func _on_pressed() -> void:
	current_color += 1
	var index := current_color % colors.size()
	self_modulate = colors[index]

extends Node

signal faded_out

var main: Node = null
var fade: Node = null

func available() -> bool:
	return is_instance_valid(main)

func fade_available() -> bool:
	return is_instance_valid(fade)

func register(node: Node) -> void:
	main = node

func register_fade(fade_node: Node) -> void:
	fade = fade_node
	fade.faded_out.connect(faded_out.emit)

func cover_screen() -> void:
	if fade_available():
		fade.cover()

func change_scene(scene_path: String) -> void:
	if available():
		main.load_scene(scene_path)
	else:
		get_tree().change_scene_to_file(scene_path)

func reload() -> void:
	if available():
		main.load_scene(main.current_scene_path())
	else:
		get_tree().reload_current_scene()

func fade_out() -> void:
	if fade_available():
		fade.fade_out()

func fade_in() -> void:
	if fade_available():
		fade.fade_in()

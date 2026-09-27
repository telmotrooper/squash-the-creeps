extends Node

signal faded_out

const MAP_PREFIX := "res://maps/"

var fade: FadeTransition
var loading_scene := ""

func fade_available() -> bool:
	return is_instance_valid(fade)

func register_fade(fade_node: FadeTransition) -> void:
	fade = fade_node
	fade.faded_out.connect(faded_out.emit)

func cover_screen() -> void:
	if fade_available():
		fade.cover()

func change_scene(scene_path: String) -> void:
	if loading_scene != "":
		return
	if not ResourceLoader.exists(scene_path):
		push_error("Could not find scene \"%s\"." % scene_path)
		return
	loading_scene = scene_path
	ResourceLoader.load_threaded_request(loading_scene)

	if fade_available():
		fade_out()
		await faded_out

	while ResourceLoader.load_threaded_get_status(loading_scene) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame

	var packed_scene: PackedScene = ResourceLoader.load_threaded_get(loading_scene)
	loading_scene = ""
	if packed_scene == null:
		push_error("Could not load scene \"%s\"." % scene_path)
		fade_in()
		return
	_swap_scene(packed_scene, scene_path)

func reload() -> void:
	var current_scene := get_tree().current_scene
	if current_scene == null:
		return
	change_scene(current_scene.scene_file_path)

func fade_out() -> void:
	if fade_available():
		fade.fade_out()

func fade_in() -> void:
	if fade_available():
		fade.fade_in()

func _swap_scene(packed_scene: PackedScene, scene_path: String) -> void:
	var next_scene: Node = packed_scene.instantiate()
	var is_map := scene_path.begins_with(MAP_PREFIX)
	UserInterface.visible = is_map
	if is_map:
		UserInterface.reset_for_map()
		GameState.generate_progress_report(str(next_scene.name))

	var previous_scene := get_tree().current_scene
	get_tree().current_scene = null
	if previous_scene:
		get_tree().root.remove_child(previous_scene)
		previous_scene.queue_free()
	get_tree().root.add_child(next_scene)
	get_tree().current_scene = next_scene

	get_tree().paused = false
	fade_in()

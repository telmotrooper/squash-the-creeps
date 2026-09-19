extends Node3D

@export var initial_scene: PackedScene

const WORLD_SCENE_PREFIX := "res://maps/"

var current_scene = null
var loading_scene = null
var progress = []

func _ready() -> void:
	set_process(false)
	load_scene(initial_scene.get_path())

func load_scene(scene_to_load: NodePath) -> void:
	loading_scene = scene_to_load
	# $ProgressBar.value = 0
	# $ProgressBar.show()
	ResourceLoader.load_threaded_request(loading_scene)
	
	$FadeTransition.fade_out()
	await $FadeTransition.faded_out
	
	if current_scene:
		$WorldScene.remove_child(current_scene)
		if is_instance_valid(current_scene):
			current_scene.queue_free()
		current_scene = null
	set_process(true)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(loading_scene, progress)
	$ProgressBar.value = progress[0] * 100
	
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene_path := str(loading_scene)
		var new_scene = ResourceLoader.load_threaded_get(loading_scene)
		loading_scene = null
		current_scene = new_scene.instantiate()
		var is_map := scene_path.begins_with(WORLD_SCENE_PREFIX)
		UserInterface.visible = is_map
		if is_map:
			UserInterface.reset_for_map()
			GameState.generate_progress_report(str(current_scene.name))
		$WorldScene.add_child(current_scene)
		get_tree().paused = false
		$FadeTransition.fade_in()
		set_process(false)
		# await get_tree().create_timer(0.5).timeout
		# $ProgressBar.hide()

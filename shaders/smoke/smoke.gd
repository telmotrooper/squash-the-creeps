@tool
extends MeshInstance3D

var current_camera: Camera3D

func _process(_delta: float) -> void:
	current_camera = get_viewport().get_camera_3d()
	if is_instance_valid(current_camera):  
		var copy_of_camera_position = current_camera.global_transform.origin
		copy_of_camera_position.y = 100
		look_at(copy_of_camera_position, Vector3.UP)

func play_sound() -> void:
	$AudioStreamPlayer3D.play()

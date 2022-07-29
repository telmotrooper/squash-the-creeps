tool
extends MeshInstance

var current_camera: Camera

func _process(_delta):
  current_camera = get_viewport().get_camera()
  if is_instance_valid(current_camera):  
    var copy_of_camera_position = current_camera.global_transform.origin
    copy_of_camera_position.y = 100
    look_at(copy_of_camera_position, Vector3.UP)

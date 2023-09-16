extends Node3D

const ZOOM_STEP := 0.5
var min_zoom := 9
var max_zoom := 18

var horizontal: float = 0
var vertical: float = 0
var v_min: float = -70 # Looking up
var v_max: float = 12 # Look down
var h_acceleration := 10
var v_acceleration := 10

func _ready() -> void:
	if (GameState.camera_distance):
		%SpringArm3D.spring_length = GameState.camera_distance
		
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Prevent camera from colliding with player.
#  $Horizontal/Vertical/Camera3D.add_exception(get_parent())
	# Fetch draw distance from configuration file.
	%Camera3D.far = Configuration.get_value("graphics", "draw_distance")

func _input(event: InputEvent) -> void:
	if get_parent() is Player and get_parent().paused: # Used to prevent camera movement when returning from a cutscene.
		return
	
	var zoom = %SpringArm3D.spring_length

	if event is InputEventMouseMotion:
		horizontal -= event.relative.x * Configuration.get_value("controls", "mouse_sensitivity")
		vertical -= event.relative.y * Configuration.get_value("controls", "mouse_sensitivity")
	elif event.is_action_pressed("zoom_in") and zoom > min_zoom:
		%SpringArm3D.spring_length -= ZOOM_STEP
		GameState.camera_distance = %SpringArm3D.spring_length
	elif event.is_action_pressed("zoom_out") and zoom < max_zoom:
		%SpringArm3D.spring_length += ZOOM_STEP
		GameState.camera_distance = %SpringArm3D.spring_length

func _physics_process(delta: float) -> void:
	# print(vertical) # It's useful to print the current value when trying to find the proper values for 'min' and 'max'.
	
	# Lock "vertical" position in range [v_min, v_max].
	vertical = clamp(vertical, v_min, v_max)

	# Move camera smoothly based checked "delta * acceleration".
	$Horizontal.rotation_degrees.y = lerp($Horizontal.rotation_degrees.y, horizontal, delta * h_acceleration)
	$Horizontal/Vertical.rotation_degrees.x = lerp($Horizontal/Vertical.rotation_degrees.x, vertical, delta * v_acceleration)

extends Spatial

const ZOOM_STEP = 0.1

var horizontal := 0
var vertical := 0
var v_min := -70 # Looking up
var v_max := 12 # Look down
var h_acceleration := 10
var v_acceleration := 10

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  # Prevent camera from colliding with player.
  $Horizontal/Vertical/ClippedCamera.add_exception(get_parent())
  # Fetch draw distance from configuration file.
  $Horizontal/Vertical/ClippedCamera.far = Configuration.get_value("graphics", "draw_distance")

func _input(event):
  if event is InputEventMouseMotion:
    horizontal -= event.relative.x * Configuration.get_value("controls", "mouse_sensitivity")
    vertical -= event.relative.y * Configuration.get_value("controls", "mouse_sensitivity")
  elif event.is_action_pressed("zoom_in"):
    print("zooming in")
  elif event.is_action_pressed("zoom_out"):
    print("zooming out")

func _physics_process(delta):
  #print(vertical) # It's useful to print the current value when trying to find the proper values for 'min' and 'max'.
  
  # Lock "vertical" position in range [v_min, v_max].
  vertical = clamp(vertical, v_min, v_max)

  # Move camera smoothly based on "delta * acceleration".
  $Horizontal.rotation_degrees.y = lerp($Horizontal.rotation_degrees.y, horizontal, delta * h_acceleration)
  $Horizontal/Vertical.rotation_degrees.x = lerp($Horizontal/Vertical.rotation_degrees.x, vertical, delta * v_acceleration)

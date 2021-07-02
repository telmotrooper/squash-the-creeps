extends Spatial

var horizontal =  0
var vertical = 0
var v_min = -70 # Looking up
var v_max = 12 # Look down
var h_acceleration = 10
var v_acceleration = 10

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  # Prevent camera from colliding with player.
  $Horizontal/Vertical/ClippedCamera.add_exception(get_parent())

func _input(event):
  if event is InputEventMouseMotion:
    horizontal -= event.relative.x * Configuration.get_value("controls", "mouse_sensitivity")
    vertical -= event.relative.y * Configuration.get_value("controls", "mouse_sensitivity")

func _physics_process(delta):
  #print(vertical) # It's useful to print the current value when trying to find the proper values for 'min' and 'max'.
  vertical = clamp(vertical, v_min, v_max)
  
  $Horizontal.rotation_degrees.y = lerp($Horizontal.rotation_degrees.y, horizontal, delta * h_acceleration)
  $Horizontal/Vertical.rotation_degrees.x = lerp($Horizontal/Vertical.rotation_degrees.x, vertical, delta * v_acceleration)
  

extends Spatial

var horizontal = 0

func _ready():
  # Prevent camera from colliding with player.
  $Horizontal/Vertical/ClippedCamera.add_exception(get_parent())

func _input(event):
  if event is InputEventMouseMotion:
    horizontal += -event.relative.x

func _physics_process(delta):
  $Horizontal.rotation_degrees.y = horizontal
  

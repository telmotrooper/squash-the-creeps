extends Spatial

var platforms := []
var index := 0

func _ready():
  for platform in $Platforms.get_children():
    platforms.append(platform)

func _on_FallingPlatform_body_entered():
  if $Timer.is_stopped():
    $Timer.start()

func _on_Timer_timeout():
  if index < platforms.size():
    platforms[index].falling = true
    index += 1

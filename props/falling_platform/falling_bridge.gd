extends Spatial

var platforms := []
var index := 0

func _ready() -> void:
  for platform in $Platforms.get_children():
    platforms.append(platform)

func _on_FallingPlatform_body_entered() -> void:
  if $Timer.is_stopped():
    $Timer.start()

func _on_Timer_timeout() -> void:
  if index < platforms.size():
    platforms[index].falling = true
    index += 1

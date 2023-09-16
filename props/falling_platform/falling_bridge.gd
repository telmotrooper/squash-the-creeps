extends Node3D

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
	else: # No more platforms to fall.
		$Timer.stop()

func reset() -> void:
	index = 0
	$Timer.stop()
	for platform in $Platforms.get_children():
		platform.reset()

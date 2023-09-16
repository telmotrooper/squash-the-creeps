extends Node3D

var played:= false
var text_index = 1
var text = "CHECKPOINT"
var initial_flag_y: float


func _ready() -> void:
	$Label3D.hide()
	initial_flag_y = $Pivot/Flag.global_transform.origin.y

func _on_text_timer_timeout() -> void:
	$Label3D.text = text.substr(0, text_index)
	$Label3D.show()
	
	text_index += 1
	if text_index > text.length():
		$TextTimer.stop()
		$VisibilityTimer.start()

func _on_area_3d_body_entered(body: Node3D) -> void:
	# Lower flag the first time (when material is not overriden yet).
	if not played:
		played = true
		var tween = create_tween()
		tween.set_parallel(true)
		$Flag2.show()
		tween.tween_property($Pivot, "rotation_degrees:y", 45, 1)
		tween.tween_property($Pivot/Flag, "position:y", -8, 1)
		tween.tween_property($Flag2, "global_transform:origin:y", initial_flag_y, 1)
		tween.set_parallel(false)
		tween.tween_callback($TextTimer.start)
		tween.tween_callback($AudioStreamPlayer3D.play)
		tween.tween_callback($Pivot/Flag.hide)
	else: # Otherwise just show the label.
		if not $Label3D.visible:
			text = "HEALTH REPLENISHED"
		$TextTimer.start()
	
	if body is Player:
		var player = body
		player.set_health(3)

func _on_visibility_timer_timeout() -> void:
	$Label3D.hide()
	text_index = 0

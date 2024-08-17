extends Control
class_name Dialog

signal finished

var text_to_write := ""
var is_writing := false
var index = 0

var duration := 0.03 # seconds
var time := 0.0

func _ready() -> void:
	set_process(false)
	hide()
	%DialogText.text = ""

func _process(delta: float) -> void:
	# Type out the dialog one character at a time.
	time += delta
	if time >= duration:
		index += 1
		%DialogText.text = text_to_write.substr(0, index)
		time -= duration
	
	if len(%DialogText.text) >= len(text_to_write):
		is_writing = false
		set_process(false)

func _input(event: InputEvent) -> void:
	if visible:
		var valid_event = event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton
		
		if valid_event and (event.is_action_pressed("interact") or Input.is_action_just_pressed("skip_dialog")):
			if is_writing:
				index = text_to_write.length()
			elif len(%DialogText.text) >= len(text_to_write):
				close_dialog()

func set_text(text) -> void:
	text_to_write = text

func open_dialog() -> void:
	GameState.Player.set_cutscene_mode(true)
	GameState.minimap.hide()
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_callback(func():
		is_writing = true
		set_process(true)
	)

func close_dialog() -> void:
	set_process(false)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.tween_callback(func():
		index = 0
		text_to_write = ""
		%DialogText.text = ""
		hide()
		GameState.minimap.show()
		GameState.Player.set_cutscene_mode(false)
		finished.emit()
	)

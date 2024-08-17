extends Control
class_name SkipCutscene

@export var animation_player: AnimationPlayer

var first_time := true
signal skip

enum Mode { ANIMATION_PLAYER, SIGNAL }
var mode := Mode.ANIMATION_PLAYER

func _ready() -> void:
	hide()
	if animation_player:
		animation_player.connect("animation_started", enable)
		animation_player.connect("animation_finished", disable)
	set_process(false)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if first_time:
			show()
			first_time = false
		else:
			if mode == Mode.ANIMATION_PLAYER:
				animation_player.play("RESET") # Skip cutscene.
			else:
				skip.emit()
			first_time = true # Reset counter for future cutscenes.
			hide()
			set_process(false)

func enable(_anim_name: StringName = "") -> void:
	set_process(true)

func disable(_anim_name: StringName = "") -> void:
	hide()
	set_process(false)

func set_mode(new_mode: Mode) -> void:
	mode = new_mode

extends Control

var minimap_default_position: Vector2
var minimap_proportion: float
var hud_visible := false

func _ready() -> void:
	# If every map is gonna have its own UserInterface instance,
	# we'll need a reference to the current one.
	GameState.UserInterface = self
	GameState.dialog = $Dialog
	GameState.minimap = $Minimap
	
	$Dialog.modulate = Color(1, 1, 1, 0)
	
	$Minimap.hide()
	resize_minimap()
	
	get_tree().paused = false
	$Pause.hide()
	
	$Pause/PauseMenu.show()

	# Guarantee all submenus are initially closed.
	for submenu in $Pause/Submenus.get_children():
		submenu.hide()

	$CongratulationsDialog.hide()
	
	if is_instance_valid(owner):
		GameState.generate_progress_report(owner.name)
	%GemLabel.text = "%d" % GameState.amount_of_gems

func _process(_delta: float) -> void:
	$FPSLabel.text = "FPS: %s" % Engine.get_frames_per_second()

func show_hud() -> void:
	$HUDTimer.start()
	if not hud_visible:
		$HUDAnimationPlayer.play_backwards("hide_hud")
		hud_visible = true

func hide_hud() -> void: # Triggered by HUDTimer.
	if hud_visible:
		$HUDAnimationPlayer.play("hide_hud")
		hud_visible = false

func show_all_godot_heads_collected() -> void:
	show_announcement("100% Godot Heads collected")

func show_all_gems_collected() -> void:
	show_announcement("100% gems collected")

func show_announcement(text: String) -> void:
	if $AnnouncementAnimationPlayer.is_playing():
		# If another announcement is underway, wait 5 seconds and try again.
		var timer = get_tree().create_timer(5, false)
		await timer.timeout
	
	$Announcement.text = text
	$AnnouncementAnimationPlayer.play("show_all_godot_heads_collected")

func show_congratulations() -> void:
	$CongratulationsDialog.popup_centered()
	GameState.change_bgm_volume(-10)
	$CongratulationsDialog/AnimationPlayer.play("congratulations")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _on_congratulations_dialog_confirmed() -> void:
	GameState.change_bgm_volume(+10)
	$CongratulationsDialog/AnimationPlayer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func resize_minimap() -> void:
	var minimap_scale = 0.7 if get_window().mode == Window.MODE_WINDOWED else 0.9
	var minimap_pivot_offset = 40 if get_window().mode == Window.MODE_WINDOWED else 40*3
	$Minimap.scale = Vector2(minimap_scale,minimap_scale)
	$Minimap.pivot_offset = Vector2(minimap_pivot_offset,-minimap_pivot_offset)

func set_minimap(minimap_texture: Texture2D, center: Vector2 = Vector2(0,0), proportion: float = 1.0) -> void:
	if is_instance_valid(GameState.Player):
		%InnerMinimapPivot.rotation = GameState.Player.rotation.y
	
	%MapTexture.texture = minimap_texture
	# Centralize the minimap on the player.
	%MapTexture.position.x += center.x
	%MapTexture.position.y += center.y
	# Store the position calculated.
	minimap_default_position = %MapTexture.position
	# Store the proportion so that when the player moves the minimap moves the correct amount.
	minimap_proportion = proportion
	$Minimap.show()

func move_minimap(player_offset: Vector3) -> void:
	# print('player_offset: (%.2f,%.2f)' % [player_offset.x, player_offset.z])
	%MapTexture.position.x = minimap_default_position.x - player_offset.x * minimap_proportion
	%MapTexture.position.y = minimap_default_position.y - player_offset.z * minimap_proportion

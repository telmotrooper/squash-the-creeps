extends Node

const MENU_FADE_OUT = "menu_fade_out"
export (PackedScene) var new_game_scene
export (AudioStream) var menu_music
var button_pressed: String

func _ready():
  GameState.play_music(menu_music)
  var version = Engine.get_version_info()
  get_node("%VersionLabel").text = "DEMO RELEASE – GODOT %d.%d.%d" % [version.major, version.minor, version.patch]
  
  get_node("%Settings").visible = false

func _on_Button_pressed(button_name):
  button_pressed = button_name
  $AnimationPlayerMenu.play(MENU_FADE_OUT)

func _on_AnimationPlayerMenu_animation_finished(anim_name):
  if anim_name == MENU_FADE_OUT:
    if button_pressed == "new_game":
      GameState.MapName = "hub_1"
      if is_instance_valid($"/root/Main"):
        $"/root/Main".load_world(new_game_scene.get_path())
        GameState.initialize()
      else:
        var _error = get_tree().change_scene(new_game_scene.get_path())
    elif button_pressed == "settings":
      get_node("%Settings").visible = true
    elif button_pressed == "exit":
      get_tree().quit()

func _on_AnimationPlayerSpaceship_animation_finished(anim_name):
  if anim_name == "coming_in":
    $Spatial/AnimationPlayerSpaceship.play("flying_in_space")


func _on_CenterContainer_gui_input(event: InputEvent):
  if event is InputEventMouseButton and event.button_index == 1 and $Spatial/AnimationPlayerSpaceship.current_animation == "flying_in_space":
    $Spatial/AnimationPlayerAlien.play("spin_y")

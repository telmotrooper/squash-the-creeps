extends Node

export (PackedScene) var enemy_scene
export var spawn_enemies := true

func _ready():
  GameState.Grass = $Map/Grass
  GameState.update_grass()
  
  if !spawn_enemies:
    $EnemyTimer.stop()
  randomize()

func _unhandled_input(event):
  if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
    GameState.reload_current_scene()
    #var error = get_tree().reload_current_scene()
    #if (error):
    #  print("Error: Unable to reload current scene.")

func _on_EnemyTimer_timeout():
  var enemy = enemy_scene.instance()
  
  var enemy_spawn_location = $SpawnPath/SpawnLocation
  enemy_spawn_location.unit_offset = randf()
  
  var player_position = $Player.transform.origin
  
  add_child(enemy)
  enemy.initiliaze(enemy_spawn_location.translation, player_position)

func _on_Player_hit():
  $EnemyTimer.stop()
  $UserInterface/Retry.show()

func _on_RedButton_pressed():
  $Goweti/Manual/AnimationPlayer.play("move_platforms")

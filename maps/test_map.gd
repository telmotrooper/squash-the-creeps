extends Node

export (PackedScene) var enemy_scene
export var spawn_enemies := true

func _ready():
  GameState.RetryCamera = $RetryCamera
  GameState.Grass = $Map/Grass
  GameState.update_grass()
  
  if !spawn_enemies:
    $EnemyTimer.stop()
  randomize()

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
  $RetryCamera.current = true

func _on_RedButton_pressed():
  $Goweti/Manual/AnimationPlayer.play("move_platforms")

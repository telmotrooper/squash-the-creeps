extends Node3D

signal tiki_freed

func _ready() -> void:
  if GameState.events.tiki_freed:
    $CageStaticBody3D.queue_free()
    $AnimationPlayer.stop()
    $tiki_npc/Label3D.hide()

func free_tiki() -> void:
  $AnimationPlayer.stop()
  $tiki_npc/Label3D.hide()
    
  # Move Tiki to the floor.
  create_tween().tween_property($tiki_npc, "position:y", 0, 0.25)
  
  GameState.dialog.set_text(
    "Thanks for saving me, maaan!\n" +
    "I found this blue thingy in the beach... you can have it."
  )
  GameState.dialog.open_dialog()
  
  await GameState.dialog.finished

  $tiki_npc/Label3D.text = "THANKS!"
  $tiki_npc/Label3D.show()
  var tween_2 = create_tween().set_loops()
  tween_2.tween_property($tiki_npc, "position:y", 0.5, 0.25)
  tween_2.tween_property($tiki_npc, "position:y", 0, 0.25)
  
  GameState.events.tiki_freed = true
  emit_signal("tiki_freed")

func _on_area_3d_body_entered(_body):
  if GameState.events.tiki_freed:
    $tiki_npc/Label3D.text = "Hey, maaan!"
    $tiki_npc/Label3D.show()
    var tween = create_tween().set_loops(2)
    tween.tween_property($tiki_npc, "position:y", 0.5, 0.25)
    tween.tween_property($tiki_npc, "position:y", 0, 0.25)

func _on_area_3d_body_exited(_body):
  if GameState.events.tiki_freed:
    $tiki_npc/Label3D.hide()

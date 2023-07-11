extends Node3D

func free_tiki() -> void:
  $AnimationPlayer.stop()
  var tween = create_tween()
  # Move Tiki to the floor.
  tween.tween_property($tiki_npc, "position:y",0, 0.25)
  $tiki_npc/Label3D.hide()
  await get_tree().create_timer(1).timeout
  $tiki_npc/Label3D.text = "THANKS!"
  $tiki_npc/Label3D.show()

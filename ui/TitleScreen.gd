extends Node

func _on_NewGameButton_pressed():
  get_tree().change_scene("res://Main.tscn")

func _on_ExitButton_pressed():
  get_tree().quit()

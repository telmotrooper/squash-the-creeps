extends Control

var score = 0

func _ready():
  # If every map is gonna have its own UserInterface instance,
  # we'll need a reference to the current one.
  GameState.UserInterface = self

func _on_Enemy_squashed():
  score += 1
  $ScoreLabel.text = "Score: %s" % score

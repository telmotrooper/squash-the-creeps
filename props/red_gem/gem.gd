extends RigidBody3D
class_name Gem

@export var collected_sound: AudioStream
@export var gem_value := 3

var follow_player := false
var t := 0.0

func _ready() -> void:
  GameState.register_gem(owner.name, get_path(), gem_value)

  if GameState.gems_collected[owner.name][get_path()].collected:
    queue_free()

# https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html
func _physics_process(delta: float) -> void:
  if follow_player and is_instance_valid(GameState.Player):
    var player_position = GameState.Player.global_transform.origin
    var gem_position = self.global_transform.origin
    
    var distance = gem_position.distance_to(player_position)
    
    # Make gem follow player.
    t += delta * 0.25
    self.global_transform.origin = gem_position.lerp(player_position, t)
    
    if distance <= 1 or t >= 1.0:
      GameState.collect_gem(owner.name, get_path())
      GameState.play_audio(collected_sound)
      queue_free()

func _on_GrabArea_body_entered(_body: Node) -> void:
  follow_player = true

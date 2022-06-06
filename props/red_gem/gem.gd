extends RigidBody
class_name Gem

var follow_player := false
var t := 0.0

# https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html
func _physics_process(delta):
  if follow_player and is_instance_valid(GameState.Player):
    var player_position = GameState.Player.global_transform.origin
    var gem_position = self.global_transform.origin
    
    var distance = gem_position.distance_to(player_position)
    
    # Make gem follow player.
    t += delta * 0.25
    self.global_transform.origin = gem_position.linear_interpolate(player_position, t)
    
    if distance <= 0.8 or t >= 1.0:
      queue_free()

func _on_GrabArea_body_entered(_body):
  follow_player = true

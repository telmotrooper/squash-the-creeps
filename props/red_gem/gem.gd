extends RigidBody
class_name Gem

var follow_player := false
var t := 0.0

func _physics_process(delta):
  # https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html
  if follow_player: #and t < 1.0:
    var player_position = GameState.Player.global_transform.origin
    var gem_position = self.global_transform.origin
    
    t += delta
    var distance = gem_position.distance_to(player_position)
    
    print("t: %f distance: %f" % [t, distance])
    
    self.global_transform.origin = gem_position.linear_interpolate(player_position, t)


func _on_GrabArea_body_entered(body):
  follow_player = true

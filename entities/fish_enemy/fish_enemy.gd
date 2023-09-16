extends CharacterBody3D

@export var patrolling_speed := 9

func _physics_process(delta: float) -> void:
	if get_parent() is PathFollow3D:
		get_parent().progress += patrolling_speed * delta
#    print(get_parent().progress_ratio)

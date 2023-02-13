@tool
extends "base_modifier.gd"


@export var path_name # (String, "Node")
@export var strength = 1.0 # (float, 0.0, 1.0)
@export var override_global_seed := false
@export var custom_seed := 0

var _rng: RandomNumberGenerator


func _init():
	display_name = "Remove From Path3D"
	category = "Remove"


func _process_transforms(transforms, global_seed) -> void:
	if not transforms.path.has_node(path_name):
		warning += "Could not find " + path_name
		warning += "\n Make sure the curve exists as a child of the Scatter node"
		return

	var exclude_root = transforms.path.get_node(path_name)
	var paths := _get_paths_recursive(exclude_root)

	var global_transform = transforms.path.global_transform
	var pos: Vector3
	var i := 0

	_rng = RandomNumberGenerator.new()
	if override_global_seed:
		_rng.set_seed(custom_seed)
	else:
		_rng.set_seed(global_seed)

	while i < transforms.list.size():
		pos = global_transform * transforms.list[i].origin
		for p in paths:
			if p.is_point_inside(pos * p.global_transform):
				var random_value := _rng.randf()
				if random_value < strength:
					transforms.list.remove_at(i)
					i -= 1
					break
		i += 1


func _get_paths_recursive(root) -> Array:
	var res = []
	if root is Path3D:
		res.push_back(root)

	for c in root.get_children():
		if c is Path3D:
			res += _get_paths_recursive(c)

	return res

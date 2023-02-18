extends Node

func exists(resource_path: String) -> void:
  assert(ResourceLoader.exists(resource_path)) #,"Error: Resource '%s' not found." % resource_path)

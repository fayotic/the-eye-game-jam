extends Node

func load_path(path: String) -> void:
	get_tree().change_scene_to_file(path)

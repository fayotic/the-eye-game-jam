extends Node2D

class_name SceneTransitioner

@onready var animation_player = $CanvasLayer/AnimationPlayer

func change_scene(scene_path: String, use_transition: bool = true) -> void:
	if not use_transition:
		get_tree().change_scene_to_file(scene_path)
		return

	await fadeout()
	get_tree().change_scene_to_file(scene_path)
	await fadein()


func fadeout() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished


func fadein() -> void:
	animation_player.play_backwards("fade_out")
	await animation_player.animation_finished

extends Node2D


@onready var animation_player = $CanvasLayer/AnimationPlayer

func change_scene(scene_path: String) -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file(scene_path)
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
	

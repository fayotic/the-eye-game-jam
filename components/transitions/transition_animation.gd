extends Node2D


@onready var animation_player = $CanvasLayer/AnimationPlayer

func change_scene(scene_path: String) -> void:

	animation_player.play("fade_out")
	await animation_player.animation_finished
	animation_player.play_backwards("fade_out")
	get_tree().change_scene_to_file(scene_path)
	
	

	
func use_transition():
	get_node("CanvasLayer/ColorRect").visible = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	animation_player.play_backwards("fade_out")
	await animation_player.animation_finished
	get_node("CanvasLayer/ColorRect").visible = false
	
	
	

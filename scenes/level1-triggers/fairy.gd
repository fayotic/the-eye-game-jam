extends Area3D
@export var fairy_animation: AnimationPlayer
@export var fairy_cutscene: Node3D
@export var blazer_node: Area3D
@export var fairy_camera: Camera3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and blazer_node.get_picked_up() == true:
		await get_tree().create_timer(0.5).timeout
		fairy_cutscene.show()
		fairy_camera.make_current()
		fairy_animation.play("mayram_turning")
		fairy_cutscene.script()
		

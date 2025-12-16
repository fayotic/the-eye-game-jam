extends Node3D

@onready var trigger_area = $BasicTrigger
const Boss = preload("res://components/boss/boss.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if "Player" in body.name:
			#This will be replaced with whatever trigger we need :3
			print("Trigger zone hit!")
			

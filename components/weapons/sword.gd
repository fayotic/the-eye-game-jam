extends Node3D

func _ready():
	pass

#If an enemy is in Area3D, then it will take damage
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		pass

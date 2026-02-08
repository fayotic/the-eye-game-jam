extends CSGBox3D

func open_door() -> void:
	$AnimationPlayer.play("open")

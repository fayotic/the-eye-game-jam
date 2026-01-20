extends Area3D

@onready var dialogue_system = $DialogueSystem
var is_picked_up = false;


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and not is_picked_up:
		dialogue_system.display_dialogue("Coal retrieved from brazier. Bring coal to hookah.")
		is_picked_up = true; #Should null the trigger afterwards
		print(is_picked_up)
		
func get_picked_up():
	return is_picked_up
		
	
		
	

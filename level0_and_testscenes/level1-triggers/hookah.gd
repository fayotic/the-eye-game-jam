extends Area3D
@onready var dialogue_system = $DialogueSystem2
@export var blazer_node : Node #Uses blazer node to get is_picked_up 


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and not blazer_node.is_picked_up:
		dialogue_system.display_dialogue("Retrieve coal from brazier.")
	
		

		
	
	
	

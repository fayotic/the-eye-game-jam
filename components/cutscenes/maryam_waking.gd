extends Node3D

@onready var dialogue = $DialogueSystem
@onready var animation = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera3D.make_current()
	await animation.animation_finished
	dialogue.display_dialogue("Did I...did I fall asleep? I must have been more tired then I thought.")
	await get_tree().create_timer(5.0).timeout
	dialogue.display_dialogue("I guess I could use a smoke. But I will need to light it first.")
	

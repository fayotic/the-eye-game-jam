extends Node3D

@export var dialogue_system: DialogueSystem

func _ready() -> void:
	SettingsManager.in_game = true
	await get_tree().create_timer(6.0).timeout
	if dialogue_system:
		dialogue_system.dialogue_speaker = "Mother"
		dialogue_system.display_dialogue(
			"This is a test line to display the dialogue system. It should also wrap correctly."
			)

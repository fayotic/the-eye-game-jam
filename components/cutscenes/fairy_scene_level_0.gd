extends Node3D
@onready var animation = $AnimationPlayer
@onready var fairy_animation = $NPC_Fairy/AnimationPlayer
@onready var dialogue = $DialogueSystem



# Called when the node enters the scene tree for the first time.
	
func script():
	dialogue.dialogue_speaker = "Fairy"
	await dialogue.display_dialogue("Peace be upon you.")
	
	dialogue.dialogue_speaker = "Mother"
	await dialogue.display_dialogue("And upon you. What- who are you? Why are you here?")
	
	dialogue.dialogue_speaker = "Fairy"
	await dialogue.display_dialogue("You know what I am.")

	dialogue.dialogue_speaker = "Mother"
	await dialogue.display_dialogue("Yes, but why do you look like...")

	dialogue.dialogue_speaker = "Fairy"
	await dialogue.display_dialogue("I am who I am. It matters not.")
	await dialogue.display_dialogue("I see... Devil...")
	
	dialogue.dialogue_speaker = "Mother"
	await dialogue.display_dialogue("I don't think... there is nothing to be done.")

	dialogue.dialogue_speaker = "Fairy"
	await dialogue.display_dialogue("No.")
	await get_tree().create_timer(5.0).timeout
	await dialogue.display_dialogue("Do you see where you stand?")
	
	dialogue.dialogue_speaker = "Mother"
	await dialogue.display_dialogue("I know where I stand. As I've been here for over half of my life, by God's will.")
	
	dialogue.dialogue_speaker = "Fairy"
	await dialogue.display_dialogue("Look again.")
	
	animation.play("mayram_windows")
	
	dialogue.dialogue_speaker = "Mother"
	await dialogue.display_dialogue("The windows...")
	
	dialogue.dialogue_speaker = "Fairy"
	await dialogue.display_dialogue("I have come to help you, my dear.")
	
	
	

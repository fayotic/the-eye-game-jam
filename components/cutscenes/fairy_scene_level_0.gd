extends Node3D
@onready var animation = $AnimationPlayer
@onready var fairy_animation = $NPC_Fairy/AnimationPlayer
@onready var dialogue = $DialogueSystem
@onready var sword = $LowPolySword
@onready var fairy = $NPC_Fairy
@export var fairy_trigger_collision: CollisionShape3D
@export var player_cam: Camera3D
@export var player: CharacterBody3D
var scene_done = false

	
func script():
	#Stops character movement
	player.stop_movement()
	#Script
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
	await get_tree().create_timer(3.0).timeout
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
	sword.show()
	animation.play("sword floating")


	dialogue.dialogue_speaker = "Fairy"
	await dialogue.display_dialogue("With this Talwar, will you cleanse the devil. And let your left hand be the judge for these wicked creatures.")
	await get_tree().create_timer(2.0).timeout
	sword.hide()
	
	dialogue.dialogue_speaker = "Unknown"
	await dialogue.display_dialogue("Acquired Talwar.")
	dialogue.dialogue_speaker = "Mother"
	await dialogue.display_dialogue("Yusuf... my dear.")
	dialogue.dialogue_speaker = "Fairy"
	await dialogue.display_dialogue("Now let's go. And when you go, may you know that I light YOUR way.")
	await get_tree().create_timer(3.0).timeout
	
	#Hides fairy asset, trigger, and changes camera back to player and resumes movement
	fairy.hide()
	fairy_trigger_collision.disabled = true
	player.show()
	player_cam.make_current()
	player.resume_movement()
	scene_done = true
	
	

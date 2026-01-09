extends Node3D

@export var dialogue_system: DialogueSystem
@onready var cutscene = $Maryam_Waking/AnimationPlayer
@onready var cutscene_cam = $Maryam_Waking/Camera3D
@onready var player_cam = $Entities/Player/Head/Camera3D
@onready var transition = $Transitions/TransitionAnimation

func _ready() -> void:
	SettingsManager.in_game = true
	transition.use_transition()
	cutscene_cam.make_current()
	cutscene.play("maryam_waking")
	await cutscene.animation_finished
	await get_tree().create_timer(10.0).timeout
	player_cam.make_current()
	

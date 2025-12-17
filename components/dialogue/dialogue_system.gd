extends Control

class_name DialogueSystem

@export_category("Dialogue Settings")
@export_enum("Fairy", "Mother", "Son", "Unknown") var dialogue_speaker = "Unknown"
@export var display_speaker_title: bool = true
@export var dialogue: Label
@export var dialogue_title: Label
@export var diag_panel: Panel
@export var dialogue_player: AudioStreamPlayer
@export var character_appear_speed: float = 0.007
@export var wait_before_hide: float = 3.0

@export var remove_on_complete: bool = true

@export_category("Dialogue Sounds")
@export var enable_dialogue_sounds: bool = true
@export var default_sound_volume: float = -14.0
@export var dialogue_sounds: Array[AudioStream] = []
@export var dialogue_sound_speed: float = 0.10

@export_category("Debug")
@export var display_debug_dialogue: bool = false

var showing_text: bool = false
var displayed_text: bool = false

var confirmed: bool = false

const A_VOWEL = preload("uid://bp042lv5k35p2")
const E_VOWEL = preload("uid://de0bae8wfulis")
const I_VOWEL = preload("uid://by42kgsgkijwg")
const O_VOWEL = preload("uid://dph2550x0ualk")
const U_VOWEL = preload("uid://4t235s20m6g1")

const MOTHER_PITCH: float = 1.5
const FAIRY_PITCH: float = 1.0
const SON_PITCH: float = 0.8

var audio_pool: Array[AudioStreamWAV] = [A_VOWEL, E_VOWEL, I_VOWEL, O_VOWEL, U_VOWEL]
var vocal_pitch: float = 1.0

@onready var anim = $DialogueAnim

func _ready() -> void:
	if display_debug_dialogue:
		await get_tree().create_timer(2.0).timeout
		display_dialogue("This is a test dialogue, it should work :)")

	dialogue.text = ""

func display_dialogue(text: String) -> void:
	clear_dialogue()
	anim.play("appear")
	showing_text = true
	dialogue.text = text
	diag_panel.visible = true

	if display_speaker_title:
		if dialogue_title:
			dialogue_title.text = dialogue_speaker

	while showing_text:
		if dialogue.visible_ratio < 1.0:
			dialogue.visible_ratio += character_appear_speed
			play_speech_sound(vocal_pitch)
		if dialogue.visible_ratio >= 1.0:
			showing_text = false
		await get_tree().create_timer(0.01).timeout

	await get_tree().create_timer(wait_before_hide).timeout

	clear_dialogue()

func clear_dialogue() -> void:
	dialogue.visible_ratio = 0.0
	dialogue.text = ""
	diag_panel.visible = false

func play_speech_sound(pitch: float) -> void:
	if dialogue_player.is_playing():
		return

	var vowel = audio_pool.pick_random()
	dialogue_player.stream = vowel
	dialogue_player.pitch_scale = pitch
	dialogue_player.play()

func _process(_delta: float) -> void:
	match dialogue_speaker:
		"Mother":
			vocal_pitch = MOTHER_PITCH
		"Fairy":
			vocal_pitch = FAIRY_PITCH
		"Son":
			vocal_pitch = SON_PITCH

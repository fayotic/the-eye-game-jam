extends Node3D

@export var start_music_on_ready: bool = true

@export var play_button: BaseButton
@export var settings_button: BaseButton
@export var quit_button: BaseButton

const GAME_JAM_ARABIC = preload("uid://brcpthla38ufy")

func _ready() -> void:

	SettingsManager.in_game = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if play_button:
		play_button.pressed.connect(func(): _on_button_pressed())
	else:
		push_warning("Missing play button in export!")
	if settings_button:
		settings_button.pressed.connect(_call_settings)
	else:
		push_warning("Missing settings button in export!")
	if quit_button:
		quit_button.pressed.connect(_quit_game)
	else:
		push_warning("Missing quit button in export!")

	EventBus.menu_closed.connect(func(): $CanvasLayer/TextureRect.visible = true) #temporary

	if start_music_on_ready:
		AudioManager.play_sound_globally(GAME_JAM_ARABIC, "Music", "Title")

#When the Play Button is pressed, it goes to Level_0 scene (where the game starts)
func _on_button_pressed():
	
	var t = get_tree().create_tween()
	t.tween_property($CanvasLayer/TextureRect, "modulate:a", 0.0, 0.3)
	t.play()
	AudioManager.fade_out_group("Title", 3.0)
	LevelManager.change_scene("res://level0_and_testscenes/world.tscn")

func _call_settings() -> void:
	SettingsManager.display_settings_overlay(self)
	$CanvasLayer/TextureRect.visible = false

func _quit_game() -> void:
	SettingsManager.close_game()

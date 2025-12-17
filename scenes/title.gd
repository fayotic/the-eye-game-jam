extends Control

@export var play_button: BaseButton
@export var settings_button: BaseButton
@export var quit_button: BaseButton


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

	EventBus.menu_closed.connect(func(): $CanvasLayer/VBoxContainer.visible = true) #temporary

#When the Play Button is pressed, it goes to Level_0 scene (where the game starts)
func _on_button_pressed():
	get_tree().change_scene_to_file("res://components/cutscenes/maryam_waking.tscn")
	
	
func _call_settings() -> void:
	SettingsManager.display_settings_overlay(self)
	$CanvasLayer/VBoxContainer.visible = false

func _quit_game() -> void:
	SettingsManager.close_game()

extends CanvasLayer

@export var resume_button: BaseButton
@export var settings_button: BaseButton
@export var quit_button: BaseButton

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if resume_button:
		resume_button.pressed.connect(resume_game)

	if settings_button:
		settings_button.pressed.connect(settings)

	if quit_button:
		quit_button.pressed.connect(exit_game)

func resume_game() -> void:
	SettingsManager.pause_game()

func settings() -> void:
	SettingsManager.display_settings_overlay(get_tree().root)

func exit_game() -> void:
	SettingsManager.pause_game()
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func hide_pause(pause_menu: CanvasLayer, state) -> void:
	if pause_menu:
		pause_menu.visible = state

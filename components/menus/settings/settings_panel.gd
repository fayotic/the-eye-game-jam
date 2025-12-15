extends CanvasLayer

@export var window_mode: CheckBox

@export var master_slider: Slider
@export var sfx_slider: Slider
@export var music_slider: Slider

@export var close_button: BaseButton

var settings_manager: Node

var resolutions = [
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
	Vector2i(1152, 648)
]

func _ready() -> void:
	settings_manager = get_tree().get_first_node_in_group("SManager")
	if settings_manager == null:
		push_error("Settings Manager autoload not found in the tree. Make sure it's in group SManager")
	else:
		_load_toggle(window_mode, "fullscreen")
		_load_audio_sliders()
		_connect_signals()

	if OS.has_feature("web"):
		window_mode.disabled = true
		window_mode.visible = false


func _connect_signals() -> void:
	if window_mode:
		window_mode.toggled.connect(_on_fullscreen_selected)
	if master_slider:
		master_slider.value_changed.connect(_on_master_slider_changed)
	if sfx_slider:
		sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	if music_slider:
		music_slider.value_changed.connect(_on_music_slider_changed)

	if close_button:
		close_button.pressed.connect(func(): SettingsManager.save() ; EventBus.menu_closed.emit() ; call_deferred("queue_free"))


func _load_toggle(toggle: CheckBox, key: String) -> void:
	toggle.button_pressed = settings_manager.get_settings().get(key, false)


func _load_audio_sliders() -> void:
	var audio_sliders = settings_manager.get_all_volumes()
	master_slider.value = audio_sliders["Master"] * 100.0
	sfx_slider.value = audio_sliders["Sfx"] * 100.0
	music_slider.value = audio_sliders["Music"] * 100.0


func _on_fullscreen_selected(fullscreen: bool) -> void:
	if settings_manager.has_method("set_window_mode"):
		settings_manager.set_window_mode(fullscreen)


func _on_master_slider_changed(value: float) -> void:
	var new_value = value / 100
	if settings_manager.has_method("set_bus_volume"):
		settings_manager.set_bus_volume("Master", new_value)


func _on_sfx_slider_changed(value: float) -> void:
	var new_value = value / 100
	if settings_manager.has_method("set_bus_volume"):
		settings_manager.set_bus_volume("Sfx", new_value)


func _on_music_slider_changed(value: float) -> void:
	var new_value = value / 100
	if settings_manager.has_method("set_bus_volume"):
		settings_manager.set_bus_volume("Music", new_value)


func _on_option_button_item_selected(index: int) -> void:
	if index >= 0 and index < resolutions.size():
		var res = resolutions[index]
		DisplayServer.window_set_size(res)
		if settings_manager:
			settings_manager.window_resolution = res
			settings_manager.save()

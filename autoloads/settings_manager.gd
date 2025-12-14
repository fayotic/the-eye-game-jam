extends Node

var fullscreen: bool = false

var volumes: Dictionary = {
	"Master": 0.5,
	"Sfx": 0.5,
	"Music": 0.5,
}

const CFG: String = "user://settings.cfg"
const SEC_VIDEO: String = "Video"
const SEC_AUDIO: String = "Audio"
const SETTINGS = preload("res://components/menus/settings/settings_panel.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("SManager")
	_load()

	set_window_mode(fullscreen)

	for bus_name in volumes.keys():
		_apply_bus_volume(bus_name, volumes[bus_name])


## Creates and displays the settings overlay on a parent node
func display_settings_overlay(parent: Node) -> void:
	if parent:
		var s = SETTINGS.instantiate()
		parent.add_child(s)


## Sets window mode to either fullscreen or windowed
func set_window_mode(state: bool) -> void:
	fullscreen = state
	if fullscreen:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

	_save()


## Sets a bus volume, applies it, and saves
func set_bus_volume(bus: String, linear_value: float) -> void:
	volumes[bus] = clamp(linear_value, 0.0, 1.0)
	_apply_bus_volume(bus, volumes[bus])
	_save()


## Returns the current bus volume
func get_bus_volume(bus: String) -> float:
	return volumes.get(bus, 1.0)


## Returns a copy of all bus volumes
func get_all_volumes() -> Dictionary:
	return volumes.duplicate()


## Applies the volume to a bus
func _apply_bus_volume(bus: String, linear: float) -> void:
	var index = AudioServer.get_bus_index(bus)
	if index == -1:
		push_error("Audio bus '%s' not found." % bus)
		return

	if linear <= 0.0001:
		AudioServer.set_bus_volume_db(index, -80.0)
		AudioServer.set_bus_mute(index, true)
	else:
		AudioServer.set_bus_volume_db(index, linear_to_db(linear))
		AudioServer.set_bus_mute(index, false)


## Returns all current settings
func get_settings() -> Dictionary:
	return {
		"fullscreen": fullscreen,
		"volumes": get_all_volumes(),
	}


func _save() -> void:
	var c = ConfigFile.new()
	c.set_value(SEC_VIDEO, "fullscreen", fullscreen)

	for bus in volumes.keys():
		c.set_value(SEC_AUDIO, bus, volumes[bus])

	var err = c.save(CFG)
	if err != OK:
		push_error("Failed to save settings: %s" % str(err))

	print("Game Setting saved!")

func _load() -> void:
	var c = ConfigFile.new()
	if c.load(CFG) != OK:
		return

	fullscreen = bool(c.get_value(SEC_VIDEO, "fullscreen", fullscreen))

	for bus in ["Master", "Sfx", "Music"]:
		if c.has_section_key(SEC_AUDIO, bus):
			volumes[bus] = clamp(float(c.get_value(SEC_AUDIO, bus, 1.0)), 0.0, 1.0)


## Save and quit the game
func close_game() -> void:
	_save()
	get_tree().quit()

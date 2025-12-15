extends Node

#Can be used to control both Global Sound and 3D Space sound
#Avoids any audio being cut out like music or other things like that.

#If any of this makes you perish inside I apologize 🙏 I learn based on who I work with 😅
var default_db: float = -14.0 #I found -14.0 to be most comfortable, feel free to change it though
var music_on_start: bool = true
var stop_music_on_change: bool = true
var stop_sfx_on_change: bool = false

const MUSIC = preload("uid://brcpthla38ufy")

func _ready() -> void:
	if music_on_start:
		var music_instance = AudioStreamPlayer.new()
		music_instance.stream = MUSIC
		_send_to_root(music_instance)
		music_instance.call_deferred("play")
		music_instance.bus = "Music"
		music_instance.add_to_group("added_music")
		music_instance.finished.connect(func(): music_instance.play())

	EventBus.scene_changed.connect(func(): stop_all_sounds(stop_sfx_on_change, stop_music_on_change))


func play_sound_globally(sound: AudioStream, bus: String = "Sfx") -> void:
	var global_stream = AudioStreamPlayer.new()
	global_stream.stream = sound
	_send_to_root(global_stream)
	global_stream.volume_db = default_db
	global_stream.bus = bus
	global_stream.call_deferred("play")
	global_stream.finished.connect(func(): global_stream.queue_free())


func play_sound_at(sound: AudioStream, location: Vector3, bus: String = "Sfx") -> void:
	var local_stream = AudioStreamPlayer3D.new()
	local_stream.stream = sound
	_send_to_root(local_stream, location)
	local_stream.volume_db = default_db
	local_stream.bus = bus 
	local_stream.call_deferred("play")
	local_stream.finished.connect(func(): local_stream.queue_free())


#Adds the given node to tree, additionally a location can be provided for Node3D's
func _send_to_root(node: Node, location: Vector3 = Vector3.ZERO) -> void:
	get_tree().root.call_deferred("add_child", node)
	node.add_to_group("added")
	if node is Node3D:
		node.global_position = location


#Kills all audio sources based on arguments, either all sfx, all music(s) or both by default
func stop_all_sounds(stop_sfx: bool = true, stop_music: bool = true) -> void:
	if stop_sfx:
		for i in get_tree().get_nodes_in_group("added"):
			if i.is_inside_tree():
				i.queue_free()
	if stop_music:
		for m in get_tree().get_nodes_in_group("added_music"):
			if m.is_inside_tree():
				m.queue_free()

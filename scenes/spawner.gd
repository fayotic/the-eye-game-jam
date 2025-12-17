extends Marker3D

const Player = preload("res://components/player/player.tscn")

func _ready():
	spawn_player()

func spawn_player():
	var player_instance = Player.instantiate()
	add_child(player_instance)
	player_instance.position = global_position
	var camera = player_instance.get_node_or_null("Head/Camera3D")
	camera.make_current()
	

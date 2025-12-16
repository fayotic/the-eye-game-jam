extends Marker3D

const Player = preload("res://components/player/player.tscn")

func _ready():
	spawn_player()
	
func spawn_player():
	var player_instance = Player.instantiate()
	player_instance.position = global_position
	add_child(player_instance)
	

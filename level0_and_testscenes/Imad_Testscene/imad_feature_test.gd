extends Node3D

@onready var player = $Player
@onready var respawn_points = $RespawnPoints.get_children()
var current_respawn_point: Node3D 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_respawn_point = respawn_points[0]
	player.player_died.connect(_on_player_died)		
	pass
func _on_player_died():
	respawn_player()

func respawn_player():
	player.global_position = current_respawn_point.global_position
	player.health.health = player.health.max_health
	player.velocity = Vector3.ZERO
	player.health.is_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

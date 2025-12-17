extends CharacterBody3D

@onready var nav : NavigationAgent3D = $NavigationAgent3D
var target = CharacterBody3D
const SPEED = 3.0
const ACCEL = 2.0

func _ready():
	target = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	nav.target_position = target.global_position
	var next_position = nav.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
	move_and_slide()

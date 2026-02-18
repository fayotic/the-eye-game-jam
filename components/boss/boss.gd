extends CharacterBody3D

@export_enum("Ear", "Mouth", "Eye", "Null") var boss_type = "Null"
@export var attack_distance: float = 9.0


@export var model_offset_y: float = -0.6
const EAR_BOSS = preload("uid://cai38b4kx1iwf")
const EYE_BOSS = preload("uid://dny3esp0jllqw")
const MOUTH_BOSS = preload("uid://c5h518qkgm3wu")

@onready var nav : NavigationAgent3D = $NavigationAgent3D
var target: CharacterBody3D
const SPEED = 3.0
const ACCEL = 2.0

var body: Node3D

func _ready():
	initialize()

func initialize() -> void:
	await get_tree().process_frame
	set_body()

func play_animation() -> void:
	pass

func set_body() -> void:
	match boss_type:
		"Ear":
			body = EAR_BOSS.instantiate()
		"Mouth":
			body = MOUTH_BOSS.instantiate()
		"Eye":
			body = EYE_BOSS.instantiate()
		"Null":
			push_warning("No boss type selected. Please set one in the inspector of ", self)
			return

	add_child(body)
	body.position.y += model_offset_y
	if body:
		body.play_anim("idle")

func _process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		target = get_tree().get_first_node_in_group("Player")
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z))

func _physics_process(delta: float) -> void:
	if target:
		nav.target_position = target.global_position
		var next_position = nav.get_next_path_position()
		var direction = global_position.direction_to(next_position)
		var distance = (global_position - target.global_position).length()
		print("Distance: ", distance)
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
		if body and distance > attack_distance:
			body.play_anim("walk")
		elif body and distance <= attack_distance:
			velocity = Vector3.ZERO
			body.play_anim("attack")
		move_and_slide()

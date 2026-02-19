extends Camera3D

@export_category("Options")
@export var bob_speed: float = 2.0
@export var bob_amount: float = 0.04
@export var mouse_influences: bool = true
@export var mouse_influence_intensity: float = 1.7
@export var mouse_lag: float = 5.0  # higher = slower follow

var tick: float = 0.0
var base_position: Vector3
var base_rotation: Vector3
var target_rotation: Vector3

func _ready() -> void:
	base_position = position
	base_rotation = rotation
	target_rotation = base_rotation

func _process(delta: float) -> void:
	tick += delta * bob_speed
	position.y = base_position.y + sin(tick) * bob_amount

	if mouse_influences:
		var viewport_size = get_viewport().get_visible_rect().size
		var mouse_pos = get_viewport().get_mouse_position()
		var normalized = (mouse_pos / viewport_size) * 2.0 - Vector2.ONE

		target_rotation.x = base_rotation.x + (-normalized.y * mouse_influence_intensity * 0.01)
		target_rotation.y = base_rotation.y + (normalized.x * mouse_influence_intensity * 0.01)

	rotation.x = lerp(rotation.x, target_rotation.x, delta * mouse_lag)
	rotation.y = lerp(rotation.y, target_rotation.y, delta * mouse_lag)

extends Node3D
class_name PressableButton

@export var depress_amount: float = -0.08
@export var start_pressed: bool = false
@export var enabled: bool = true
@export var press_speed: float = 0.1
@export var unpressed_color: Color = Color.RED
@export var pressed_color: Color = Color.DIM_GRAY

@onready var base: CSGCylinder3D = $base
@onready var btn: MeshInstance3D = $base/btn

var material: StandardMaterial3D
var target_y: float
var pressing: bool = false

func _ready() -> void:
	initialize()

func initialize() -> void:
	_set_material()

	if start_pressed:
		btn.position.y += depress_amount
		material.albedo_color = pressed_color
	else:
		material.albedo_color = unpressed_color

	target_y = btn.position.y

func _set_material() -> void:

	material = StandardMaterial3D.new()
	material.emission_enabled = true

	if not start_pressed:
		material.emission = Color.RED
		material.emission_energy_multiplier = 7.0
	else:
		material.emission = Color.DIM_GRAY
		material.emission_energy_multiplier = 0.0

	btn.set_material_override(material)

func _process(_delta: float) -> void:
	if pressing:
		btn.position.y = lerp(btn.position.y, target_y, press_speed)
		if abs(btn.position.y - target_y) < 0.001:
			btn.position.y = target_y
			pressing = false


func press() -> void:
	if not enabled:
		return
	target_y = btn.position.y + depress_amount
	pressing = true
	material.albedo_color = pressed_color
	material.emission_energy_multiplier = 0.0


func unpress() -> void:
	target_y = btn.position.y - depress_amount
	pressing = true
	material.albedo_color = unpressed_color
	material.emission_energy_multiplier = 7.0

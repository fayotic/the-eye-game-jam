extends Node
class_name HealthComponent

signal health_changed(current: int, max: int)
signal died

@export var max_health: int = 100

var health: int
var is_dead: bool = false


func _ready() -> void:
	health = max_health
	emit_signal("health_changed", health, max_health)


func apply_damage(amount: int) -> void:
	if is_dead:
		return
	if amount <= 0:
		return

	health -= amount
	if health < 0:
		health = 0

	emit_signal("health_changed", health, max_health)

	if health == 0:
		_die()


func heal(amount: int) -> void:
	if is_dead:
		return
	if amount <= 0:
		return

	health += amount
	if health > max_health:
		health = max_health

	emit_signal("health_changed", health, max_health)


func _die() -> void:
	if is_dead:
		return

	is_dead = true
	emit_signal("died")

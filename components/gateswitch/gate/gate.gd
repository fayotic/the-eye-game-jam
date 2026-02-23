@tool
class_name Gate
extends Node3D

@export var material:Material:
	set(value):
		material = value
		_update_material()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_material()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open() -> void:
	print ("open gate")
	queue_free()
	pass

func _update_material():
	if not is_inside_tree():
		return
	
	if has_node("CSGBox3D"):
		$CSGBox3D.material = material

extends Node3D

@export var gates: Array[Gate] = []
var isClicked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if gates.is_empty():
		push_warning("No gates set. Set some in the inspector of ", self)
		return
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func interact() -> void:
	if(!isClicked):
		for gate in gates:
			gate.open()
		
		isClicked = true

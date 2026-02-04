extends Control

var isOpened = false

func _ready():
	close()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		if isOpened == true:
			close()
		else:
			open()
			
func open():
	visible = true
	isOpened = true
	
func close():
	visible = false
	isOpened = false
	

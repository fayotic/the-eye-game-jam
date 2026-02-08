extends CSGBox3D

@export var block_id: int = 0

func _ready() -> void:
	EventBus.event_channel_triggered.connect(activate)

func activate(id: int) -> void:
	if id == block_id:
		print("This works")
		queue_free()

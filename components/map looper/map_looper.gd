extends Node3D

var rooms = [
	preload("uid://c4s8vbkjxxqpw"),
	preload("uid://8bxi6os700kl"),
	preload("uid://dhmte4obd35yt")
]

var created_rooms = []

func _ready() -> void:
	await get_tree().process_frame
	EventBus.room_created.connect(create_room)

func create_room(rot: float, pos: Vector3) -> void:
	var room = rooms.pick_random().instantiate()
	created_rooms.append(room)
	add_child(room)
	room.global_rotation_degrees.y = rot
	room.global_position = pos

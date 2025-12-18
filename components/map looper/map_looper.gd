extends Node3D

@export var max_rooms_at_once: int = 2

@export var initial_room: Node3D
@export var remove_additional_nodes: Array[Node3D] = []

var rooms = [
	preload("uid://br7c3g0bpoi28"),
	preload("uid://8bxi6os700kl"),
	preload("uid://dhmte4obd35yt")
]

var created_rooms: Array[Node3D] = []

func _ready() -> void:
	await get_tree().process_frame
	EventBus.room_created.connect(create_room)

	#The current set up requires a starting room to create others so it requires an initial room
	if initial_room:
		created_rooms.append(initial_room)

#Creates a room with a given rotation and position, value recieved from EventBus.room_created
#And Eventbus.room created is called from the room script itself
func create_room(rot: float, pos: Vector3) -> void:
	var room = rooms.pick_random().instantiate()
	created_rooms.append(room)
	add_child(room)
	room.global_rotation_degrees.y = rot
	room.global_position = pos
	if created_rooms.size() > max_rooms_at_once: #If we're at the room limit, remove older ones.
		created_rooms[0].queue_free()
		created_rooms.remove_at(0)
	while remove_additional_nodes.size() > 0: #If there's anything we want to remove extra, remove.
		remove_additional_nodes[0].queue_free()
		remove_additional_nodes.remove_at(0)

#Adds a node to the list of nodes to be removed upon removal of a room
func add_exit_removals(object: Node) -> void:
	remove_additional_nodes.append(object)

#Removes a room from the remove_additional_nodes array to prevent it from being removed upon exit
func remove_exit_removals(object: Node) -> void:
	remove_additional_nodes.erase(object)

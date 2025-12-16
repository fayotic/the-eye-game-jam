extends Node3D

@export var center_pivot: Marker3D
@export var left_pivot: Marker3D
@export var right_pivot: Marker3D

#These get their respective area signals when touched and send one to the event bus
#For the MapLooper to take that info and create the appropriate room

func center_touched(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Center touch called.")
		if center_pivot:
			EventBus.room_created.emit(self.global_rotation_degrees.y + 0.0, center_pivot.global_position)
		else:
			push_warning("Center pivot missing!")


func left_touched(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Left touch called.")
		if left_pivot:
			EventBus.room_created.emit(self.global_rotation_degrees.y + 90.0, left_pivot.global_position)
		else:
			push_warning("Center pivot missing!")


func right_touched(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Right touch called.")
		if right_pivot:
			EventBus.room_created.emit(self.global_rotation_degrees.y - 90.0, right_pivot.global_position)
		else:
			push_warning("Center pivot missing!")

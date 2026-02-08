extends Area3D

class_name EventTrigger

#region Variables
@export_category("Parameters")
##Sets how the trigger should behave, Level loader will call a scene change with a given path.
##Parent interaction will call a function on the parent with a provided function name.
##Disable works similar to trigger_enabled = false, but works more as an in between doing nothing.
@export_enum("Level Loader", "Parent Interaction", "Disable") var handling_type = "Disable"

##Sets the trigger areas collision, this will be used to detect triggers.
@export var collision_zone: CollisionShape3D

@export var trigger_enabled: bool = true

##Any groups that this trigger should look for upon contact with a body.
##The group must be applied to the root body node (e.g. the Player),
##not the CollisionShape3D itself.
@export var search_for_groups: Array[String] = []

##Automatically finds the first CollisionShape3D and assigns it as the collison_zone if one is not assigned already.
@export var auto_assign_collision: bool = false

##If true, disables the trigger after it has been triggered once.
@export var disable_on_trigger: bool = true

##If Handling type is set to Parent Interaction, will call the function named [parent_function_name]
##on the parent_node, set parent_function_name in the inspector to the name of the function you want it
##to call in the parent_node's script. If not assigned and handling type is Parent Interaction, this will default to get_parent().
@export var parent_node: Node3D

##Sets the name of the function that will be called on the parent node script upon triggering.
@export var parent_function_name: String = "activate"

##Sets the path to be loaded on triggering. Must have handling_type set to "Level Loader".
##To get the path, right click the tscn in FileSystem and copy/paste the Path into here.
@export var load_level_path: String

@export_subgroup("Signals")
@export var emit_signal_on_trigger: bool = true
@export var signal_id: int = 0

@export_category("Debug")
@export var debug_prints: bool = false


#endregion

func _ready() -> void:
	if not collision_zone:
		if auto_assign_collision:
			for child in get_children():
				if child is CollisionShape3D:
					collision_zone = child
					if debug_prints:
						push_warning("Collision auto assigned to " + str(child) + ". If this is not intended, please assign manually.")
					break
		else:
			push_warning("No collision set, area: " + str(self) + " will not work.")
			return
	connect("body_entered", _check_trigger)

	if handling_type == "Parent Interaction":
		if !parent_node:
			parent_node = get_parent()


func _check_trigger(body: Node3D) -> void:
	if debug_prints:
		print("touched by, ", body, " :)")
	if not trigger_enabled:
		return
	if search_for_groups.is_empty():
		push_warning("There are no groups to search. Please add one in the Inspector")
		return
	for g in body.get_groups():
		if g in search_for_groups:
			if debug_prints:
				print("Group found, calling trigger.")
			_area_triggered()
			if disable_on_trigger:
				trigger_enabled = false
			return


func _area_triggered():
	if debug_prints:
		print("This area has been successfully triggered!")
	_handle_trigger()


func _handle_trigger() -> void:
	if handling_type == "Disable":
		return
	elif handling_type == "Parent Interaction":
		if parent_node:
			if parent_node.has_method(parent_function_name):
				parent_node.call(parent_function_name)
			else:
				push_warning(parent_node, " does not have a function callable: ", parent_function_name)
	elif handling_type == "Level Loader":
		if debug_prints:
			print("Call request for level change from SceneLoader script.")
		if load_level_path == null or load_level_path.is_empty():
			push_warning("No path was set in Inspector.")
			return
		if not ResourceLoader.exists(load_level_path):
			push_warning("Level path '" + load_level_path + "' does not exist!")
			return
		LevelManager.load_path(load_level_path)

	if emit_signal_on_trigger:
		EventBus.emit_signal("event_channel_triggered", signal_id)

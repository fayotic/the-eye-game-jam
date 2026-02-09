extends Node

#Will keep track of the players current checkpoint state when we add checkpoints for data saving.
#Determines where we should place the player later on, will tie it to a positional array
#based on last touched CheckpointTrigger node.
var checkpoint_state: int = 0

const TRANSITION_ANIMATION = preload("uid://ceq51lfn5telu")

var transition: SceneTransitioner

func _ready() -> void:
	transition = TRANSITION_ANIMATION.instantiate()
	add_child(transition)

func change_scene(path: String) -> void:

	if transition is SceneTransitioner:
		transition.change_scene(path)

func load_checkpoint() -> void:
	DataManager.setup_game()

func save_checkpoint() -> void:
	DataManager.save_game()

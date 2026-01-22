extends CharacterBody3D

const SPEED = 16.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001

@onready var head = $Head
@onready var camera = $Head/Camera3D
var is_equipped = false
@onready var sword = $Head/Camera3D/ArmColl/Sword
@onready var animation = $Head/Camera3D/ArmColl/Sword/AnimationPlayer
@export var lerp_speed = 10.0
@export var fairy_scene : Node3D



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("Player")

#Gets input from user to equip/unequip an item
func _process(delta: float) -> void:
	if Input.is_action_pressed("equip") and fairy_scene.scene_done == true : #e
		is_equipped = true
		equipSword()
	if Input.is_action_pressed("unequip"): #q
		is_equipped = false
		unequipSword()
	if Input.is_action_pressed("attack"): #left mouse
		animation.play("sword_swinging")
	
		
func equipSword():
	if is_equipped == true:
		sword.show() #Shows sword
		animation.play("sword_idle") #Plays idle animation
		
func unequipSword():
	if is_equipped == false:
		sword.hide() #Hides sword
	
func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

#Stops the player from moving
func stop_movement():
	set_physics_process(false)
#Allows player to move after being stopped	
func resume_movement():
	set_physics_process(true)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var direction = (head.transform * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

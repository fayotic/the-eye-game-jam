extends CharacterBody3D

const SPEED = 7.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001
const SPEED_MULTIPLIER = 3.8

@onready var head = $Head
@onready var camera = $Head/Camera3D
var is_equipped = false
@onready var sword = $Head/Camera3D/ArmColl/Sword
@onready var animation = $Head/Camera3D/ArmColl/Sword/AnimationPlayer
@export var lerp_speed = 10.0
@export var fairy_scene : Node3D
@export var inventory: InventorySystem
@onready var health: HealthComponent = $HealthComponentNode
@export var max_stamina := 100.0
@export var stamina := 100.0
@export var stamina_drain := 20.0   
@export var stamina_regen := 15.0
@onready var staminaUi = $StaminaUi
var exhausted: bool = false

signal player_died

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("Player")
	health.died.connect(_on_died)
	health.health_changed.connect(_on_health_changed)
	staminaUi.setProgressBarValue(max_stamina,true)
#Gets input from user to equip/unequip an item
func _process(delta: float) -> void:
	$CanvasLayer/BoxContainer/InteractText.hide()
	if %SeeCast.is_colliding():
		var target = %SeeCast.get_collider()
		if target.get_parent().has_method("interact") && !target.get_parent().isClicked:
			$CanvasLayer/BoxContainer/InteractText.show()
			if Input.is_action_just_pressed("equip"): #TODO: Change action name to interact
				target.get_parent().interact()
				return 
		else:
			$CanvasLayer/BoxContainer/InteractText.hide()

	if fairy_scene != null: #prevents crashes when fairy scene doesnt exist
		if Input.is_action_pressed("equip") and is_equipped == false and fairy_scene.scene_done == true : #e
			is_equipped = true
			equipSword()
		if Input.is_action_pressed("unequip") and fairy_scene.scene_done == true: #q
			is_equipped = false
			unequipSword()
		if Input.is_action_pressed("attack"): #left mouse
			animation.play("sword_swinging")
		
	
		
func equipSword():
	if is_equipped == true:
		sword.show() #Shows sword
		animation.play("sword_equip")
		await animation.animation_finished
		animation.play("sword_idle") #Plays idle animation
		
func unequipSword():
	if is_equipped == false:
		animation.play("sword_unequip")
		await animation.animation_finished
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
	var current_speed = SPEED
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_back", "move_front")

	# Make movement relative to the head/camera orientation
	var cam_basis = head.global_transform.basis
	var forward = -cam_basis.z
	forward.y = 0
	forward = forward.normalized()
	var right = cam_basis.x
	right.y = 0
	right = right.normalized()
	
	var direction = (forward * input_dir.y + right * input_dir.x).normalized()

	var is_sprinting = Input.is_action_pressed("sprint") and direction != Vector3.ZERO and is_on_floor()

	if is_sprinting and not exhausted:
		stamina -= stamina_drain * delta
	else:
		stamina += stamina_regen * delta

	stamina = clamp(stamina, 0.0, max_stamina)

	if stamina <= 0:
		exhausted = true

	if stamina >= max_stamina * 0.3:
		exhausted = false

	staminaUi.setProgressBarValue(stamina)
	
	if direction != Vector3.ZERO:
		if is_sprinting and not exhausted:
			current_speed *= SPEED_MULTIPLIER
			
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
	
func _on_died():
	print("Player dead"); #TODO: Play death animation
	player_died.emit()
	
	
func _on_health_changed(current, max_hp):
	print("Player HP:", current, "/", max_hp)
	

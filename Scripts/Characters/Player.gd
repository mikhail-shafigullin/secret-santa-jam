extends CharacterBody3D

const LERP_VALUE : float = 0.15

var snap_vector : Vector3 = Vector3.DOWN
var speed : float
var busy : bool = false

@export var is_new_movement : bool = true;

@export_group("Movement variables DEPRECATED")
@export var walk_speed : float = 2.0
@export var run_speed : float = 5.0
@export var jump_strength : float = 15.0
@export var gravity : float = 50.0

@export_group("Movement variables")
@export var planned_jump_height: float = 2.0
@export var planned_time_in_air: float = 0.3
@export var walk_speed_new : float = 2.0
@export var run_speed_new : float = 5.0
@export var is_double_jump_available : bool = true;
@export var time_block_jump_after_jumping: float = 0.05

var time_in_air: float = 0

var start_jump_velocity:float = (2 * planned_jump_height) / planned_time_in_air
var gravity_counted:float = (-2 * planned_jump_height) / (planned_time_in_air * planned_time_in_air)

enum PlayerState{
	STATE_ON_GROUND,
	STATE_IN_AIR
}
var currentState: PlayerState = PlayerState.STATE_ON_GROUND;

const ANIMATION_BLEND : float = 7.0

@onready var player_mesh : Node3D = $tim
@onready var spring_arm_pivot : Node3D = $SpringArmPivot
@onready var animator : AnimationTree = $AnimationTree
@onready var camera : Camera3D = $SpringArmPivot/SpringArm3D/Camera3D

func _ready():
	Global.player = self

func _physics_process(delta):
	if is_new_movement:
		physics_process_new(delta);
	else:
		physics_process_deprecated(delta);
		
func _process(delta):
	if is_new_movement:
		process_new(delta);
		
func _input(event):
	if currentState == PlayerState.STATE_ON_GROUND:
		handle_input_standing(event)
	elif currentState == PlayerState.STATE_IN_AIR:
		handle_input_jumping(event)
		
func process_new(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if currentState == PlayerState.STATE_ON_GROUND: 
		update_standing(delta)
	elif currentState == PlayerState.STATE_IN_AIR:
		update_in_air(delta)
	
	if Input.is_action_pressed("run"):
		speed = walk_speed
	else:
		speed = run_speed
		
	animate(delta)
	
	 
func physics_process_new(delta):
	var move_direction : Vector3 = Vector3.ZERO
	
	if not busy:
		move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		move_direction.z = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forwards")
		move_direction = move_direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
		
	
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	gravity = gravity_evaluate(velocity)
	velocity.y += gravity * delta
		
	if move_direction:
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(velocity.x, velocity.z), LERP_VALUE)
	
	apply_floor_snap()
	move_and_slide()
	

func gravity_evaluate(velocity : Vector3):
	if velocity.y <= 0: 
		return gravity_counted * 0.5;
	else: 
		return gravity_counted;
		
	
func handle_input_standing(input: InputEvent):
	if input.is_action_pressed("jump") and is_on_floor():
		#print('standing jump', is_double_jump_available)
		velocity.y = start_jump_velocity
		changeState(PlayerState.STATE_IN_AIR)
		is_double_jump_available = true
	
	
func handle_input_jumping(input: InputEvent):
	if input.is_action_pressed("jump") and is_double_jump_available and time_in_air > time_block_jump_after_jumping:
		#print('jumping jump', is_double_jump_available)
		is_double_jump_available = false;
		velocity.y = start_jump_velocity
		
func update_standing(delta):
	time_in_air = 0;
	is_double_jump_available = true;
	if !is_on_floor(): 
		changeState(PlayerState.STATE_IN_AIR)
	
func update_in_air(delta):
	time_in_air += delta;
	if time_in_air > time_block_jump_after_jumping:
		if is_on_floor(): 
			changeState(PlayerState.STATE_ON_GROUND)
			
func changeState(state: PlayerState):
	print('current state: ', state)
	currentState = state;
	
func physics_process_deprecated(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var move_direction : Vector3 = Vector3.ZERO
	if not busy:
		move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		move_direction.z = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forwards")
		move_direction = move_direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)

		var just_landed := is_on_floor() and snap_vector == Vector3.ZERO
		var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
		if is_jumping:
			velocity.y = jump_strength
			snap_vector = Vector3.ZERO
		elif just_landed:
			snap_vector = Vector3.DOWN
	
	velocity.y -= gravity * delta
	
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed
	
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	if move_direction:
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(velocity.x, velocity.z), LERP_VALUE)
	
	apply_floor_snap()
	move_and_slide()
	animate(delta)

func animate(delta):
	if is_on_floor():
		animator.set("parameters/ground_air_transition/transition_request", "grounded")
		
		if velocity.length() > 0:
			if speed == run_speed:
				animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), 1.0, delta * ANIMATION_BLEND))
			else:
				animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), 0.0, delta * ANIMATION_BLEND))
		else:
			animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), -1.0, delta * ANIMATION_BLEND))
	else:
		animator.set("parameters/ground_air_transition/transition_request", "air")

func set_busy(state: bool) -> void:
	busy = state
	$PlayerLayout/UseMessage/UseMessageText.visible = !busy
	if !busy:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		


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
@export var planned_jump_height: float = 2.5
@export var planned_time_in_air: float = 0.4
@export var walk_speed_new : float = 2.0
@export var run_speed_new : float = 5.0
@export var max_available_jumps : int = 2;
@export var time_block_jump_after_jumping: float = 0.05
@export var coyote_time: float = 0.2
@export var jump_buffer_time: float = 0.2

var time_in_air: float = 0
var jump_counter: int = 0;
var is_jump_pressed: bool = false;
var coyote_time_ended: bool = false;
var jump_buffer_timer: Timer = Timer.new();
var velocity_from_other_sources: Vector3 = Vector3.ZERO;
var velocity_viscosity: float = 0.1;

var mouse_moved_timer: Timer = Timer.new();
var mouse_moved_wait_time = 0.5;

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

@onready var dialogueBubble : Sprite3D = $UseObjectsController/bubbleSprite;

func _ready():
	Global.player = self
	add_child(jump_buffer_timer)
	jump_buffer_timer.wait_time = jump_buffer_time
	jump_buffer_timer.one_shot = true
	add_child(mouse_moved_timer)
	mouse_moved_timer.one_shot = true
	mouse_moved_timer.wait_time = mouse_moved_wait_time;
	
	set_busy(true)

func _physics_process(delta):
	physics_process_new(delta);
		
func _process(delta):
	process_new(delta);
		
func _input(event):
	if not busy:
		if currentState == PlayerState.STATE_ON_GROUND:
			handle_input_standing(event)
		elif currentState == PlayerState.STATE_IN_AIR:
			handle_input_jumping(event)
	
	if is_camera_moving_by_input(event):
		mouse_moved_timer.start();
		
func process_new(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_pressed("run"):
		speed = walk_speed
	else:
		speed = run_speed
		
	dialogueBubble.look_at(camera.global_position);
			
	animate(delta)
	
	 
func physics_process_new(delta):
	apply_floor_snap()
	var move_direction : Vector3 = Vector3.ZERO
	
	if not busy:
		move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		move_direction.z = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forwards")
		move_direction = move_direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
		
		if(mouse_moved_timer.is_stopped()):
			if not move_direction.is_zero_approx():
				if abs(sin(camera.global_rotation.y - player_mesh.global_rotation.y)) > 0.1:
					var global_quat = spring_arm_pivot.quaternion.slerp(Quaternion.from_euler(player_mesh.global_rotation), -0.5*delta);
					spring_arm_pivot.rotation = global_quat.get_euler();
					#spring_arm_pivot.rotate(Vector3.UP, move_direction.angle_to(spring_arm_pivot.position)*delta)
	
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	if currentState == PlayerState.STATE_ON_GROUND: 
		update_standing(delta)
	elif currentState == PlayerState.STATE_IN_AIR:
		update_in_air(delta)
	
	gravity = gravity_evaluate()
	velocity.y += gravity * delta
		
	if move_direction:
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(velocity.x, velocity.z), LERP_VALUE)

	
	move_and_slide()
	

func gravity_evaluate():
	if velocity.y <= 0: 
		return gravity_counted * 1.2;
	else: 
		return gravity_counted;
		
	
func handle_input_standing(input: InputEvent):
	if input.is_action_pressed("jump") and is_on_floor():
		changeState(PlayerState.STATE_IN_AIR)
		jump();
		jump_buffer_timer.start();
	
	
func handle_input_jumping(input: InputEvent):
	if (input.is_action_pressed("jump")):
		jump_buffer_timer.start();
		if (jump_counter <= max_available_jumps and time_in_air > time_block_jump_after_jumping):
			jump();
	
		
func update_standing(delta):
	time_in_air = 0;
	jump_counter = 0;
	is_jump_pressed = false;
	coyote_time_ended = false;
	velocity_from_other_sources = Vector3.ZERO;
	if !jump_buffer_timer.is_stopped():
		jump();
	if !is_on_floor(): 
		changeState(PlayerState.STATE_IN_AIR)
	
func update_in_air(delta):
	time_in_air += delta;
	velocity_from_other_sources -= velocity_viscosity * delta * velocity_from_other_sources;
	velocity += velocity_from_other_sources * 0.8
	if time_in_air > time_block_jump_after_jumping:
		if is_on_floor(): 
			changeState(PlayerState.STATE_ON_GROUND)
	if time_in_air > coyote_time and !coyote_time_ended and !is_jump_pressed:
		coyote_time_ended = true
		jump_counter+=1

func jump():
	is_jump_pressed = true;
	jump_counter+=1;
	velocity.y = start_jump_velocity
	velocity_from_other_sources = get_platform_velocity()

func changeState(state: PlayerState):
	#print('current state: ', state)
	currentState = state;

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

func is_camera_moving_by_input(event: InputEvent) -> bool:
	return (event.is_action("camera_down") or event.is_action("camera_up")
		or event.is_action("camera_left") or event.is_action("camera_right") or
		event is InputEventMouseMotion)

func set_busy(state: bool) -> void:
	busy = state
	$PlayerLayout/UseMessage/UseMessageText.visible = !busy
	if !busy:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		

func get_camera_ang_rad() -> float:
	var player_pos = Vector2(global_position.x, global_position.z)
	var camera_pos = Vector2(camera.global_position.x, camera.global_position.z)
	return camera_pos.angle_to_point(player_pos)

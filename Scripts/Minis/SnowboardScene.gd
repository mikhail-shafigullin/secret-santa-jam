class_name SnowboardScene
extends MiniGame

@onready var c = Global.cutscener
@onready var balanceSlider = %BalanceSlider;
@onready var speedText: RichTextLabel = %SpeedText;
@onready var speedInstructions: RichTextLabel = %SpeedInstructions;
@onready var exitButton: Button = %ExitButton;

@export var balance_acceleration = 200.0;
@export var movement_acceleration_on_press = 10.0;

var is_active: bool = true;

var balance_value = 50.0;
var normal_balance_value = 50.0;
var min_balance_value = 0.0;
var max_balance_value = 100.0;
var balance_velocity = 0;

var speed: float = 10.0;
var min_speed: float = 10.0;
var max_speed: float = 200.0;

var min_acceleration = 0.0;
var max_acceleration = 2.0;
var normal_acceleration = -0.2; 
var current_acceleration = 0;
var brake_acceleration = -0.6;

var rival_speed: float = 70.0;
var rival_acceleration:float = 0.2;

var is_left_balance: bool = false;
var is_right_balance: bool = false;
var current_railed_balance_acceleration: float = 0.0;

var speed_up = false;
var speed_down = false;

# VISUAL
@onready var mainScreen = Global.main_screen;

@export var racePathFollowStr = "SnowboardRacePathFollow"
@export var raceRivalPathFollowStr = "SnowboardRivalRacePathFollow"
@export var snowboardCameraStr = "SnowboardCamera"
@export var snowboardModelStr = "SnowboardModel"

var racePathFollow: PathFollow3D;
var rivalPathFollow: PathFollow3D;
var snowboardCamera: Camera3D;
var snowboardModel: Node3D;

var current_path_progress: float = 0.0;
var current_rival_path_progress: float = 0.0;
var visual_speed_koeff: float = 0.2;
var max_angle: float = PI/4;
var currentAngle: float = 0.0;
	
# Called when the node enters the scene tree for the first time.
func _ready():
	start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_balance(delta);
	process_speed(delta);
	process_rival_speed(delta);
	process_status(delta);
	process_visual(delta);
	
	
func process_balance(delta):
	if(is_left_balance):
		balance_velocity -= balance_acceleration * delta;
	if(is_right_balance):
		balance_velocity += balance_acceleration * delta;	
	calculate_railed_acceleration();
	balance_velocity += current_railed_balance_acceleration * delta;
	balance_value += balance_velocity * delta;
	balance_value = clampf(balance_value, 0.0, 100.0);
	
func process_speed(delta):
	var speed_resistance_koeff =(speed - min_speed) / (max_speed - min_speed);
	if(speed_up):
		current_acceleration = lerpf(max_acceleration, min_acceleration, speed_resistance_koeff)
		speed += current_acceleration;
	else:
		speed += normal_acceleration*speed_resistance_koeff;
		
	if(speed_down):
		speed += brake_acceleration;
		
	speed = clampf(speed, min_speed, max_speed);
	
func process_rival_speed(delta):
	rival_speed += rival_acceleration * delta;
	pass;

func process_visual(delta):
	if is_active:
		current_path_progress += delta * speed * visual_speed_koeff;
		racePathFollow.progress = current_path_progress;
		currentAngle = lerpf(-max_angle, max_angle, balance_value / max_balance_value);
		snowboardModel.rotation.z = currentAngle;
		
		current_rival_path_progress += delta * rival_speed * visual_speed_koeff;
		rivalPathFollow.progress = current_rival_path_progress;
		
		balanceSlider.value = balance_value;
		speedText.text = "[center]" + str(floorf(speed));
	else:
		snowboardModel.visible = false;
	
func process_status(delta):
	if(balance_value <= min_balance_value or balance_value >= max_balance_value):
		game_over();
	pass;
	
func _input(event):
	if event.is_action_pressed("move_left"):
		add_left_balance();
		
	if event.is_action_released("move_left"):
		remove_left_balance();
	
	if event.is_action_pressed("move_right"):
		add_right_balance();
	
	if event.is_action_released("move_right"):
		remove_right_balance();
		
	if event.is_action_pressed("move_forwards"):
		speed_up = true;
		
	if event.is_action_released("move_forwards"):
		speed_up = false;
		
	if event.is_action_pressed("move_backwards"):
		speed_down = true;
		
	if event.is_action_released("move_backwards"):
		speed_down = false;
	
func start() -> bool:
	if not c:
		return false
	Global.player.set_busy(true)
	Global.player.visible = false
	
	if not mainScreen: 
		return false;
	racePathFollow = mainScreen.find_child(racePathFollowStr, true, false)
	rivalPathFollow = mainScreen.find_child(raceRivalPathFollowStr, true, false)
	snowboardCamera = mainScreen.find_child(snowboardCameraStr,true, false);
	snowboardModel = mainScreen.find_child(snowboardModelStr,true, false);
	snowboardModel.visible = true;
	Global.player.camera.current = false
	snowboardCamera.current = true
	
	return true

func end() -> void:
	Global.player.visible = true
	Global.player.set_busy(false)
	Global.cutscener.end();
	queue_free()

func _on_exit_button_pressed():
	end();
	
func add_left_balance():
	is_left_balance = true;
	
func remove_left_balance():
	is_left_balance = false;
	
func add_right_balance():
	is_right_balance = true;
	
func remove_right_balance():
	is_right_balance = false;
	
func calculate_railed_acceleration():
	var balance_koeff = balance_value - normal_balance_value;
	current_railed_balance_acceleration = balance_koeff * (speed/50) + randf_range(-speed*5, speed*5);
	
func game_over():
	is_active = false;
	speedInstructions.visible = false
	speedText.text = "[center]You lose the race";
	exitButton.visible = true;
	

class_name SnowboardScene
extends MiniGame

@onready var c = Global.cutscener
@onready var balanceSlider = %BalanceSlider;
@onready var speedText:RichTextLabel = %SpeedText;

@export var balance_acceleration = 200.0;
@export var movement_acceleration_on_press = 10.0;

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

var is_left_balance: bool = false;
var is_right_balance: bool = false;
var current_railed_balance_acceleration: float = 0.0;

var speed_up = false;
var speed_down = false;
	
# Called when the node enters the scene tree for the first time.
func _ready():
	start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_balance(delta);
	process_speed(delta);
	
func process_balance(delta):
	if(is_left_balance):
		balance_velocity -= balance_acceleration * delta;
	if(is_right_balance):
		balance_velocity += balance_acceleration * delta;	
	calculate_railed_acceleration();
	balance_velocity += current_railed_balance_acceleration * delta;
	balance_value += balance_velocity * delta;
	balance_value = clampf(balance_value, 0.0, 100.0);
	
	balanceSlider.value = balance_value;
	
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
	
	speedText.text = "[center]" + str(floorf(speed));
	
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

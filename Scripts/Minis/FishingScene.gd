extends MiniGame

@onready var c = Global.cutscener
@onready var fishingSlider = %rodSlider;
@onready var fishSlider = %fishSlider;
@onready var fishSlider2 = %fishSlider2;
@onready var sucessSlider = %sucessSlider;
@onready var victoryControls = %victoryControls;

var slider_value: float = 0;
@export var slider_usual_acceleration: float = -240.0;
@export var slider_hold_acceleration: float = 240.0;
@export var slider_min_speed: float = -120.0;
@export var slider_hold_max_speed: float = 240.0;
@export var fish_slider_length = 30;

@export var success_slider_speed = 20;

var sliderValue = 0;
var current_slider_hold_speed: float = 0;
var is_slider_holded = false;

var fish_slider_value: float = 0;
var current_fish_slider_speed: float = 0;
var current_fish_time: float = 0;

var fish_easy_acceleration = {
	0.0: 10.0,
	1.5: 100.0,
	3.0: -100.0,
	4.5: -10.0
}
var next_fish_index: int = 0;
var current_fish_acceleration = 0.0

var sucessValue:float = 0.0
var is_sucess = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	start();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_slider(delta);
	process_slider_fish(delta);
	process_victory(delta)
	fishingSlider.value = sliderValue;
	fishSlider.value = fish_slider_value;
	fishSlider2.value = fish_slider_value + fish_slider_length;
	sucessSlider.value = sucessValue;
	if((fishingSlider.value == 0.0 or fishingSlider.value == 100.0) and !is_slider_holded):
		current_slider_hold_speed = 0.0;
	if((fishSlider.value == 0.0 or fishSlider2.value == 100.0)):
		current_fish_slider_speed = 0.0;


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
	pass;
	
func _input(event):
	if event.is_action_pressed('use'):
		is_slider_holded = true;
	if event.is_action_released('use'):
		is_slider_holded = false;
	
func process_slider(delta: float):
	if is_slider_holded:
		current_slider_hold_speed += slider_hold_acceleration*delta;
	else:
		current_slider_hold_speed += slider_usual_acceleration*delta;
	current_slider_hold_speed = clampf(current_slider_hold_speed, slider_min_speed, slider_hold_max_speed);
	
	sliderValue += (current_slider_hold_speed) * delta
	sliderValue = clampf(sliderValue, 0.0, 100.0);

func process_slider_fish(delta: float):
	current_fish_time += delta;
	if current_fish_time > fish_easy_acceleration.keys()[next_fish_index]:
		next_fish_index+= 1;
		if(next_fish_index == fish_easy_acceleration.size()):
			next_fish_index = 0;
			current_fish_time = 0;
		current_fish_acceleration = fish_easy_acceleration.values()[next_fish_index];
	
	current_fish_slider_speed += current_fish_acceleration*delta
	current_fish_slider_speed = clampf(current_fish_slider_speed, slider_min_speed, slider_hold_max_speed);
	fish_slider_value += current_fish_slider_speed * delta;
	current_fish_time += delta;
	
	fish_slider_value = clampf(fish_slider_value, 0.0, 100.0 - fish_slider_length);

func process_victory(delta: float):
	if sliderValue > fish_slider_value and sliderValue < fish_slider_value + fish_slider_length:
		sucessValue += success_slider_speed * delta;
	if(sucessValue > 100.0 and !is_sucess):
		is_sucess = true;
		show_sucess_screen();

func show_sucess_screen():
	victoryControls.visible = true;

func _on_button_pressed():
	end();

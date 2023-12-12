extends MiniGame

@onready var c = Global.cutscener

@onready var firstPartSection = %FirstPart;
@onready var bubblesText = %BubblesText;
@onready var instructionText = %InstructionText;

@onready var thirdPartSection = %ThirdPart;
@onready var fishingSlider = %rodSlider;
@onready var fishSlider = %fishSlider;
@onready var fishSlider2 = %fishSlider2;
@onready var fishScrollBar = %fishScrollBar;
@onready var sucessSlider = %sucessSlider;
@onready var victoryControls = %victoryControls;

@onready var gameOverSection = %GameOverPart;

var slider_value: float = 0;
@export var slider_usual_acceleration: float = -240.0;
@export var slider_hold_acceleration: float = 240.0;
@export var slider_min_speed: float = -120.0;
@export var slider_hold_max_speed: float = 240.0;
@export var fish_slider_length = 30;
@export var success_slider_speed = 20;
@export var success_failure_slider_speed = -10;

@export var min_fishing_time = 3.0
@export var max_fishing_time = 5.0
@export var failure_fishing_time = 2.0

var currentPart = 1;

@onready var firstPartTimer : Timer = Timer.new();
@onready var failureFirstPartTimer : Timer = Timer.new();

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
var sucessValue:float = 20.0
var is_sucess = false;

var current_fishing_time = INF

# VISUAL
@onready var mainScreen = Global.main_screen;

@export var fisherManNodeName = "fishermanMini";
var fisherman: Fisherman;

# Called when the node enters the scene tree for the first time.
func _ready():
	start();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentPart == 3: 
		process_slider(delta);
		process_slider_fish(delta);
		process_victory(delta)
		fishingSlider.value = sliderValue;
		fishSlider.value = fish_slider_value;
		fishSlider2.value = fish_slider_value + fish_slider_length;
		fishScrollBar.value = fish_slider_value;
		sucessSlider.value = sucessValue;
		if((fishingSlider.value == 0.0 or fishingSlider.value == 100.0) and !is_slider_holded):
			current_slider_hold_speed = 0.0;
		if((fishSlider.value == 0.0 or fishSlider2.value == 100.0)):
			current_fish_slider_speed = 0.0;


func start() -> bool:
	start_first_part();
	Global.cutscener.start("RESET")
	
	if not c:
		return false
	
	Global.player.set_busy(true)
	Global.player.visible = false
	
	if not mainScreen:
		return false;
		
	fisherman = mainScreen.find_child(fisherManNodeName, true, false)
	fisherman.mini_game_start();
	return true

func end() -> void:
	Global.player.visible = true
	Global.player.set_busy(false)
	Global.cutscener.end();
	fisherman.mini_game_stop();
	queue_free()
	
func _input(event):
	
	match currentPart:
		1:
			if event.is_action_pressed('use'):
				start_second_part()
		2:
			if event.is_action_pressed('use'):
				if !failureFirstPartTimer.is_stopped():
					start_third_part();
		3:
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
	else :
		sucessValue += success_failure_slider_speed * delta;
	if(sucessValue > 100.0 and !is_sucess):
		is_sucess = true;
		show_sucess_screen();
	if(sucessValue <= 0.0):
		start_game_over();

func start_first_part():
	currentPart = 1;
	instructionText.text = '[right]Press E to throw a rod';
	firstPartSection.visible = true;
	thirdPartSection.visible = false;
	#bubblesText.visible = false;
	
func start_second_part():
	currentPart = 2;
	instructionText.text = '[right]Press E when you feel pressure';
	#bubblesText.visible = true;
	current_fishing_time = randf_range(min_fishing_time, max_fishing_time)
	firstPartTimer.wait_time = current_fishing_time;
	firstPartTimer.one_shot = true;
	firstPartTimer.timeout.connect(start_bubbles_reaction_part)
	fisherman.mini_game_throw_rod();
	add_child(firstPartTimer)
	firstPartTimer.start();
	
func start_bubbles_reaction_part():
	#bubblesText.text = '[center]CATCH THE FISH!';
	failureFirstPartTimer.wait_time = failure_fishing_time
	failureFirstPartTimer.one_shot = true
	failureFirstPartTimer.timeout.connect(failure_in_second_part)
	fisherman.mini_game_fish_founded();
	add_child(failureFirstPartTimer)
	failureFirstPartTimer.start()
	pass
	
func start_third_part():
	currentPart = 3;
	failureFirstPartTimer.stop();
	firstPartSection.visible = false;
	thirdPartSection.visible = true;
	
func show_sucess_screen():
	fisherman.mini_game_fish_end();
	victoryControls.visible = true;
	
func failure_in_second_part():
	if currentPart != 3:
		start_game_over()
		currentPart = 0;
	pass;

func start_game_over():
	fisherman.mini_game_fish_end();
	gameOverSection.visible = true;

func _on_button_pressed():
	end();

func _on_exit_button_pressed():
	end();

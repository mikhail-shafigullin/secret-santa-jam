extends MiniGame

@onready var c = Global.cutscener

@export var balance_acceleration = 50.0;

var balance_value = 50;

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("move_left"):
		pass;
		
	if event.is_action_released("move_left"):
		pass;
	
	if event.is_action_pressed("move_right"):
		pass
	
	if event.is_action_released("move_right"):
		pass

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

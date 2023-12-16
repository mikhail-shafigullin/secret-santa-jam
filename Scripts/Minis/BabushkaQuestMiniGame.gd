extends MiniGame

@onready var mainScreen = Global.main_screen;
var babushka: Babushka;
var babushkaNodeName: String = "Babushka";

# Called when the node enters the scene tree for the first time.
func _ready():
	babushka = mainScreen.find_child(babushkaNodeName, true, false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start() -> bool:
	return true;

func end() -> void:
	Global.player.visible = true
	Global.player.set_busy(false)
	Global.cutscener.end();
	queue_free();


func _on_button_pressed():
	end();

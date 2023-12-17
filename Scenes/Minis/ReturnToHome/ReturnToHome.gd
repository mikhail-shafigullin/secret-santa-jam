extends MiniGame

var returnToHomeStr = "ReturnToHomeLocator";

var returnToHomeLocator : ReturnToHomeLocator;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start() -> bool:
	returnToHomeLocator = Global.main_screen.find_child(returnToHomeStr, true, false);
	returnToHomeLocator.turn_on_locator();
	return true

func end() -> void:
	pass

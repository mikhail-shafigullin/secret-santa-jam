extends MiniGame

@onready var c = Global.cutscener
@onready var fishingSlider = %fishingSlider;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start() -> bool:
	Global.player.set_busy(true)
	Global.player.visible = false
	
	return true

func end() -> void:
	Global.player.visible = true
	Global.player.set_busy(false)
	queue_free()
	pass;

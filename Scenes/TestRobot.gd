extends Node3D

const snowboard_mini = preload ("res://Scenes/Minis/Snowboard/SnowboardMini.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_usable_object_on_object_use():
	var mini = snowboard_mini.instantiate()
	var started = Global.main_screen.play_mini(mini)
	assert(started)

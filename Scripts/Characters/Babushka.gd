extends Node3D

const Balloon = preload("res://Scenes/Screens/my_balloon/my_balloon.tscn")

const dialogue = preload("res://Scenes/Characters/babushka.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_usable_object_on_object_use():
	assert(dialogue)
	Global.player.visible = false;
	if Global.player.busy:
		return
	var balloon: Node = Balloon.instantiate()
	Global.player.add_child(balloon)
	balloon.start(dialogue, "")

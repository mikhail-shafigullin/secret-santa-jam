extends Node3D

const Balloon = preload("res://Scenes/Screens/my_balloon/my_balloon.tscn")
const dialogue = preload("res://Scenes/Characters/snowboard.dialogue")

@onready var snowboardMesh = $snowboardMesh;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if snowboardMesh:
		snowboardMesh.rotate(Vector3.UP, PI * delta);
	pass

func _on_usable_object_on_object_use():
	assert(dialogue)
	if Global.player.busy:
		return
	var balloon: Node = Balloon.instantiate()
	Global.player.add_child(balloon)
	balloon.start(dialogue, "")

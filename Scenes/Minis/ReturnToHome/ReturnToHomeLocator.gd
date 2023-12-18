class_name ReturnToHomeLocator
extends Node3D

@onready var usableObject:UseableObject = $UsableObject;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	turn_off_locator();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func turn_on_locator(): 
	visible = true;
	usableObject.is_active = true;
	
func turn_off_locator(): 
	visible = false;
	usableObject.is_active = false;


func _on_usable_object_on_object_use():
#	Global.projector.start_dialogue("res://Scenes/UI/ending.dialogue");
	Global.main_screen.win()

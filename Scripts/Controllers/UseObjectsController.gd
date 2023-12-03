class_name UseObjectController
extends Node3D

var hoveredUsableObject: UseableObject;

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.useObjectController = self;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed('use'):
		useObject()

func hoverUsableObject(useableObject: UseableObject):
	hoveredUsableObject = useableObject;
	
func unhoverUsableObject():
	hoveredUsableObject = null;
	
func useObject():
	hoveredUsableObject.useObject()

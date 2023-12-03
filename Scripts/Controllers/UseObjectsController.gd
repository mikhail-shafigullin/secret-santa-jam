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
	Global.playerLayout.setTextOnUseMessage(useableObject.useObjectMessage);
	hoveredUsableObject = useableObject;
	
func unhoverUsableObject():
	Global.playerLayout.clearTextOnUseMessage();
	hoveredUsableObject = null;
	
func useObject():
	if(hoveredUsableObject): 
		hoveredUsableObject.useObject()

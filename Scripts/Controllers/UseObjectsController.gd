class_name UseObjectController
extends Node3D

var hoveredUsableObject: UseableObject;
const max_distance = 3 * 3

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.useObjectController = self;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hoveredUsableObject:
		var dist = (global_position - hoveredUsableObject.global_position).length_squared()
		if dist > max_distance:
			unhoverUsableObject()
	
func _input(event):
	if event.is_action_pressed('use'):
		if not Global.player.busy:
			useObject()

func hoverUsableObject(useableObject: UseableObject):
	Global.playerLayout.setTextOnUseMessage(useableObject.useObjectMessage);
	hoveredUsableObject = useableObject;
	
func unhoverUsableObject():
	Global.playerLayout.clearTextOnUseMessage();
	hoveredUsableObject = null;
	
func useObject():
	if (hoveredUsableObject):
		hoveredUsableObject.useObject()

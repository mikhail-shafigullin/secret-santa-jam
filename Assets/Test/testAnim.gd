extends Node3D
@onready var skel: Skeleton3D = $SizedTim/TrueSizeTim/Skeleton3D
# Called when the node enters the scene tree for the first time.
func _ready():
	_on_usable_object_on_object_use()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_usable_object_on_object_use():
	skel.physical_bones_start_simulation(["mixamorig_Neck","mixamorig_Spine","mixamorig_Spine1","mixamorig_Spine2","mixamorig_LeftShoulder","mixamorig_LeftArm","mixamorig_LeftForeArm","mixamorig_LeftHand","mixamorig_RightShoulder","mixamorig_RightArm","mixamorig_RightForeArm"])

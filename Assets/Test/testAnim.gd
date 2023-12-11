extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_usable_object_on_object_use():
	var skel: Skeleton3D = $SizedTim/TrueSizeTim/Skeleton3D
	skel.physical_bones_start_simulation()
	pass # Replace with function body.

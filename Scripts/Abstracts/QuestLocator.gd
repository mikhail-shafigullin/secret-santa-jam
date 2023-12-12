extends Node3D

@onready var cylinderMesh: MeshInstance3D = %LightCylinderMesh;

var scale_y = 50;
var free_space = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	#cylinderMesh.global_transform.origin = Vector3(0, 10, 0)
	cylinderMesh.set_scale(Vector3(1, scale_y, 1))
	cylinderMesh.set_position(Vector3(0, scale_y/2 + free_space, 0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

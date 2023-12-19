class_name QuestLocator
extends Node3D

@onready var cylinderMesh: MeshInstance3D = %LightCylinderMesh;
@export var compased = true

var scale_y = 50;
@export var free_space = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	#cylinderMesh.global_transform.origin = Vector3(0, 10, 0)
	cylinderMesh.set_scale(Vector3(1, scale_y, 1))
	cylinderMesh.set_position(Vector3(0, scale_y/2 + free_space, 0))
	
	Global.quest_list_show.connect(change_visibility)

func change_visibility(show):
	visible = show
	if compased:
		Global.quest_marker_update.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends Node3D

@export var state: BobState = BobState.T_POSE

@onready var animationPlayer = $bob/AnimationPlayer;

enum BobState {
	T_POSE,
	SNOWBOARDING
}


# Called when the node enters the scene tree for the first time.
func _ready():
	if(state == BobState.SNOWBOARDING):
		snowboarding()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func snowboarding():
	animationPlayer.play("bob_snowbording");

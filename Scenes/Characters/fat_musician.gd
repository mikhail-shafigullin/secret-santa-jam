extends Node3D
@onready var anim = $fat_mu/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_play(status: bool):
	if status:
		anim.play("fat_play")
	else:
		anim.play("fat_idle")

extends Node3D
@onready var anim = $thin_mu/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_play(status: bool):
	if status:
		anim.play("thin_play")
	else:
		anim.play("thin_idle")

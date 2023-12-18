extends MiniGame

@onready var poi = $Node3D/GamepoiCube001
@onready var loop = %Loop
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	poi.rotation.x = sin(time)*0.16
	poi.rotation.y = cos(time)*0.16
	poi.rotation.z = sin(time)*0.05



func _on_loop_win():
	loop.queue_free()
	%win.visible = true


func _on_area_2d_body_entered(body):
	_on_loop_win()

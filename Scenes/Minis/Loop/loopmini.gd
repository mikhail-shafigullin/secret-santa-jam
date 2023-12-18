extends MiniGame

@onready var poi = $Node3D/GamepoiCube001
@onready var loop = %Loop
var time: float = 0

@onready var mat: Material = load("res://Scenes/Minis/Loop/loop.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	mat.set("albedo_texture", %win.get_viewport().get_texture())
	poi.set_surface_override_material(1, mat)


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

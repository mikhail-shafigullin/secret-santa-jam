extends StaticBody3D

var meshes: Array[Node] = []
var timer: Timer
func _ready():
	var light_root = $Lights
	if light_root:
		timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", update)
		timer.wait_time = randi_range(20, 500)
		timer.one_shot = false
		timer.start()
		meshes = light_root.get_children()
		for mesh in meshes:
			mesh.visible = (0.8 < randf())
	
func update():
	for mesh in meshes:
		if 0.9 < randf():
			mesh.visible = !mesh.visible

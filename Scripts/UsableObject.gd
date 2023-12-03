extends Node3D

signal on_use_area_entered(body: Node3D);
signal on_object_use();

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_e_use_area_event_body_entered(body):
	print('AreaEntered');
	on_use_area_entered.emit(body);
	pass # Replace with function body.

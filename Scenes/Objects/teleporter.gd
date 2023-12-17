extends Area3D

@onready var target = $Marker3D

func _on_body_entered(body):
	if (body == Global.player):
		Global.player.global_position = target.global_position

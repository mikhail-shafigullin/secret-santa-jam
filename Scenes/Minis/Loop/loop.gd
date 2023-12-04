extends Control



func _on_area_2d_body_entered(body):
	if body == $SubViewportContainer/SubViewport/loop/CharacterBody2D:
		$win.visible = true

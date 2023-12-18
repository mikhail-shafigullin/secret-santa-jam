extends Control

signal win()


func _on_area_2d_body_entered(body):
	%win.visible = true
	win.emit()

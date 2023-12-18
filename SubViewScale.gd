extends SubViewportContainer

func _ready():
	get_viewport().connect("size_changed", on_resize)
	fit()
	
func on_resize():
	fit()

func fit():
	var scaler = Vector2(get_viewport().size) / size
	pivot_offset = size / 2
	if scaler.y < scaler.x:
		scale = Vector2(scaler.y, scaler.y)
	else:
		scale = Vector2(scaler.x, scaler.x)
		

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if not event.pressed:
			if Global.player != null:
				if not Global.player.busy:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


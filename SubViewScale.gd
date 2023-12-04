extends SubViewportContainer

func _ready():
	get_viewport().connect("size_changed", on_resize)
	fit()
	
func on_resize():
	fit()

func fit():
	var scaler = get_viewport().size.y / size.y
	pivot_offset = size/2
	scale = Vector2(scaler, scaler)

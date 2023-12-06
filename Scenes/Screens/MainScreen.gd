extends Control



func _on_capture_mouse_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_full_screen_pressed():
	var vpw = get_viewport().get_window()
	if vpw.mode == Window.MODE_FULLSCREEN:
		vpw.mode = Window.MODE_WINDOWED
	else:
		vpw.mode = Window.MODE_FULLSCREEN

extends Control


func _on_full_screen_pressed():
	var vpw = get_viewport().get_window()
	if vpw.mode == Window.MODE_FULLSCREEN:
		vpw.mode = Window.MODE_WINDOWED
	else:
		vpw.mode = Window.MODE_FULLSCREEN

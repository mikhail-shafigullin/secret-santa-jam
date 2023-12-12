extends AnimatedSprite2D



func hit():
	var timer = Timer.new()
	timer.autostart = false
	timer.connect("timeout", clear)
	add_child(timer)
	timer.start(0.15)
	
	play("tap")

func clear():
	queue_free()

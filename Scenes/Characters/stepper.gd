extends AudioStreamPlayer3D

func step():
	stop()
	if Global.player.speed >= 5.0 and Global.player.is_on_floor():
		pitch_scale = randf_range(.8, 1.2)
		play()

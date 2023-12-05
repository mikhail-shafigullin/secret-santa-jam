class_name Cutscener
extends AnimationPlayer

@onready var camera = $Camera

var _auto_stop

func _ready():
	Global.cutscener = self
	connect("animation_finished", finished)

func start(name: String, auto_stop: bool = false):
	_auto_stop = auto_stop
	Global.player.camera.current = false
	camera.current = true
	play(name)

func end():
	Global.player.camera.current = true
	camera.current = false
	
func finished(name: String):
	if _auto_stop:
		end()

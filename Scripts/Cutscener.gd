class_name Cutscener
extends AnimationPlayer

@onready var camera = $Camera

var _auto_stop: bool = false

func _ready():
	Global.cutscener = self
	connect("animation_finished", finished)

func start(name: String, auto_stop: bool=false):
	_auto_stop = auto_stop
	camera.current = true
	Global.player.camera.current = false
	play(name)

func end():
	play("RESET")
	Global.player.camera.current = true
	camera.current = false
	
func finished(name: String):
	if _auto_stop:
		end()

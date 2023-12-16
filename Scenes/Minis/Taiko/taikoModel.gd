extends Node3D
signal mini_started
signal mini_ended

const taiko_mini = preload ("res://Scenes/Minis/Taiko/taiko.tscn")

@onready var pon = $Pon
@onready var kat = $Kat
@onready var tim = $TimDoppelganger
@onready var music = $baseMusic

func _on_usable_object_on_object_use():
	var _mini = taiko_mini.instantiate()
	_mini.model = self
	_mini.tim = tim
	var started = Global.main_screen.play_mini(_mini)

	assert(started)
	
	tim.show_drum_sticks()
	tim.visible=true
	tim.taiko_tree.active=true

	Global.audioStreamPlayer.stop();
	Global.player.set_busy(true)
	Global.player.visible=false
	
	music.play()

	print("started taiko ", started)

	mini_started.emit()
	
func _ready():
	tim.visible = false
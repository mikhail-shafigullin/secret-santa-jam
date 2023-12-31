class_name TaikoModel
extends Node3D
signal mini_started
signal mini_ended

const taiko_mini = preload ("res://Scenes/Minis/Taiko/taiko.tscn")
var is_taiko_victory: bool = false;

@onready var pon = $Pon
@onready var kat = $Kat
@onready var tim = $TimDoppelganger
@onready var music = $baseMusic

func _on_usable_object_on_object_use():
	var started = Global.main_screen.play_mini(Global.taikoMiniGame)

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
	


func start_song():
	tim.show_drum_sticks()
	tim.visible=true
	tim.taiko_tree.active=true

	Global.audioStreamPlayer.stop();
	Global.player.set_busy(true)
	Global.player.visible=false
	
	music.play()

	mini_started.emit()
	
func victory():
	is_taiko_victory = true;
	pass;

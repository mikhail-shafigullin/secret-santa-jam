extends Node3D

@onready var cutscener: Cutscener = %Cutscener
@onready var taiko_model = $taikoModel

const band_dialogue = preload("res://Scenes/Objects/other/Band/BandDialogue.dialogue")

func _ready():
	assert(cutscener)
	assert(band_dialogue)
	assert(cutscener.has_animation("taiko_start"))
	assert(cutscener.has_animation("taiko_rest"))
	
	taiko_model.connect("mini_started", on_taiko_started)
	taiko_model.connect("mini_ended", on_taiko_ended)


func on_taiko_started():
	print("start")
	#$AnimationPlayer/Camera3D.current = true

func on_taiko_ended():
	print("end")
	taiko_model.music.stop()
	
	Global.audioStreamPlayer.play();

	Global.player.visible=true
	Global.player.set_busy(false)
	Global.cutscener.end()
	#$AnimationPlayer/Camera3D.current = false

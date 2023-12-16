extends Node3D

@onready var taiko_model = $taikoModel

const Balloon = preload("res://Scenes/Screens/my_balloon/my_balloon.tscn")
const dialogue = preload("res://Scenes/Characters/band.dialogue")

@onready var animationPlayer = %AnimationPlayer;

@onready var camera = %Camera;

var animationNames = ['band_playing_01', 'band_playing_02', 'band_playing_03', 'band_playing_04']
var nextAnimation = 'band_playing_01';
var nextIndex = 0;

func _ready():	
	taiko_model.connect("mini_started", on_taiko_started)
	taiko_model.connect("mini_ended", on_taiko_ended)

func on_taiko_started():
	print("start")
	camera.current = true
	animationPlayer.connect("animation_finished",animation_play);
	animation_play();

func on_taiko_ended():
	print("end")
	taiko_model.music.stop()
	
	Global.audioStreamPlayer.play();

	Global.player.visible=true
	Global.player.set_busy(false)
	Global.cutscener.end()
	camera.current = false

func _on_usable_object_on_object_use():
	assert(dialogue)
	Global.player.visible = false;
	if Global.player.busy:
		return
	var balloon: Node = Balloon.instantiate()
	Global.player.add_child(balloon)
	balloon.start(dialogue, "")

func animation_play(_name: String=""):
	animationPlayer.play(nextAnimation);
	nextIndex = nextIndex + 1;
	if(nextIndex >= animationNames.size()):
		nextIndex = 0;
	nextAnimation = animationNames[nextIndex];
	#animationPlayer.disconnect("animation_finished", animation_play);
	

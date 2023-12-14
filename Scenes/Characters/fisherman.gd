class_name Fisherman
extends Node3D

const Balloon = preload("res://addons/dialogue_manager/example_balloon/example_balloon.tscn")

const dialogue = preload("res://Scenes/Characters/fisherman.dialogue")

@onready var timModel: TimDoppelganger = %TimDoppelganger;
@onready var fishermanAnimationPlayer: AnimationPlayer = $AnimationPlayer;
@onready var timAnimationPlayer: AnimationPlayer = $TimDoppelganger/tim/AnimationPlayer;
@onready var camera: Camera3D = %MiniGameCamera;

func set_animation_talking():
	fishermanAnimationPlayer.play("Speak");
	
func set_animation_idle():
	fishermanAnimationPlayer.play("FishingIdle")

func set_animation_stand():
	fishermanAnimationPlayer.play("stand")
	
func mini_game_start():
	timModel.visible = true;
	timAnimationPlayer.play("fishing_start_idle");
	fishermanAnimationPlayer.play("stand")
	camera.current = true;
	Global.player.camera.current = false;
	
func mini_game_throw_rod():
	timAnimationPlayer.play("fishing_start");
	timAnimationPlayer.queue("fishing_idle");
	
func mini_game_fish_founded():
	timAnimationPlayer.play("fishing_catch_start");
	timAnimationPlayer.queue("fishing_catch_fight");
	
func mini_game_fish_end():
	timAnimationPlayer.play("fishing_catch_finish");

func mini_game_stop():
	timModel.visible = false;
	camera.current = false;
	Global.player.camera.current = true;
	
func start_victory_dialogue():
	Global.player.visible = false;
	timModel.visible = false;
	var balloon: Node = Balloon.instantiate()
	Global.player.add_child(balloon)
	balloon.start(dialogue, "victory");
	pass;
	
func start_failure_dialogue():
	pass;

func _on_usable_object_on_object_use():
	assert(dialogue)
	Global.player.visible = false;
	if Global.player.busy:
		return
	var balloon: Node = Balloon.instantiate()
	Global.player.add_child(balloon)
	balloon.start(dialogue, "")
	

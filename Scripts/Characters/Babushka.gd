class_name Babushka
extends Node3D

const Balloon = preload("res://Scenes/Screens/my_balloon/my_balloon.tscn")

const dialogue = preload("res://Scenes/Characters/babushka.dialogue")

@onready var animationPlayer = $AnimationPlayer;

@onready var tim = %TimDoppelganger;
@onready var marker_in_front_of_babushka = %MarkerInFrontOfBabushka;

signal on_start_quest;
signal on_victory_quest;
signal on_failure_quest;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_quest():
	on_start_quest.emit();
	remove_animation_talking();
	tim.visible = false;

func victory_quest():
	$QuestLocator.compased = false
	on_victory_quest.emit();
	Global.player.global_position = marker_in_front_of_babushka.global_position
	var balloon: Node = Balloon.instantiate()
	Global.player.add_child(balloon)
	balloon.start(dialogue, "victory")
	
func set_animation_talking():
	animationPlayer.play("talking");
	
func remove_animation_talking():
	animationPlayer.play("RESET")

func _on_usable_object_on_object_use():
	assert(dialogue)
	Global.player.visible = false;
	if Global.player.busy:
		return
	var balloon: Node = Balloon.instantiate()
	Global.player.add_child(balloon)
	balloon.start(dialogue, "")

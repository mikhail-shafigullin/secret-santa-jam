class_name TimDoppelganger
extends Node3D

@onready var tim = $tim
@onready var tim_anim = $tim/AnimationPlayer
@onready var taiko_tree = $TaikoTree

@onready var hand_left = %LeftHand
@onready var hand_right = %RightHand

@onready var rod = %Rod
@onready var drum_l = %DrumL
@onready var drum_r = %DrumR

@export var inHands: InHandsEnum = InHandsEnum.EMPTY

enum InHandsEnum {
	EMPTY,
	ROD,
	DRUMS,
}

func _ready():
	match inHands:
		InHandsEnum.EMPTY: 
			empty_hand();
		InHandsEnum.ROD:
			show_rod();
		InHandsEnum.DRUMS:
			show_drum_sticks();
			

func empty_hand():
	for node in hand_left.get_children():
		node.visible = false
	for node in hand_right.get_children():
		node.visible = false

func show_drum_sticks():
	empty_hand()
	drum_l.visible = true
	drum_r.visible = true

func show_rod():
	empty_hand()
	rod.visible = true

extends Node3D

const Balloon = preload("res://addons/dialogue_manager/example_balloon/example_balloon.tscn")

@export var dialoge: DialogueResource

func _on_usable_object_on_object_use():
	assert(dialoge)
	var balloon: Node = Balloon.instantiate()
	Global.player.add_child(balloon)
	balloon.start(dialoge, "")

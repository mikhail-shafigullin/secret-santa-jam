extends Node3D

const taiko_mini = preload("res://Scenes/Minis/Taiko/taiko.tscn")

func _on_usable_object_on_object_use():
    var started = Global.main_screen.play_mini(taiko_mini)
    assert(started)

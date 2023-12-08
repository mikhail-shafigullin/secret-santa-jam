extends Node3D

const taiko_mini = preload ("res://Scenes/Minis/Taiko/taiko.tscn")

@onready var pon = $Pon
@onready var kat = $Kat

func _on_usable_object_on_object_use():
    var mini = taiko_mini.instantiate()
    mini.model = self
    var started = Global.main_screen.play_mini(mini)
    print("started taiko", started)
    assert(started)
    

class_name MainScreen
extends Control

const world_res = preload("res://Scenes/Levels/world.tscn");

var primary_screen: Node
var mini_game: MiniGame

@onready var root= $Control/SubViewScale/SubViewport

func _on_full_screen_pressed():
	var vpw = get_viewport().get_window()
	if vpw.mode == Window.MODE_FULLSCREEN:
		vpw.mode = Window.MODE_WINDOWED
	else:
		vpw.mode = Window.MODE_FULLSCREEN

func _ready():
	Global.main_screen = self;

	for node: Node in root.get_children():
		node.queue_free()
	
	primary_screen = world_res.instantiate()
	root.add_child(primary_screen)
	
func play_mini(mini_res: Resource) -> bool:
	var game = mini_res.instantiate()
	if not game is MiniGame:
		return false 
	
	if mini_game != null:
		mini_game.queue_free()
	
	mini_game = game
	root.add_child(game)
	game.start()
	
	return true

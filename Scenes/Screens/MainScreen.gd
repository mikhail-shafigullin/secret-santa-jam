class_name MainScreen
extends Control

const world_res = preload ("res://Scenes/Levels/world.tscn");
const fishing_mini = preload ("res://Scenes/Minis/Fishing/FishingMini.tscn")
const snowboard_mini = preload ("res://Scenes/Minis/Snowboard/SnowboardMini.tscn")
const babushka_mini = preload ("res://Scenes/Minis/Babushka/BabushkaQuestMiniGame.tscn")

const questListUI = preload ("res://Scenes/UI/QuestListUI.tscn")

const minis = {
	"fishing": fishing_mini,
	"snowboard": snowboard_mini,
	"babushka": babushka_mini
}

var primary_screen: Node
var mini_game: MiniGame

@onready var root = $Control/SubViewScale/SubViewport
@onready var volume_slider = $Control/MouseBlock/Volume/VSlider
@onready var volume_button = $Control/MouseBlock/Volume
@onready var audioStreamPlayer = %AudioStreamPlayer;

func _on_full_screen_pressed():
	var vpw = get_viewport().get_window()
	if vpw.mode == Window.MODE_FULLSCREEN:
		vpw.mode = Window.MODE_WINDOWED
	else:
		vpw.mode = Window.MODE_FULLSCREEN

func _ready():
	Global.main_screen = self;
	volume_slider.visible = false;

	for node: Node in root.get_children():
		node.queue_free()
	
	primary_screen = world_res.instantiate()
	root.add_child(primary_screen)
	Global.audioStreamPlayer = audioStreamPlayer;
	Global.audioStreamPlayer.play()
	
	var quest_list_instance = questListUI.instantiate();
	root.add_child(quest_list_instance);
	Global.questListUI = quest_list_instance;
	
	
func play_mini(mini: MiniGame) -> bool:
	if mini_game != null:
		mini_game.queue_free()
	
	mini_game = mini
	root.add_child(mini)
	return mini.start()
	
func play_mini_by_name(miniName: String) -> bool:
	if mini_game != null:
		mini_game.queue_free()
	
	mini_game = minis.get(miniName).instantiate();
	root.add_child(mini_game)
	return mini_game.start()

func _on_volume_toggled(toggled_on: bool):
	volume_slider.visible = toggled_on

func _on_v_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(0, lerp(-80, 16, value))

func _on_v_slider_focus_exited():
	volume_button.button_pressed = false
	volume_slider.visible = false

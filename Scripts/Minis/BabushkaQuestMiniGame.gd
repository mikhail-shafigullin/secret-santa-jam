class_name BabushkaQuestMiniGame
extends MiniGame

@onready var mainScreen = Global.main_screen;
var babushka: Babushka;
var babushkaNodeName: String = "Babushka";

var currentQuestPointFinished = 0;
var countQuestPoints = 4;


# Called when the node enters the scene tree for the first time.
func _ready():
	babushka = mainScreen.find_child(babushkaNodeName, true, false)
	Global.babushkaMiniGame = self;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start() -> bool:
	babushka.start_quest();
	Global.cutscener.start("RESET")
	Global.player.visible = true
	Global.cutscener.end()
	Global.player.set_busy(false)
	babushka.tim.visible = false;
	return true;

func end() -> void:
	Global.player.visible = true
	Global.player.set_busy(false)
	Global.cutscener.end();
	queue_free();

func _on_button_pressed():
	end();

func resolveQuestPoint():
	currentQuestPointFinished += 1;
	if(currentQuestPointFinished >= countQuestPoints):
		victory();

func victory():
	Global.levelModify.allHomeDecorationVisible(true);
	Global.questListUI.finishBabushkaQuest();
	get_tree().create_timer(0.1).connect("timeout", queue_free)
	babushka.victory_quest();

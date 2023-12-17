extends Node3D

@onready var usableObject = %UsableObject;
@onready var mesh = %MeshInstance3D;

@onready var mainScreen = Global.main_screen;
var babushkaMiniGame;
var babushka: Babushka;
var babushkaNodeName: String = "Babushka";

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh.visible = true;
	babushka = mainScreen.find_child(babushkaNodeName, true, false)
	babushka.on_start_quest.connect(start_quest_point)
	babushka.on_victory_quest.connect(victory_quest_point)
	usableObject.is_active = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_quest_point():
	babushkaMiniGame = Global.babushkaMiniGame;
	visible = true;
	usableObject.is_active = true;
	
func victory_quest_point():
	visible = false;
	usableObject.is_active = false;

func _on_usable_object_on_object_use():
	visible = false;
	usableObject.is_active = false;
	babushkaMiniGame.resolveQuestPoint();
	
	pass;

class_name QuestListUI
extends Control

@onready var fishermanQuest: RichTextLabel = %FishermanQuest;
@onready var babushkaQuest: RichTextLabel = %BabushkaQuest;
@onready var showboardQuest: RichTextLabel = %SnowboardQuest;
@onready var taikoQuest: RichTextLabel = %TaikoQuest;

var isFishermanQuestFinished = false;
var isBabushkaQuestFinished = false;
var isSnowboardQuestFinished = false;
var isTaikoQuestFinished = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Global.player and !Global.player.busy):
		visible = true;
	else:
		visible = false;
	pass


func finishFishermanQuest():
	fishermanQuest.text = "[right][s]Help fisherman";
	isFishermanQuestFinished = true;
	checkAllQuestsFinished();
	
func finishBabushkaQuest():
	babushkaQuest.text = "[right][s]Help your neighbour";
	isBabushkaQuestFinished = true;
	checkAllQuestsFinished();

func finishSnowboardQuest():
	showboardQuest.text = "[right][s]Challenge with Bob";
	isSnowboardQuestFinished = true;
	checkAllQuestsFinished();
	
func finishTaikoQuest():
	taikoQuest.text = "[right][s]Help a band";
	isTaikoQuestFinished = true;
	checkAllQuestsFinished();
	
func checkAllQuestsFinished():
	if(isFishermanQuestFinished and isBabushkaQuestFinished and isSnowboardQuestFinished and isTaikoQuestFinished):
		end_game();

func end_game():
	pass;

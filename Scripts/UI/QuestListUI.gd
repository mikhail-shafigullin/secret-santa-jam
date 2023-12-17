class_name QuestListUI
extends Control

@onready var fishermanQuest: RichTextLabel = %FishermanQuest;
@onready var babushkaQuest: RichTextLabel = %BabushkaQuest;
@onready var showboardQuest: RichTextLabel = %SnowboardQuest;
@onready var taikoQuest: RichTextLabel = %TaikoQuest;
@onready var returnToHomeQuest: RichTextLabel = %ReturnToHomeQuest;

@onready var animationPlayer: AnimationPlayer = %AnimationPlayer;

const dim := Color(Color.WHEAT, 0.35)

var isFishermanQuestFinished = false;
var isBabushkaQuestFinished = false;
var isSnowboardQuestFinished = false;
var isTaikoQuestFinished = false;

var is_opened = false;

func _input(event):
	if(event.is_action_pressed("quest")):
		toggleQuests()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.quest_list_show.emit(is_opened)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Global.player and !Global.player.busy):
		visible = true;
	else:
		visible = false;
	pass
	
func toggleQuests():
	if is_opened:
		animationPlayer.play("close_quests");
		is_opened = false;
	else:
		animationPlayer.play("open_quests");
		is_opened = true;
	
	Global.quest_list_show.emit(is_opened)


func finishFishermanQuest():
	fishermanQuest.text = "[right][s]Help fisherman";
	fishermanQuest.modulate = dim
	isFishermanQuestFinished = true;
	checkAllQuestsFinished();
	
func finishBabushkaQuest():
	babushkaQuest.text = "[right][s]Help your neighbour";
	babushkaQuest.modulate = dim
	isBabushkaQuestFinished = true;
	checkAllQuestsFinished();

func finishSnowboardQuest():
	showboardQuest.text = "[right][s]Challenge with Bob";
	showboardQuest.modulate = dim
	isSnowboardQuestFinished = true;
	checkAllQuestsFinished();
	
func finishTaikoQuest():
	taikoQuest.text = "[right][s]Help a band";
	taikoQuest.modulate = dim
	isTaikoQuestFinished = true;
	checkAllQuestsFinished();
	
func checkAllQuestsFinished():
	if(!isFishermanQuestFinished and isBabushkaQuestFinished and !isSnowboardQuestFinished and !isTaikoQuestFinished):
		startReturnToHomeQuest();
		
func startReturnToHomeQuest():
	fishermanQuest.visible = false;
	babushkaQuest.visible = false;
	taikoQuest.visible = false;
	showboardQuest.visible = false;
	returnToHomeQuest.visible = true;
	Global.main_screen.play_mini_by_name("returnToHome");
	pass;

func end_game():
	pass;

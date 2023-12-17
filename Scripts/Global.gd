extends Node

signal quest_list_show(state: bool)

var useObjectController: UseObjectController;
var playerLayout: PlayerLayout;
var player: CharacterBody3D
var cutscener: Cutscener;
var main_screen: MainScreen;
var currentTimDoppelganger: TimDoppelganger;
var audioStreamPlayer: AudioStreamPlayer; 

var babushkaMiniGame: BabushkaQuestMiniGame;
var band = null

var questListUI: QuestListUI;



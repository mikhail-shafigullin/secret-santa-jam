class_name PlayerLayout
extends Control

@onready var useMessageText: RichTextLabel = %UseMessageText

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.playerLayout = self;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setTextOnUseMessage(message: String):
	useMessageText.text = "[center]" + message;

func clearTextOnUseMessage():
	useMessageText.text = "[center]";

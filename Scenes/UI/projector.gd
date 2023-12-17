class_name Projector
extends Control

@onready var image: TextureRect = %Slide

#context ballon
var balloon = null

const balloon_res = preload("res://Scenes/Screens/my_balloon/my_balloon.tscn")

func start_dialogue(path: String, start: String = ""):
	if balloon:
		balloon.queue_free()
	balloon = balloon_res.instantiate()
	add_child(balloon)
	balloon.start(load(path), "")


func slide(path: String = ""):
	if path == "" or path == null:
		image.texture = null
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		return

	var texture = load(path)
	assert(texture is Texture2D)
	image.texture = texture
	mouse_filter = Control.MOUSE_FILTER_STOP

func _ready():
	Global.projector = self
	slide()
	start_dialogue("res://Scenes/UI/projector_test.dialogue")

class_name Projector
extends Control

@onready var image: TextureRect = %Slide
@onready var musicPlayer: AudioStreamPlayer = %Music
@onready var soundPlayer: AudioStreamPlayer = %Sounds;

var allow_skip: bool = false
var working: bool = false

#context ballon
var balloon = null

const balloon_res = preload("res://Scenes/Screens/my_balloon/my_balloon.tscn")

func start_dialogue(path: String, start: String = ""):
	if balloon:
		balloon.queue_free()
	balloon = balloon_res.instantiate()
	add_child(balloon)
	balloon.connect("tree_exiting", on_balloon_exit)
	balloon.start(load(path), "")
	working = true

func on_balloon_exit():
	slide()
	sound()
	allow_skip = true
	working = false

func slide(path: String = ""):
	if path == "" or path == null:
		image.texture = null
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		return

	var texture = load(path)
	assert(texture is Texture2D)
	image.texture = texture
	mouse_filter = Control.MOUSE_FILTER_STOP

func sound(path: String = ""):
	soundPlayer.stop()
	if path == "":
		return
	var _sound = load(path)
	soundPlayer.stream = _sound
	soundPlayer.play()
	
func music(path: String = ""):
	musicPlayer.stop()
	if path == "":
		return
	var _sound = load(path)
	musicPlayer.stream = _sound
	musicPlayer.play()
	
func set_allow_skip(allow: bool):
	allow_skip = allow

func _ready():
	Global.projector = self
	slide()
	Global.projector.start_dialogue("res://Assets/UI/startScene.dialogue");

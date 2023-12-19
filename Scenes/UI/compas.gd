extends Control

var texture_width: int = 720
var view_width: int = 200

@onready var markers_root: Control = %Markers
@onready var ruler: TextureRect = %Ruler

var markers: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("quest_marker_update", update_marker)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		update_deg()

func update_deg():
	if Global.player != null:
		var pix_in_deg = float(texture_width)/360.0
		var deg = rad_to_deg(-Global.player.get_camera_ang_rad())
		var pixels = deg*pix_in_deg
		var half_width = view_width * 0.5
		ruler.position.x = fmod(pixels, 180)
		for locator in markers.keys():
			var sprite = markers[locator]
			var _deg = get_deg(locator.global_position)
			var _pixels = _deg*pix_in_deg
			sprite.position.x = _pixels
	else:
		visible = false

func get_deg(pos: Vector3):
	var camera = Global.player.camera
	var camera_v = Vector2(camera.global_position.x, camera.global_position.z)
	var player_v = Vector2(Global.player.global_position.x, Global.player.global_position.z)
	var player_ang = camera_v.angle_to_point(player_v)
	var pos_ang = camera_v.angle_to_point(Vector2(pos.x, pos.z))
	var a = fmod(rad_to_deg(pos_ang - player_ang + PI), 360) - 180
	if a < -180:
		a += 360
	return a 

func update_marker(locator: QuestLocator):
	if locator.visible and locator.get_parent().visible:
		add_marker(locator)
	else:
		remove_marker(locator)

func add_marker(locator: QuestLocator):
	assert(not markers.keys().has(locator))
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Assets/Sprites/BalanceMeterArrow.png")
	markers_root.add_child(sprite)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	markers[locator] = sprite

func remove_marker(locator: QuestLocator):
	if markers.keys().has(locator):
		markers[locator].queue_free()
		markers.erase(locator)

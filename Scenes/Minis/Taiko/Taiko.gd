extends MiniGame

@onready var c = Global.cutscener
@onready var hit_marker = $TaikoScreen/TaikoLine/Panel/Panel/HitMarker
@onready var hit_marker_col = hit_marker.modulate
@onready var hit_gold = $TaikoScreen/TaikoLine/Panel/Panel/HitGold
@onready var hit_ok = $TaikoScreen/TaikoLine/Panel/Panel/HitOk
@onready var hit_fail = $TaikoScreen/TaikoLine/Panel/Panel/HitFail
var hit_timer = Timer.new()
var model = null
var tim = null
var notes: Array[Note] = []
@onready var hit_center: Node2D = %HitCenter
var time: float = 0
@export var visible_time := 3.0
@export var speed := 100.0
@export var time_window = 0.5

var combo: int;
var max_combo: int;
var score: int;

const KatSpriteRes = preload ("res://Scenes/Minis/Taiko/BlueSprite.tscn")
const DonSpriteRes = preload ("res://Scenes/Minis/Taiko/OrangeSprite.tscn")

const music = {2.7: 'D', 3.73: 'K', 5.28: 'K', 7.43: 'K', 9.04: 'D', 10.72: 'D', 13.31: 'D', 14.44: 'D', 16.05: 'D', 18.05: 'K', 19.65: 'K', 21.34: 'D', 23.38: 'K', 24.09: 'K', 24.82: 'K', 26.6: 'K', 28.71: 'D', 29.38: 'K', 30.12: 'K', 31.98: 'D', 33.08: 'D', 34.65: 'K', 37.32: 'D', 38.31: 'D', 39.57: 'D', 40.07: 'D', 40.57: 'D', 41.07: 'K', 42.65: 'D', 43.15: 'D', 44.54: 'D', 46.5: 'K', 47.63: 'K', 48.14: 'K', 49.02: 'K', 49.37: 'K', 49.72: 'K', 50.05: 'K', 50.35: 'K', 50.71: 'D', 51.69: 'K', 52.02: 'K', 52.83: 'D', 53.33: 'D', 54.37: 'K', 54.72: 'K', 55.07: 'K', 55.4: 'K', 55.7: 'K', 56.03: 'D', 57.57: 'K', 58.2: 'K', 58.53: 'K', 58.83: 'K', 60.07: 'D', 61.37: 'D', 61.87: 'D', 62.37: 'D', 64.1: 'D', 65.1: 'D', 66.37: 'D', 67.37: 'D'}


enum NoteType {
	KAT,
	DON,
	NONE,
	END
}

class Note:
	var type: NoteType
	var time: float
	var sprite: AnimatedSprite2D
	func _init(_type: NoteType, _time: float, _sprite: AnimatedSprite2D):
		type = _type
		time = _time	
		sprite = _sprite

enum HIT_TYPE {
	ponL,
	katL,
	ponR,
	katR
}
enum HIT_EFFECT {
	gold = 0,
	ok,
	fail,
	empty
}

var last_index: int = 0
func spawn_next_note():
	var note_time = music.keys()[last_index]
	if (time + visible_time) > note_time:
		print("spawned", note_time)
		var type: NoteType
		var sprite: AnimatedSprite2D
		if music[note_time] == "D":
			type = NoteType.DON
			sprite = DonSpriteRes.instantiate()
		else:
			type = NoteType.KAT
			sprite = KatSpriteRes.instantiate()
		last_index += 1
		
		hit_center.add_child(sprite)
		sprite.global_position = hit_center.global_position - Vector2(speed*(time - note_time),0)
		notes.append(Note.new(type, note_time, sprite))
	
func _process(delta):
	time += delta
	spawn_next_note()
	for note in notes:
		note.sprite.global_position.x -= speed*delta
	
	check_miss()

func check_miss():
	var distance = get_note_dist()
	if distance <= - speed * time_window/2:
		if get_note_type() == NoteType.END:
			end()
		else:
			var left_note = notes[0]
			left_note.sprite.queue_free()
			notes.remove_at(0)
			on_miss()
		
func on_miss():
	print("miss")
	combo = 0;


func on_hit(type: NoteType):
	var dist = get_note_dist()
	var note_type = get_note_type()
	if abs(dist) < time_window:
		if type != note_type:
			if dist > time_window - time_window*0.1:
				on_miss();
				return
		else:
			hit_anim(score_dist(dist))
	hit_anim()
			
func score_dist(dist: float) -> HIT_EFFECT:
	var max = time_window / 2
	if abs(dist) < max * 0.8:
		return HIT_EFFECT.gold
	if abs(dist) > max *0.8:
		return HIT_EFFECT.ok
	if abs(dist) > max:
		return HIT_EFFECT.fail
	return HIT_EFFECT.empty

func on_kat():
	model.kat.play()
	if get_note_type() == NoteType.KAT:
		on_hit(NoteType.KAT)

func on_pon():
	model.pon.play()
	if get_note_type() == NoteType.DON:
		on_hit(NoteType.DON)

func get_note() -> Note:
	if notes.is_empty():
		return Note.new(NoteType.NONE, 9001, null)
	return notes[0] 

func get_note_type() -> NoteType:
	if notes.is_empty():
		return NoteType.NONE
	return notes[0].type

func get_note_dist() -> float:
	if notes.is_empty():
		return 9001.0
	var distance: float = notes[0].sprite.global_position.x - hit_center.global_position.x
	return distance
	
func _ready():
	add_child(hit_timer)
	hit_timer.one_shot=true
	hit_timer.wait_time=0.16
	hit_timer.connect("timeout", hit_timeout)
	
func _input(event):
	if event.is_action_pressed("taiko_pon_left"):
		hit(HIT_TYPE.ponL)
	if event.is_action_pressed("taiko_kat_left"):
		hit(HIT_TYPE.katL)
	if event.is_action_pressed("taiko_pon_right"):
		hit(HIT_TYPE.ponR)
	if event.is_action_pressed("taiko_kat_right"):
		hit(HIT_TYPE.katR)
		
func hit(type: HIT_TYPE):
	match type:
		HIT_TYPE.ponL:
			on_pon()
			play_blend("LeftDon")
		HIT_TYPE.katL:
			on_kat()
			play_blend("LeftKat")
		HIT_TYPE.ponR:
			on_pon()
			play_blend("RightDon")
		HIT_TYPE.katR:
			on_kat()
			play_blend("RightKat")
	
func start() -> bool:
	if not c:
		return false
	
	if (not c.has_animation("taiko_start")
		or not c.has_animation("taiko_rest")):
		return false
	
	Global.player.set_busy(true)
	Global.player.visible=false
	c.start("taiko_start", false)
	tim = model.tim
	
	model.music.play()

	tim.visible=true
	tim.taiko_tree.active=true

	return true

func end() -> void:
	tim.taiko_tree.active=false
	tim.visible=false
	model.music.stop()
	c.start("taiko_rest", false)

	Global.player.visible=true
	Global.player.set_busy(false)
	Global.cutscener.end()
	queue_free()

func _on_exit_pressed():
	end()

func hit_anim(type: HIT_EFFECT=HIT_EFFECT.empty):
	match type:
		HIT_EFFECT.gold:
			hit_gold.visible=true
		HIT_EFFECT.ok:
			hit_ok.visible=true
		HIT_EFFECT.fail:
			hit_fail.visible=true
		_:
			pass
	hit_marker.modulate=Color.WHITE
	hit_timer.start()

func hit_timeout():
	hit_marker.modulate=hit_marker_col
	hit_gold.visible=false
	hit_ok.visible=false
	hit_fail.visible=false
	
func play_blend(name: String):
	tim.taiko_tree["parameters/%s/request" %name]=AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
